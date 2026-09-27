-- Only the quantity accepted by the integrator is stored as a contractual return.
-- The physical difference becomes a company-owned lot at the source contract price.
create table public.logistics_mitra_retained_feed (
  id uuid primary key default gen_random_uuid(),
  return_id uuid not null references public.logistics_returns(id) on delete restrict,
  return_item_id uuid unique references public.logistics_return_items(id) on delete restrict,
  source_assignment_id uuid not null references public.logistics_contract_assignments(id),
  item_id uuid not null references public.items(id),
  quantity numeric not null check (quantity>0),
  unit_price numeric not null check (unit_price>=0),
  created_by uuid not null default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now(),
  unique(return_id,item_id)
);
create index on public.logistics_mitra_retained_feed(source_assignment_id,item_id);
alter table public.logistics_mitra_retained_feed enable row level security;
create policy mitra_retained_read on public.logistics_mitra_retained_feed
for select to authenticated
using (private.my_bms_role() in ('ADMIN','LOGISTIK','PPL','KEUANGAN','OWNER'));
revoke all on public.logistics_mitra_retained_feed from public,anon,authenticated;
grant select on public.logistics_mitra_retained_feed to authenticated;

create or replace function public.save_mitra_split_return_atomic(
  p_barn_id uuid,p_assignment_id uuid,p_return_date date,p_reference text,p_notes text,p_items jsonb
) returns uuid language plpgsql security definer set search_path='' as $$
declare
  v_id uuid;
  v_item record;
  v_sent numeric;
  v_prev_physical numeric;
  v_used numeric;
  v_accepted jsonb:='[]'::jsonb;
  v_return_item public.logistics_return_items%rowtype;
  v_price numeric;
begin
  if private.my_bms_role() not in ('ADMIN','LOGISTIK') then raise exception 'Akses ditolak.'; end if;
  if p_return_date is null then raise exception 'Tanggal retur wajib diisi.'; end if;
  if not exists(select 1 from public.logistics_contract_assignments a
                where a.id=p_assignment_id and a.barn_id=p_barn_id and a.active
                  and a.cycle_type='MITRA' and a.start_date<=p_return_date)
  then raise exception 'Siklus Mitra asal harus aktif.'; end if;
  -- Serialize two return requests for the same cycle before checking stock.
  perform 1 from public.logistics_contract_assignments a where a.id=p_assignment_id for update;
  if p_items is null or jsonb_typeof(p_items)<>'array' or jsonb_array_length(p_items)=0
  then raise exception 'Minimal satu pakan retur wajib diisi.'; end if;
  for v_item in
    select (x->>'item_id')::uuid item_id,
           sum((x->>'physical_quantity')::numeric) physical_qty,
           sum((x->>'accepted_quantity')::numeric) accepted_qty
    from jsonb_array_elements(p_items) x group by (x->>'item_id')::uuid
  loop
    if v_item.physical_qty is null or v_item.accepted_qty is null
      or v_item.physical_qty='NaN'::numeric or v_item.accepted_qty='NaN'::numeric
      or v_item.physical_qty<=0 or v_item.accepted_qty<0 or v_item.accepted_qty>v_item.physical_qty
    then raise exception 'Jumlah fisik dan jumlah diakui inti tidak valid.'; end if;
    if not exists(select 1 from public.items i where i.id=v_item.item_id and i.category='PAKAN')
    then raise exception 'Retur terpisah saat ini khusus Pakan.'; end if;
    select coalesce(sum(si.quantity),0) into v_sent
    from public.logistics_shipments s
    join public.logistics_shipment_items si on si.shipment_id=s.id
    where s.contract_assignment_id=p_assignment_id and si.item_id=v_item.item_id;
    select coalesce(sum(ri.quantity),0) into v_prev_physical
    from public.logistics_returns r
    join public.logistics_return_items ri on ri.return_id=r.id
    where r.contract_assignment_id=p_assignment_id and ri.item_id=v_item.item_id;
    v_prev_physical:=v_prev_physical+coalesce((select sum(rs.quantity)
      from public.logistics_mitra_retained_feed rs
      where rs.source_assignment_id=p_assignment_id and rs.item_id=v_item.item_id),0);
    select coalesce(sum(rec.feed_quantity_units),0) into v_used
    from public.recordings rec
    where rec.contract_assignment_id=p_assignment_id and rec.feed_item_id=v_item.item_id;
    if v_item.physical_qty>v_sent-v_prev_physical-v_used
    then raise exception 'Sisa fisik pakan tersedia %.',greatest(0,v_sent-v_prev_physical-v_used); end if;
    if v_item.accepted_qty>0 then
      v_accepted:=v_accepted||jsonb_build_array(
        jsonb_build_object('item_id',v_item.item_id,'quantity',v_item.accepted_qty));
    end if;
  end loop;
  if jsonb_array_length(v_accepted)>0 then
    v_id:=public.save_logistics_return_atomic(null,p_barn_id,p_assignment_id,p_return_date,p_reference,p_notes,v_accepted);
  else
    insert into public.logistics_returns(barn_id,contract_assignment_id,return_date,reference,notes)
    values(p_barn_id,p_assignment_id,p_return_date,p_reference,p_notes) returning id into v_id;
  end if;
  for v_item in
    select (x->>'item_id')::uuid item_id,
           sum((x->>'physical_quantity')::numeric-(x->>'accepted_quantity')::numeric) retained_qty
    from jsonb_array_elements(p_items) x group by (x->>'item_id')::uuid
  loop
    if v_item.retained_qty<=0 then continue; end if;
    select ri.* into v_return_item from public.logistics_return_items ri
      where ri.return_id=v_id and ri.item_id=v_item.item_id;
    v_price:=v_return_item.unit_price;
    if v_price is null then
      select si.unit_price into v_price from public.logistics_shipment_items si
      join public.logistics_shipments s on s.id=si.shipment_id
      where s.contract_assignment_id=p_assignment_id and si.item_id=v_item.item_id
      order by s.shipment_date desc,si.created_at desc limit 1;
    end if;
    if v_price is null then raise exception 'Harga kontrak pakan asal tidak ditemukan.'; end if;
    insert into public.logistics_mitra_retained_feed(
      return_id,return_item_id,source_assignment_id,item_id,quantity,unit_price)
    values(v_id,v_return_item.id,p_assignment_id,v_item.item_id,v_item.retained_qty,v_price);
  end loop;
  return v_id;
end $$;
revoke all on function public.save_mitra_split_return_atomic(uuid,uuid,date,text,text,jsonb) from public,anon;
grant execute on function public.save_mitra_split_return_atomic(uuid,uuid,date,text,text,jsonb) to authenticated;

-- Each movement keeps the original contract lot and price. OUT is a physical
-- return from a receiving barn to the BMS warehouse; it does not alter the
-- integrator's accepted return on the original Mitra cycle.
create table public.logistics_company_feed_movements (
  id uuid primary key default gen_random_uuid(),
  retained_feed_id uuid not null references public.logistics_mitra_retained_feed(id) on delete restrict,
  contract_assignment_id uuid not null references public.logistics_contract_assignments(id),
  direction text not null check (direction in ('IN','OUT')),
  quantity numeric not null check (quantity>0),
  transferred_on date not null default current_date,
  reference text,
  created_by uuid not null default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now()
);
create index on public.logistics_company_feed_movements(retained_feed_id,contract_assignment_id);
alter table public.logistics_company_feed_movements enable row level security;
create policy company_feed_movement_read on public.logistics_company_feed_movements
for select to authenticated using (private.my_bms_role() in ('ADMIN','LOGISTIK','PPL','KEUANGAN','OWNER'));
revoke all on public.logistics_company_feed_movements from public,anon,authenticated;
grant select on public.logistics_company_feed_movements to authenticated;

create or replace function public.move_company_feed_atomic(
  p_retained_feed_id uuid,p_contract_assignment_id uuid,p_direction text,
  p_quantity numeric,p_transferred_on date,p_reference text
) returns uuid language plpgsql security definer set search_path='' as $$
declare
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_cycle public.logistics_contract_assignments%rowtype;
  v_warehouse numeric;
  v_at_cycle numeric;
  v_feed_available numeric;
  v_id uuid;
begin
  if private.my_bms_role() not in ('ADMIN','LOGISTIK') then raise exception 'Akses ditolak.'; end if;
  if p_direction not in ('IN','OUT') or p_quantity is null or p_quantity='NaN'::numeric
     or p_quantity<=0 or p_transferred_on is null
  then raise exception 'Arah, tanggal, dan jumlah perpindahan wajib valid.'; end if;
  select * into v_lot from public.logistics_mitra_retained_feed where id=p_retained_feed_id for update;
  if not found then raise exception 'Stok BMS asal tidak ditemukan.'; end if;
  select * into v_cycle from public.logistics_contract_assignments where id=p_contract_assignment_id for update;
  if not found or not v_cycle.active then raise exception 'Siklus tujuan harus aktif.'; end if;
  if p_transferred_on<v_cycle.start_date then raise exception 'Tanggal sebelum awal siklus.'; end if;
  if p_direction='IN' and v_cycle.id=v_lot.source_assignment_id
  then raise exception 'Stok tidak dapat dikirim kembali ke siklus asal melalui pemindahan.'; end if;
  select v_lot.quantity+coalesce(sum(case when m.direction='OUT' then m.quantity else -m.quantity end),0)
    into v_warehouse from public.logistics_company_feed_movements m
    where m.retained_feed_id=v_lot.id;
  if p_direction='IN' and p_quantity>v_warehouse then
    raise exception 'Stok gudang BMS hanya %.',v_warehouse; end if;
  if p_direction='OUT' then
    select coalesce(sum(case when m.direction='IN' then m.quantity else -m.quantity end),0)
      into v_at_cycle from public.logistics_company_feed_movements m
      where m.retained_feed_id=v_lot.id and m.contract_assignment_id=v_cycle.id;
    select
      coalesce((select sum(si.quantity) from public.logistics_shipments s
        join public.logistics_shipment_items si on si.shipment_id=s.id
        where s.contract_assignment_id=v_cycle.id and si.item_id=v_lot.item_id),0)
      +coalesce((select sum(ei.quantity) from public.logistics_external_shipments e
        join public.logistics_external_shipment_items ei on ei.external_shipment_id=e.id
        where e.contract_assignment_id=v_cycle.id and ei.item_id=v_lot.item_id),0)
      +coalesce((select sum(ma.quantity) from public.logistics_mandiri_purchase_allocations ma
        join public.logistics_mandiri_purchases mp on mp.id=ma.purchase_id
        where ma.contract_assignment_id=v_cycle.id and mp.item_id=v_lot.item_id),0)
      +coalesce((select sum(case when m.direction='IN' then m.quantity else -m.quantity end)
        from public.logistics_company_feed_movements m
        join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
        where m.contract_assignment_id=v_cycle.id and l.item_id=v_lot.item_id),0)
      -coalesce((select sum(ri.quantity) from public.logistics_returns r
        join public.logistics_return_items ri on ri.return_id=r.id
        where r.contract_assignment_id=v_cycle.id and ri.item_id=v_lot.item_id),0)
      -coalesce((select sum(l.quantity) from public.logistics_mitra_retained_feed l
        where l.source_assignment_id=v_cycle.id and l.item_id=v_lot.item_id),0)
      -coalesce((select sum(rec.feed_quantity_units) from public.recordings rec
        where rec.contract_assignment_id=v_cycle.id and rec.feed_item_id=v_lot.item_id),0)
      into v_feed_available;
    if p_quantity>least(v_at_cycle,v_feed_available) then
      raise exception 'Sisa pakan di kandang tidak cukup untuk retur ke stok BMS.'; end if;
  end if;
  insert into public.logistics_company_feed_movements(
    retained_feed_id,contract_assignment_id,direction,quantity,transferred_on,reference)
  values(p_retained_feed_id,p_contract_assignment_id,p_direction,p_quantity,p_transferred_on,p_reference)
  returning id into v_id;
  return v_id;
end $$;
revoke all on function public.move_company_feed_atomic(uuid,uuid,text,numeric,date,text) from public,anon;
grant execute on function public.move_company_feed_atomic(uuid,uuid,text,numeric,date,text) to authenticated;

-- Split documents cannot be silently edited through the older single-quantity form.
create or replace function public.guard_split_return() returns trigger
language plpgsql set search_path='' as $$
begin
  if tg_table_name='logistics_returns' then
    if exists(select 1 from public.logistics_mitra_retained_feed l where l.return_id=old.id) then
      raise exception 'Retur dengan stok BMS terkunci. Buat koreksi tercatat terpisah.';
    end if;
  elsif exists(select 1 from public.logistics_mitra_retained_feed l where l.return_item_id=old.id) then
    raise exception 'Retur dengan stok BMS terkunci. Buat koreksi tercatat terpisah.';
  end if;
  return old;
end $$;
create trigger guard_split_return_header before update or delete on public.logistics_returns
for each row execute function public.guard_split_return();
create trigger guard_split_return_line before update or delete on public.logistics_return_items
for each row execute function public.guard_split_return();


CREATE OR REPLACE FUNCTION public.finance_rhpp_summary_v3()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, main_feed_kg numeric, external_feed_kg numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, main_doc_cost numeric, main_feed_cost numeric, main_ovk_cost numeric, main_other_cost numeric, main_return_cost numeric, external_sapronak_cost numeric, sapronak_cost numeric, external_meat_cost numeric, total_rhpp_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality_rate numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, population_balanced boolean, ready_financial boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with harvest as (
    select h.contract_assignment_id,
           sum(h.birds)::numeric birds,
           sum(h.net_weight_kg)::numeric kg,
           sum(h.total_amount)::numeric value,
           sum(h.birds*((h.harvested_on-ci.arrived_on)+1))::numeric/nullif(sum(h.birds),0) weighted_age
    from public.marketing_contract_harvests h
    join public.chick_ins ci on ci.contract_assignment_id=h.contract_assignment_id
    group by h.contract_assignment_id
  ),
  main_ship as (
    select s.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then si.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(case when i.category='DOC' then si.quantity*si.unit_price else 0 end),0)::numeric doc_cost,
           coalesce(sum(case when i.category='PAKAN' then si.quantity*si.unit_price else 0 end),0)::numeric feed_cost,
           coalesce(sum(case when i.category='OVK' then si.quantity*si.unit_price else 0 end),0)::numeric ovk_cost,
           coalesce(sum(case when i.category not in ('DOC','PAKAN','OVK') then si.quantity*si.unit_price else 0 end),0)::numeric other_cost,
           coalesce(sum(si.quantity*si.unit_price),0)::numeric total_cost
    from public.logistics_shipments s
    join public.logistics_shipment_items si on si.shipment_id=s.id
    join public.items i on i.id=si.item_id
    group by s.contract_assignment_id
  ),
  main_ret as (
    select r.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then ri.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(ri.quantity*ri.unit_price),0)::numeric total_cost
    from public.logistics_returns r
    join public.logistics_return_items ri on ri.return_id=r.id
    join public.items i on i.id=ri.item_id
    group by r.contract_assignment_id
  ),
  retained_feed as (
    select l.source_assignment_id contract_assignment_id,
           sum(l.quantity*coalesce(i.kg_per_unit,0))::numeric feed_kg
    from public.logistics_mitra_retained_feed l
    join public.items i on i.id=l.item_id
    group by l.source_assignment_id
  ),
  ext_ship as (
    select e.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then ei.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(ei.quantity*ei.purchase_unit_price),0)::numeric total_cost
    from public.logistics_external_shipments e
    join public.logistics_external_shipment_items ei on ei.external_shipment_id=e.id
    join public.items i on i.id=ei.item_id
    group by e.contract_assignment_id
  ),
  ext_ret as (
    select er.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then eri.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(eri.quantity*eri.purchase_unit_price),0)::numeric total_cost
    from public.logistics_external_returns er
    join public.logistics_external_return_items eri on eri.external_return_id=er.id
    join public.items i on i.id=eri.item_id
    group by er.contract_assignment_id
  ),
  transfer_in as (
    select t.target_contract_assignment_id contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then t.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(t.quantity*t.unit_price),0)::numeric total_cost
    from public.logistics_external_return_transfers t
    join public.items i on i.id=t.item_id
    group by t.target_contract_assignment_id
  ),
  company_in as (
    select m.contract_assignment_id,sum(m.quantity*i.kg_per_unit)::numeric feed_kg,
           sum(m.quantity*l.unit_price)::numeric total_cost
    from public.logistics_company_feed_movements m
    join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    join public.items i on i.id=l.item_id where m.direction='IN'
    group by m.contract_assignment_id
  ),
  company_out as (
    select m.contract_assignment_id,sum(m.quantity*i.kg_per_unit)::numeric feed_kg,
           sum(m.quantity*l.unit_price)::numeric total_cost
    from public.logistics_company_feed_movements m
    join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    join public.items i on i.id=l.item_id where m.direction='OUT'
    group by m.contract_assignment_id
  ),
  meat as (
    select m.contract_assignment_id,
           coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric total_cost
    from public.marketing_external_meat_purchases m
    group by m.contract_assignment_id
  ),
  rec_dep as (
    select r.contract_assignment_id,coalesce(sum(r.mortality+r.culling),0)::numeric birds
    from public.recordings r group by r.contract_assignment_id
  ),
  raw as (
    select
      a.id assignment_id,a.barn_id,b.code barn_code,b.name barn_name,c.number contract_number,a.active,
      (ci.received-ci.doa)::numeric chick_in_birds,
      coalesce(h.birds,0)::numeric total_harvest_birds,
      coalesce(h.kg,0)::numeric total_harvest_kg,
      case when coalesce(h.birds,0)>0 then h.kg/h.birds else 0 end::numeric avg_bw_kg,
      coalesce(h.weighted_age,0)::numeric weighted_age,
      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric implied_depletion_birds,
      coalesce(rd.birds,0)::numeric recorded_depletion_birds,
      (((ci.received-ci.doa)-coalesce(h.birds,0))-coalesce(rd.birds,0))::numeric depletion_variance_birds,
      case when (ci.received-ci.doa)>0 then (coalesce(rd.birds,0)/(ci.received-ci.doa))*100 else 0 end::numeric mortality_pct,
      greatest(0,coalesce(ms.feed_kg,0)-coalesce(mr.feed_kg,0)-coalesce(rf.feed_kg,0))::numeric main_feed_kg,
      greatest(0,coalesce(es.feed_kg,0)-coalesce(er.feed_kg,0)+coalesce(ti.feed_kg,0)+coalesce(cin.feed_kg,0)-coalesce(cout.feed_kg,0))::numeric external_feed_kg,
      greatest(0,coalesce(ms.feed_kg,0)-coalesce(mr.feed_kg,0)-coalesce(rf.feed_kg,0)+coalesce(es.feed_kg,0)-coalesce(er.feed_kg,0)+coalesce(ti.feed_kg,0)+coalesce(cin.feed_kg,0)-coalesce(cout.feed_kg,0))::numeric net_feed_kg,
      coalesce(h.value,0)::numeric harvest_value,
      greatest(0,coalesce(ms.doc_cost,0))::numeric main_doc_cost,
      greatest(0,coalesce(ms.feed_cost,0))::numeric main_feed_cost,
      greatest(0,coalesce(ms.ovk_cost,0))::numeric main_ovk_cost,
      greatest(0,coalesce(ms.other_cost,0))::numeric main_other_cost,
      greatest(0,coalesce(mr.total_cost,0))::numeric main_return_cost,
      greatest(0,coalesce(es.total_cost,0)-coalesce(er.total_cost,0)+coalesce(ti.total_cost,0)+coalesce(cin.total_cost,0)-coalesce(cout.total_cost,0))::numeric external_sapronak_cost,
      greatest(0,coalesce(ms.total_cost,0)-coalesce(mr.total_cost,0)+coalesce(es.total_cost,0)-coalesce(er.total_cost,0)+coalesce(ti.total_cost,0)+coalesce(cin.total_cost,0)-coalesce(cout.total_cost,0))::numeric sapronak_cost,
      greatest(0,coalesce(me.total_cost,0))::numeric external_meat_cost,
      a.master_contract_id,a.performance_template_name
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    join public.contracts c on c.id=a.master_contract_id
    join public.chick_ins ci on ci.contract_assignment_id=a.id
    left join harvest h on h.contract_assignment_id=a.id
    left join main_ship ms on ms.contract_assignment_id=a.id
    left join main_ret mr on mr.contract_assignment_id=a.id
    left join retained_feed rf on rf.contract_assignment_id=a.id
    left join ext_ship es on es.contract_assignment_id=a.id
    left join ext_ret er on er.contract_assignment_id=a.id
    left join transfer_in ti on ti.contract_assignment_id=a.id
    left join company_in cin on cin.contract_assignment_id=a.id
    left join company_out cout on cout.contract_assignment_id=a.id
    left join meat me on me.contract_assignment_id=a.id
    left join rec_dep rd on rd.contract_assignment_id=a.id
  ),
  metrics as (
    select r.*,
      case when r.total_harvest_kg>0 then r.net_feed_kg/r.total_harvest_kg else 0 end::numeric fcr_actual,
      lo.age_days lo_age,lo.std_fcr lo_fcr,hi.age_days hi_age,hi.std_fcr hi_fcr
    from raw r
    left join lateral (
      select ps.age_days,ps.std_fcr from public.performance_standards ps
      where ps.contract_id=r.master_contract_id and ps.template_name=r.performance_template_name and ps.age_days<=r.weighted_age
      order by ps.age_days desc limit 1
    ) lo on true
    left join lateral (
      select ps.age_days,ps.std_fcr from public.performance_standards ps
      where ps.contract_id=r.master_contract_id and ps.template_name=r.performance_template_name and ps.age_days>=r.weighted_age
      order by ps.age_days asc limit 1
    ) hi on true
  ),
  scored as (
    select m.*,
      case
        when m.lo_fcr is null then m.hi_fcr when m.hi_fcr is null then m.lo_fcr
        when m.hi_age=m.lo_age then m.lo_fcr
        else m.lo_fcr+((m.weighted_age-m.lo_age)/(m.hi_age-m.lo_age))*(m.hi_fcr-m.lo_fcr)
      end::numeric fcr_standard,
      case when m.weighted_age>0 and m.fcr_actual>0 then ((100-m.mortality_pct)*m.avg_bw_kg*100)/(m.weighted_age*m.fcr_actual) else 0 end::numeric ip
    from metrics m
  ),
  bonus_rates as (
    select s.*,
      coalesce(ipb.rupiah_per_kg,0)::numeric bonus_ip_rate,
      coalesce(fcb.rupiah_per_kg,0)::numeric bonus_fc_rate,
      coalesce(db.rupiah_per_kg,0)::numeric bonus_mortality_rate
    from scored s
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='IP'
        and (cb.min_value is null or s.ip>=cb.min_value)
        and (cb.max_value is null or s.ip<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) ipb on true
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='FCR_DIFFERENCE'
        and (cb.min_value is null or (coalesce(s.fcr_standard,0)-s.fcr_actual)>=cb.min_value)
        and (cb.max_value is null or (coalesce(s.fcr_standard,0)-s.fcr_actual)<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) fcb on true
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='DEPLETION'
        and (cb.min_value is null or s.mortality_pct>=cb.min_value)
        and (cb.max_value is null or s.mortality_pct<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) db on true
  )
  select
    br.assignment_id,br.barn_id,br.barn_code,br.barn_name,br.contract_number,br.active,
    br.chick_in_birds,br.total_harvest_birds,br.total_harvest_kg,br.avg_bw_kg,br.weighted_age,
    br.implied_depletion_birds,br.recorded_depletion_birds,br.depletion_variance_birds,br.mortality_pct,
    br.main_feed_kg,br.external_feed_kg,br.net_feed_kg,
    br.fcr_actual,br.fcr_standard,(coalesce(br.fcr_standard,0)-br.fcr_actual)::numeric diff_fcr,br.ip,
    br.harvest_value,br.main_doc_cost,br.main_feed_cost,br.main_ovk_cost,br.main_other_cost,br.main_return_cost,
    br.external_sapronak_cost,br.sapronak_cost,br.external_meat_cost,
    (br.sapronak_cost+br.external_meat_cost)::numeric total_rhpp_cost,
    (br.harvest_value-br.sapronak_cost-br.external_meat_cost)::numeric base_profit,
    br.bonus_ip_rate,(br.total_harvest_kg*br.bonus_ip_rate)::numeric bonus_ip,
    br.bonus_fc_rate,(br.total_harvest_kg*br.bonus_fc_rate)::numeric bonus_fc,
    br.bonus_mortality_rate,(br.total_harvest_kg*br.bonus_mortality_rate)::numeric bonus_mortality,
    (br.harvest_value-br.sapronak_cost-br.external_meat_cost
      +br.total_harvest_kg*br.bonus_ip_rate
      +br.total_harvest_kg*br.bonus_fc_rate
      +br.total_harvest_kg*br.bonus_mortality_rate)::numeric farmer_profit,
    case when br.chick_in_birds>0 then
      (br.harvest_value-br.sapronak_cost-br.external_meat_cost
       +br.total_harvest_kg*br.bonus_ip_rate
       +br.total_harvest_kg*br.bonus_fc_rate
       +br.total_harvest_kg*br.bonus_mortality_rate)/br.chick_in_birds else 0 end::numeric profit_per_chick_in,
    case when br.total_harvest_birds>0 then
      (br.harvest_value-br.sapronak_cost-br.external_meat_cost
       +br.total_harvest_kg*br.bonus_ip_rate
       +br.total_harvest_kg*br.bonus_fc_rate
       +br.total_harvest_kg*br.bonus_mortality_rate)/br.total_harvest_birds else 0 end::numeric profit_per_harvested_bird,
    (abs(br.depletion_variance_birds)<0.5)::boolean population_balanced,
    (not br.active and abs(br.depletion_variance_birds)<0.5 and br.chick_in_birds>0 and br.total_harvest_birds>0 and br.total_harvest_kg>0 and br.net_feed_kg>0 and br.sapronak_cost>0)::boolean ready_financial
  from bonus_rates br
  order by br.active desc,br.barn_code;
end
$function$;




-- Include Mandiri purchase allocations in PPL feed stock for the corresponding cycle.
create or replace function public.production_feed_stock(p_contract_assignment_id uuid)
returns table(
  item_id uuid, code text, name text, unit text, kg_per_unit numeric,
  sent_units numeric, external_units numeric, returned_units numeric,
  used_units numeric, remaining_units numeric, remaining_kg numeric
)
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if v_role not in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role,'PPL'::public.bms_role) then
    raise exception 'Akses ditolak.';
  end if;

  if not exists (
    select 1
    from public.logistics_contract_assignments a
    where a.id=p_contract_assignment_id
      and (
        v_role in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role)
        or (v_role='PPL'::public.bms_role and a.ppl_id=auth.uid())
      )
  ) then
    raise exception 'Kontrak tidak ditemukan atau tidak dapat diakses.';
  end if;

  return query
  with feed as (
    select i.id item_id,i.code,i.name,i.unit,coalesce(i.kg_per_unit,0) kg_per_unit
    from public.items i where i.active=true and i.category='PAKAN'
  ),
  sent as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_shipments s
    join public.logistics_shipment_items li on li.shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ext as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_external_shipments s
    join public.logistics_external_shipment_items li on li.external_shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ret as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_returns r
    join public.logistics_return_items li on li.return_id=r.id
    where r.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  retained as (
    select l.item_id,sum(l.quantity) qty
    from public.logistics_mitra_retained_feed l
    where l.source_assignment_id=p_contract_assignment_id
    group by l.item_id
  ),
  company_move as (
    select l.item_id,sum(case when m.direction='IN' then m.quantity else -m.quantity end) qty
    from public.logistics_company_feed_movements m
    join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    where m.contract_assignment_id=p_contract_assignment_id
    group by l.item_id
  ),
  mandiri as (
    select p.item_id,coalesce(sum(a.quantity),0) qty
    from public.logistics_mandiri_purchase_allocations a
    join public.logistics_mandiri_purchases p on p.id=a.purchase_id
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id and ca.cycle_type='MANDIRI'
    where a.contract_assignment_id=p_contract_assignment_id
    group by p.item_id
  ),
  used as (
    select r.feed_item_id item_id,coalesce(sum(r.feed_quantity_units),0) qty
    from public.recordings r
    where r.contract_assignment_id=p_contract_assignment_id
    group by r.feed_item_id
  )
  select
    f.item_id,f.code,f.name,f.unit,f.kg_per_unit,
    coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0),coalesce(e.qty,0),coalesce(rt.qty,0)+coalesce(rs.qty,0),coalesce(u.qty,0),
    greatest(0,coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0)),
    greatest(0,coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0))*f.kg_per_unit
  from feed f
  left join sent s on s.item_id=f.item_id
  left join mandiri m on m.item_id=f.item_id
  left join company_move cm on cm.item_id=f.item_id
  left join retained rs on rs.item_id=f.item_id
  left join ext e on e.item_id=f.item_id
  left join ret rt on rt.item_id=f.item_id
  left join used u on u.item_id=f.item_id
  where coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(rs.qty,0)>0
  order by f.code;
end
$function$;



create or replace function public.finance_cycle_profit_loss_v2()
returns table(contract_assignment_id uuid,barn_id uuid,barn_code text,barn_name text,start_date date,active boolean,rhpp_system numeric,rhpp_real numeric,bop_produksi numeric,gaji_abk numeric,sapronak_luar numeric,tambah_daging numeric,kasbon_abk numeric,saldo_kasbon numeric,perawatan_jangka_panjang numeric,laba_operasional_produksi numeric,laba_bersih_akhir numeric)
language plpgsql security definer set search_path='' as $$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')) then raise exception 'Akses ditolak.'; end if;
  return query
  with bopx as (
    select b.contract_assignment_id,coalesce(sum(b.amount),0)::numeric bop,
      coalesce(sum(case when b.source_type='ABK_SALARY' then b.amount else 0 end),0)::numeric salary
    from public.bop b group by b.contract_assignment_id
  ), maint as (
    select m.contract_assignment_id,coalesce(sum(m.amount),0)::numeric amount from public.barn_maintenance_costs m group by m.contract_assignment_id
  ), ext_ship as (
    select h.contract_assignment_id,coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric amount
    from public.logistics_external_shipments h join public.logistics_external_shipment_items i on i.external_shipment_id=h.id group by h.contract_assignment_id
  ), ext_out as (
    select t.source_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.source_contract_assignment_id
  ), ext_in as (
    select t.target_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.target_contract_assignment_id
  ), mandiri_buy as (
    select a.contract_assignment_id,coalesce(sum(a.quantity*p.purchase_unit_price),0)::numeric amount
    from public.logistics_mandiri_purchase_allocations a join public.logistics_mandiri_purchases p on p.id=a.purchase_id group by a.contract_assignment_id
  ), retained_value as (
    select l.source_assignment_id contract_assignment_id,sum(l.quantity*l.unit_price)::numeric amount
    from public.logistics_mitra_retained_feed l group by l.source_assignment_id
  ), company_moves as (
    select m.contract_assignment_id,
      sum((case when m.direction='IN' then m.quantity else -m.quantity end)*l.unit_price)::numeric amount
    from public.logistics_company_feed_movements m
    join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    group by m.contract_assignment_id
  ), mandiri_sales as (
    select h.contract_assignment_id,coalesce(sum(h.total_amount),0)::numeric amount
    from public.marketing_contract_harvests h group by h.contract_assignment_id
  ), meat as (
    select m.contract_assignment_id,coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric amount
    from public.marketing_external_meat_purchases m group by m.contract_assignment_id
  ), adv as (
    select a.contract_assignment_id,coalesce(sum(a.amount),0)::numeric amount,
      coalesce(sum(a.amount-coalesce(p.paid,0)),0)::numeric balance
    from public.advances a
    left join (select advance_id,sum(amount) paid from public.advance_payments group by advance_id) p on p.advance_id=a.id
    where a.contract_assignment_id is not null group by a.contract_assignment_id
  ), base as (
    select a.id contract_assignment_id,a.barn_id,b.code,b.name,a.start_date,a.active,a.cycle_type,
      case when a.cycle_type='MANDIRI' then 0 else coalesce(sf.system_amount,0) end::numeric rhpp_system,
      case when a.cycle_type='MANDIRI' then coalesce(ms.amount,0) else coalesce(rr.amount,0) end::numeric rhpp_real,
      coalesce(bx.bop,0)::numeric bop_produksi,coalesce(bx.salary,0)::numeric gaji_abk,
      case when a.cycle_type='MANDIRI' then coalesce(mb.amount,0)+coalesce(cm.amount,0)
           else greatest(0,coalesce(es.amount,0)-coalesce(eo.amount,0)+coalesce(ei.amount,0))+coalesce(cm.amount,0)-coalesce(rv.amount,0) end::numeric sapronak_luar,
      coalesce(mt.amount,0)::numeric tambah_daging,coalesce(ad.amount,0)::numeric kasbon_abk,
      coalesce(ad.balance,0)::numeric saldo_kasbon,coalesce(mc.amount,0)::numeric perawatan_jangka_panjang
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    left join public.rhpp_system_final sf on sf.contract_assignment_id=a.id
    left join public.rhpp_real rr on rr.contract_assignment_id=a.id
    left join bopx bx on bx.contract_assignment_id=a.id
    left join maint mc on mc.contract_assignment_id=a.id
    left join ext_ship es on es.contract_assignment_id=a.id
    left join ext_out eo on eo.contract_assignment_id=a.id
    left join ext_in ei on ei.contract_assignment_id=a.id
    left join mandiri_buy mb on mb.contract_assignment_id=a.id
    left join retained_value rv on rv.contract_assignment_id=a.id
    left join company_moves cm on cm.contract_assignment_id=a.id
    left join mandiri_sales ms on ms.contract_assignment_id=a.id
    left join meat mt on mt.contract_assignment_id=a.id
    left join adv ad on ad.contract_assignment_id=a.id
  )
  select x.contract_assignment_id,x.barn_id,x.code,x.name,x.start_date,x.active,x.rhpp_system,x.rhpp_real,
    x.bop_produksi,x.gaji_abk,x.sapronak_luar,x.tambah_daging,x.kasbon_abk,x.saldo_kasbon,x.perawatan_jangka_panjang,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging)::numeric,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging-x.perawatan_jangka_panjang)::numeric
  from base x order by x.start_date desc,x.code;
end $$;
