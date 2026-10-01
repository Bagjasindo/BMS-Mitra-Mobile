-- A01, A11, A13: NULL-safe authorization and least privilege.

CREATE OR REPLACE FUNCTION private.assign_bms_role_impl(p_email text, p_role bms_role, p_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare target_id uuid;
begin
  if private.my_bms_role() IS DISTINCT FROM 'ADMIN' then
    raise exception 'Hanya Administrator';
  end if;

  select id into target_id
  from auth.users
  where lower(email)=lower(trim(p_email))
    and email_confirmed_at is not null;

  if target_id is null then
    raise exception 'Akun belum ditemukan atau email belum diverifikasi';
  end if;

  insert into public.profiles(user_id,role,full_name,active)
  values(target_id,p_role,p_name,true)
  on conflict(user_id) do update
    set role=excluded.role,full_name=excluded.full_name,active=true;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),'ASSIGN_ROLE','profiles',target_id::text,
    jsonb_build_object('role',p_role,'name',p_name));

  return target_id;
end
$function$;

CREATE OR REPLACE FUNCTION private.admin_update_bms_user_impl(p_user_id uuid, p_name text, p_role bms_role, p_active boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if private.my_bms_role() IS DISTINCT FROM 'ADMIN'::public.bms_role then
    raise exception 'Akses hanya untuk Administrator';
  end if;

  if p_user_id is null or nullif(trim(p_name),'') is null then
    raise exception 'Data pengguna tidak lengkap';
  end if;

  if p_user_id = auth.uid()
     and (p_role <> 'ADMIN'::public.bms_role or coalesce(p_active,true)=false) then
    raise exception 'ADMIN yang sedang login tidak boleh menonaktifkan atau mengganti role akun sendiri';
  end if;

  update public.profiles
  set full_name=trim(p_name),
      role=p_role,
      active=coalesce(p_active,true)
  where user_id=p_user_id;

  if not found then
    raise exception 'Pengguna tidak ditemukan';
  end if;
end
$function$;

CREATE OR REPLACE FUNCTION private.admin_list_bms_users_impl()
 RETURNS TABLE(user_id uuid, email text, full_name text, role bms_role, active boolean, email_confirmed boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if private.my_bms_role() IS DISTINCT FROM 'ADMIN'::public.bms_role then
    raise exception 'Akses hanya untuk Administrator';
  end if;

  return query
  select p.user_id,
         u.email::text,
         p.full_name,
         p.role,
         p.active,
         (u.email_confirmed_at is not null)
  from public.profiles p
  join auth.users u on u.id=p.user_id
  order by p.full_name, u.email;
end
$function$;

CREATE OR REPLACE FUNCTION private.bind_master_contract_to_cycle_core(p_master_contract_id uuid, p_cycle_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  m public.contracts%rowtype;
  new_contract_id uuid;
  st public.cycle_state;
begin
  if private.my_bms_role() IS DISTINCT FROM 'ADMIN'::public.bms_role then
    raise exception 'Hanya ADMIN yang dapat mengikat kontrak';
  end if;

  select * into m
  from public.contracts
  where id=p_master_contract_id
    and cycle_id is null;

  if not found then
    raise exception 'Master Kontrak tidak ditemukan';
  end if;

  if m.performance_template_name is null then
    raise exception 'Template performa belum dipilih';
  end if;

  if not exists(
    select 1 from public.performance_standards
    where contract_id=m.id and template_name=m.performance_template_name
  ) then
    raise exception 'Template performa tidak ditemukan';
  end if;

  select state into st
  from public.cycles
  where id=p_cycle_id
  for update;

  if st is null then raise exception 'Siklus tidak ditemukan'; end if;
  if st <> 'ACTIVE' then raise exception 'Siklus tidak aktif'; end if;
  if exists(select 1 from public.contracts where cycle_id=p_cycle_id) then
    raise exception 'Siklus sudah memiliki kontrak';
  end if;

  insert into public.contracts(
    cycle_id,number,contract_date,integrator,
    doc_price,pre_starter_price,starter_price,finisher_price,
    ovk_price,harvest_price,parameters,ovk_price_basis,
    ovk_vat_percent,signed_reference,
    source_master_contract_id,frozen_at,performance_template_name
  )
  values(
    p_cycle_id,
    m.number || '-' || (select code from public.cycles where id=p_cycle_id),
    m.contract_date,m.integrator,
    m.doc_price,m.pre_starter_price,m.starter_price,m.finisher_price,
    m.ovk_price,m.harvest_price,m.parameters,m.ovk_price_basis,
    m.ovk_vat_percent,m.signed_reference,
    m.id,now(),m.performance_template_name
  )
  returning id into new_contract_id;

  insert into public.contract_live_prices(contract_id,min_weight_kg,max_weight_kg,price_per_kg)
  select new_contract_id,min_weight_kg,max_weight_kg,price_per_kg
  from public.contract_live_prices
  where contract_id=p_master_contract_id;

  insert into public.contract_bonuses(contract_id,metric,min_value,max_value,rupiah_per_kg,notes)
  select new_contract_id,metric,min_value,max_value,rupiah_per_kg,notes
  from public.contract_bonuses
  where contract_id=p_master_contract_id;

  insert into public.performance_standards(
    contract_id,template_name,age_days,std_body_weight_g,std_fcr,std_feed_g_per_bird
  )
  select new_contract_id,template_name,age_days,std_body_weight_g,std_fcr,std_feed_g_per_bird
  from public.performance_standards
  where contract_id=p_master_contract_id
    and template_name=m.performance_template_name;

  return new_contract_id;
end
$function$;

CREATE OR REPLACE FUNCTION public.production_mandiri_rhpp_summary(p_contract_assignment_id uuid)
 RETURNS TABLE(chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, weighted_age numeric, avg_bw_kg numeric, mortality_pct numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, std_bw_kg numeric, ip numeric, harvest_value numeric, sapronak_cost numeric, bop_produksi numeric, laba_operasional numeric, received_total numeric, receivable numeric)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_a public.logistics_contract_assignments%rowtype; v_role public.bms_role;
begin
  select p.role into v_role from public.profiles p where p.user_id=auth.uid() and p.active;
  select * into v_a from public.logistics_contract_assignments a where a.id=p_contract_assignment_id and a.cycle_type='MANDIRI';
  if v_a.id is null or (v_role IS NULL OR v_role not in ('ADMIN','OWNER','PPL','KEUANGAN')) or (v_role='PPL' and v_a.ppl_id<>auth.uid()) then raise exception 'Siklus Mandiri tidak ditemukan atau akses ditolak.'; end if;
  return query
  with ci as (select greatest(0,coalesce(sum(c.received-c.doa),0))::numeric n,min(c.arrived_on) dt from public.chick_ins c where c.contract_assignment_id=v_a.id),
  h as (select coalesce(sum(x.birds),0) birds,coalesce(sum(x.net_weight_kg),0) kg,coalesce(sum(x.total_amount),0) revenue,
    coalesce(sum(x.birds*greatest(1,x.harvested_on-ci.dt+1))/nullif(sum(x.birds),0),0) age
    from public.marketing_contract_harvests x cross join ci where x.contract_assignment_id=v_a.id),
  feed as (select coalesce(sum(z.qty*coalesce(i.kg_per_unit,0)),0) kg from (
    select p.item_id,sum(a.quantity) qty from public.logistics_mandiri_purchase_allocations a
    join public.logistics_mandiri_purchases p on p.id=a.purchase_id where a.contract_assignment_id=v_a.id group by p.item_id
    union all
    select l.item_id,sum(case when m.direction='IN' then m.quantity else -m.quantity end) qty
    from public.logistics_company_feed_movements m join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    where m.contract_assignment_id=v_a.id group by l.item_id
  ) z join public.items i on i.id=z.item_id and i.category='PAKAN'),
  mortality as (select greatest(coalesce(ci.n,0)-coalesce(h.birds,0),0)::numeric birds from ci cross join h),
  standard as (select s.std_fcr,s.std_body_weight_g from public.performance_standards s
    where s.template_name=v_a.performance_template_name and s.age_days<=greatest(1,round((select age from h))::integer)
    order by s.age_days desc,s.id limit 1),
  cost as (select
    (select coalesce(sum(a.quantity*p.purchase_unit_price),0) from public.logistics_mandiri_purchase_allocations a
      join public.logistics_mandiri_purchases p on p.id=a.purchase_id where a.contract_assignment_id=v_a.id)
    +(select coalesce(sum((case when m.direction='IN' then m.quantity else -m.quantity end)*l.unit_price),0)
      from public.logistics_company_feed_movements m join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
      where m.contract_assignment_id=v_a.id) sapronak_luar,
    (select coalesce(sum(b.amount),0) from public.bop b where b.contract_assignment_id=v_a.id) bop_produksi),
  paid as (select coalesce(sum(r.amount),0) amount from public.finance_mandiri_sales_receipts r
    join public.marketing_contract_harvests x on x.id=r.harvest_id where x.contract_assignment_id=v_a.id)
  select ci.n,h.birds,h.kg,round(h.age,2),round(h.kg/nullif(h.birds,0),3),
    round(100*mortality.birds/nullif(ci.n,0),2),feed.kg,round(feed.kg/nullif(h.kg,0),3),
    standard.std_fcr,round(standard.std_body_weight_g/1000,3),
    round((100-100*mortality.birds/nullif(ci.n,0))*(h.kg/nullif(h.birds,0))*100/nullif(h.age*feed.kg/nullif(h.kg,0),0),2),
    h.revenue,cost.sapronak_luar,cost.bop_produksi,h.revenue-cost.sapronak_luar-cost.bop_produksi,
    paid.amount,h.revenue-paid.amount
  from ci cross join h cross join feed cross join mortality left join standard on true cross join cost cross join paid;
end $function$;

CREATE OR REPLACE FUNCTION public.production_ppl_directory()
 RETURNS TABLE(user_id uuid, full_name text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if (v_role IS NULL OR v_role not in (
    'ADMIN'::public.bms_role,
    'OWNER'::public.bms_role,
    'PPL'::public.bms_role
  )) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select p.user_id,p.full_name
  from public.profiles p
  where p.active
    and p.role='PPL'::public.bms_role
    and (v_role <> 'PPL'::public.bms_role or p.user_id=auth.uid())
  order by p.full_name;
end
$function$;

CREATE OR REPLACE FUNCTION public.save_mitra_split_return_atomic(p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
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
  if (private.my_bms_role() IS NULL OR private.my_bms_role() not in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
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
end $function$;

CREATE OR REPLACE FUNCTION public.move_company_feed_atomic(p_retained_feed_id uuid, p_contract_assignment_id uuid, p_direction text, p_quantity numeric, p_transferred_on date, p_reference text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_lot public.logistics_mitra_retained_feed%rowtype;
  v_cycle public.logistics_contract_assignments%rowtype;
  v_warehouse numeric;
  v_at_cycle numeric;
  v_feed_available numeric;
  v_id uuid;
begin
  if (private.my_bms_role() IS NULL OR private.my_bms_role() not in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
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
end $function$;

CREATE OR REPLACE FUNCTION public.production_feed_stock(p_contract_assignment_id uuid)
 RETURNS TABLE(item_id uuid, code text, name text, unit text, kg_per_unit numeric, sent_units numeric, external_units numeric, returned_units numeric, used_units numeric, remaining_units numeric, remaining_kg numeric)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if (v_role IS NULL OR v_role not in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role,'PPL'::public.bms_role)) then
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
  ),
  adj as (
    select a.item_id,coalesce(sum(a.adjustment_units),0) qty
    from public.production_feed_stock_adjustments a
    where a.contract_assignment_id=p_contract_assignment_id
    group by a.item_id
  )
  select
    f.item_id,f.code,f.name,f.unit,f.kg_per_unit,
    coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0),
    coalesce(e.qty,0),
    coalesce(rt.qty,0)+coalesce(rs.qty,0),
    coalesce(u.qty,0),
    greatest(0,
      coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)
      -coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0)+coalesce(a.qty,0)
    ),
    greatest(0,
      coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)
      -coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0)+coalesce(a.qty,0)
    )*f.kg_per_unit
  from feed f
  left join sent s on s.item_id=f.item_id
  left join mandiri m on m.item_id=f.item_id
  left join company_move cm on cm.item_id=f.item_id
  left join retained rs on rs.item_id=f.item_id
  left join ext e on e.item_id=f.item_id
  left join ret rt on rt.item_id=f.item_id
  left join used u on u.item_id=f.item_id
  left join adj a on a.item_id=f.item_id
  where coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(rs.qty,0)<>0
  order by f.code;
end
$function$;

CREATE OR REPLACE FUNCTION public.save_chick_in_with_abks_v1(p_chick_id uuid, p_assignment_id uuid, p_arrived_on date, p_received integer, p_doa integer, p_avg_weight numeric, p_delivery_number text, p_abks jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_role public.bms_role;
  v_assignment public.logistics_contract_assignments%rowtype;
  v_chick_id uuid;
  v_net integer;
  v_sum integer;
  v_count integer;
  v_unique_count integer;
  v_abk jsonb;
  v_abk_id uuid;
  v_initial integer;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active=true;

  if (v_role IS NULL OR v_role not in ('ADMIN','PPL')) then
    raise exception 'Akses ditolak. Hanya ADMIN/PPL.';
  end if;

  select * into v_assignment
  from public.logistics_contract_assignments a
  where a.id=p_assignment_id
  for update;

  if v_assignment.id is null then
    raise exception 'Siklus tidak ditemukan.';
  end if;

  if not v_assignment.active then
    raise exception 'Siklus CLOSED. Buka kembali melalui Administrator sebelum koreksi.';
  end if;

  if v_role='PPL' and v_assignment.ppl_id is distinct from auth.uid() then
    raise exception 'PPL hanya dapat mengisi kandang yang menjadi tanggung jawabnya.';
  end if;

  if p_received is null or p_received<=0 then
    raise exception 'DOC In harus lebih dari 0.';
  end if;
  if p_doa is null or p_doa<0 or p_doa>=p_received then
    raise exception 'DOC Mati Box tidak valid.';
  end if;
  if p_avg_weight is not null and p_avg_weight<=0 then
    raise exception 'Bobot rata-rata DOC harus lebih dari 0.';
  end if;
  if p_arrived_on<v_assignment.start_date then
    raise exception 'Tanggal Chick-In tidak boleh sebelum tanggal mulai siklus.';
  end if;

  if p_abks is null or jsonb_typeof(p_abks)<>'array' or jsonb_array_length(p_abks)=0 then
    raise exception 'Pilih minimal 1 ABK dan isi Populasi Awal.';
  end if;

  v_net:=p_received-p_doa;

  select count(*),
         count(distinct nullif(x->>'abk_id','')),
         coalesce(sum((x->>'initial_birds')::integer),0)
  into v_count,v_unique_count,v_sum
  from jsonb_array_elements(p_abks) x;

  if v_count<>v_unique_count then
    raise exception 'ABK tidak boleh dipilih dua kali.';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_abks) x
    where nullif(x->>'abk_id','') is null
       or coalesce((x->>'initial_birds')::integer,0)<=0
  ) then
    raise exception 'Semua ABK dan Populasi Awal wajib diisi.';
  end if;

  if v_sum<>v_net then
    raise exception 'Total Populasi Awal ABK (%) harus sama dengan Populasi Awal Bersih (%)',v_sum,v_net;
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_abks) x
    left join public.employees e on e.id=(x->>'abk_id')::uuid
    where e.id is null or e.kind<>'ABK' or e.active<>true
  ) then
    raise exception 'ABK tidak ditemukan atau sudah tidak aktif.';
  end if;

  if p_chick_id is not null then
    select c.id into v_chick_id
    from public.chick_ins c
    where c.id=p_chick_id
      and c.contract_assignment_id=p_assignment_id
    for update;
    if v_chick_id is null then
      raise exception 'Data Chick-In tidak ditemukan pada siklus ini.';
    end if;
  else
    if exists (
      select 1 from public.chick_ins c
      where c.contract_assignment_id=p_assignment_id
    ) then
      raise exception 'Siklus ini sudah memiliki Chick-In. Gunakan Edit.';
    end if;
  end if;

  -- Jangan izinkan melepas ABK yang sudah punya data Liga/Pakan.
  if exists (
    select 1
    from public.logistics_contract_assignment_abks l
    where l.contract_assignment_id=p_assignment_id
      and not exists (
        select 1 from jsonb_array_elements(p_abks) x
        where (x->>'abk_id')::uuid=l.abk_id
      )
      and (
        l.basics_locked_at is not null
        or exists (
          select 1 from public.production_abk_results r
          where r.contract_assignment_id=p_assignment_id and r.abk_id=l.abk_id
        )
      )
  ) then
    raise exception 'ABK yang sudah memiliki data Liga/Pakan tidak dapat dilepas. Koreksi ABK tersebut, jangan hapus.';
  end if;

  if v_chick_id is null then
    insert into public.chick_ins(
      contract_assignment_id,barn_id,arrived_on,
      received,shipped,doa,strain,avg_weight,delivery_number
    ) values (
      p_assignment_id,v_assignment.barn_id,p_arrived_on,
      p_received,p_received,p_doa,null,p_avg_weight,nullif(trim(coalesce(p_delivery_number,'')),'')
    )
    returning id into v_chick_id;
  else
    update public.chick_ins
    set arrived_on=p_arrived_on,
        barn_id=v_assignment.barn_id,
        received=p_received,
        shipped=p_received,
        doa=p_doa,
        strain=null,
        avg_weight=p_avg_weight,
        delivery_number=nullif(trim(coalesce(p_delivery_number,'')),'')
    where id=v_chick_id;
  end if;

  -- Hapus hanya link ABK yang belum dipakai downstream dan tidak lagi dipilih.
  delete from public.logistics_contract_assignment_abks l
  where l.contract_assignment_id=p_assignment_id
    and l.basics_locked_at is null
    and not exists (
      select 1 from public.production_abk_results r
      where r.contract_assignment_id=p_assignment_id and r.abk_id=l.abk_id
    )
    and not exists (
      select 1 from jsonb_array_elements(p_abks) x
      where (x->>'abk_id')::uuid=l.abk_id
    );

  for v_abk in select * from jsonb_array_elements(p_abks)
  loop
    v_abk_id:=(v_abk->>'abk_id')::uuid;
    v_initial:=(v_abk->>'initial_birds')::integer;

    insert into public.logistics_contract_assignment_abks(
      contract_assignment_id,abk_id,initial_birds
    ) values (
      p_assignment_id,v_abk_id,v_initial
    )
    on conflict (contract_assignment_id,abk_id)
    do update set initial_birds=excluded.initial_birds;
  end loop;

  return v_chick_id;
end
$function$;

CREATE OR REPLACE FUNCTION public.production_feed_stock_as_of(p_contract_assignment_id uuid, p_as_of_date date)
 RETURNS TABLE(item_id uuid, code text, name text, unit text, kg_per_unit numeric, sent_units numeric, external_units numeric, returned_units numeric, used_units numeric, remaining_units numeric, remaining_kg numeric)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if (v_role IS NULL OR v_role not in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role,'PPL'::public.bms_role)) then
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
    from public.items i
    where i.active=true and i.category='PAKAN'
  ),
  sent as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_shipments s
    join public.logistics_shipment_items li on li.shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
      and s.shipment_date<=p_as_of_date
    group by li.item_id
  ),
  ext as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_external_shipments s
    join public.logistics_external_shipment_items li on li.external_shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
      and s.shipment_date<=p_as_of_date
    group by li.item_id
  ),
  ret as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_returns r
    join public.logistics_return_items li on li.return_id=r.id
    where r.contract_assignment_id=p_contract_assignment_id
      and r.return_date<=p_as_of_date
    group by li.item_id
  ),
  retained as (
    select l.item_id,coalesce(sum(l.quantity),0) qty
    from public.logistics_mitra_retained_feed l
    join public.logistics_returns r on r.id=l.return_id
    where l.source_assignment_id=p_contract_assignment_id
      and r.return_date<=p_as_of_date
    group by l.item_id
  ),
  company_move as (
    select l.item_id,
           coalesce(sum(case when m.direction='IN' then m.quantity else -m.quantity end),0) qty
    from public.logistics_company_feed_movements m
    join public.logistics_mitra_retained_feed l on l.id=m.retained_feed_id
    where m.contract_assignment_id=p_contract_assignment_id
      and m.transferred_on<=p_as_of_date
    group by l.item_id
  ),
  mandiri as (
    select p.item_id,coalesce(sum(a.quantity),0) qty
    from public.logistics_mandiri_purchase_allocations a
    join public.logistics_mandiri_purchases p on p.id=a.purchase_id
    join public.logistics_contract_assignments ca
      on ca.id=a.contract_assignment_id and ca.cycle_type='MANDIRI'
    where a.contract_assignment_id=p_contract_assignment_id
      and p.purchase_date<=p_as_of_date
    group by p.item_id
  ),
  used as (
    select r.feed_item_id item_id,coalesce(sum(r.feed_quantity_units),0) qty
    from public.recordings r
    where r.contract_assignment_id=p_contract_assignment_id
      and r.recorded_on<=p_as_of_date
    group by r.feed_item_id
  ),
  adj as (
    select a.item_id,coalesce(sum(a.adjustment_units),0) qty
    from public.production_feed_stock_adjustments a
    where a.contract_assignment_id=p_contract_assignment_id
      and a.adjustment_date<=p_as_of_date
    group by a.item_id
  )
  select
    f.item_id,f.code,f.name,f.unit,f.kg_per_unit,
    coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0),
    coalesce(e.qty,0),
    coalesce(rt.qty,0)+coalesce(rs.qty,0),
    coalesce(u.qty,0),
    greatest(0,
      coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)
      -coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0)+coalesce(a.qty,0)
    ),
    greatest(0,
      coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)
      -coalesce(rt.qty,0)-coalesce(rs.qty,0)-coalesce(u.qty,0)+coalesce(a.qty,0)
    )*f.kg_per_unit
  from feed f
  left join sent s on s.item_id=f.item_id
  left join mandiri m on m.item_id=f.item_id
  left join company_move cm on cm.item_id=f.item_id
  left join retained rs on rs.item_id=f.item_id
  left join ext e on e.item_id=f.item_id
  left join ret rt on rt.item_id=f.item_id
  left join used u on u.item_id=f.item_id
  left join adj a on a.item_id=f.item_id
  where coalesce(s.qty,0)+coalesce(m.qty,0)+coalesce(cm.qty,0)+coalesce(e.qty,0)
        -coalesce(rt.qty,0)-coalesce(rs.qty,0)<>0
  order by f.code;
end
$function$;

DO $$ DECLARE r record; BEGIN
 FOR r IN SELECT n.nspname,c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind IN ('r','p','v','m','f') LOOP
  EXECUTE format('REVOKE TRUNCATE ON TABLE %I.%I FROM PUBLIC,anon,authenticated',r.nspname,r.relname);
 END LOOP;
 FOR r IN SELECT p.oid,n.nspname,p.proname,pg_get_function_identity_arguments(p.oid) args FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname IN ('public','private') AND p.prorettype='pg_catalog.trigger'::regtype LOOP
  EXECUTE format('REVOKE EXECUTE ON FUNCTION %I.%I(%s) FROM PUBLIC,anon,authenticated',r.nspname,r.proname,r.args);
 END LOOP;
END $$;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public REVOKE TRUNCATE ON TABLES FROM PUBLIC,anon,authenticated;
REVOKE EXECUTE ON FUNCTION public.admin_cleanup_closed_bop_legacy_v1() FROM PUBLIC,anon;
REVOKE INSERT,UPDATE,DELETE,TRUNCATE ON public.audit_events FROM PUBLIC,anon,authenticated;
DO $$ DECLARE r record; BEGIN
 FOR r IN SELECT policyname FROM pg_policies WHERE schemaname='public' AND tablename='audit_events' LOOP
  EXECUTE format('DROP POLICY %I ON public.audit_events',r.policyname);
 END LOOP;
END $$;
CREATE POLICY audit_events_admin_read ON public.audit_events FOR SELECT TO authenticated USING ((SELECT private.my_bms_role())='ADMIN');
CREATE OR REPLACE FUNCTION private.guard_audit_immutable() RETURNS trigger LANGUAGE plpgsql SET search_path='' AS $$
BEGIN RAISE EXCEPTION 'Audit transaksi tidak dapat diubah atau dihapus.' USING ERRCODE='42501'; END $$;
REVOKE ALL ON FUNCTION private.guard_audit_immutable() FROM PUBLIC,anon,authenticated;
DROP TRIGGER IF EXISTS guard_audit_immutable ON public.audit_events;
CREATE TRIGGER guard_audit_immutable BEFORE UPDATE OR DELETE ON public.audit_events FOR EACH ROW EXECUTE FUNCTION private.guard_audit_immutable();
