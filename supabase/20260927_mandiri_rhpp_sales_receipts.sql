-- Mandiri production report and customer receipts. Mitra functions and menus stay intact.
create table if not exists public.finance_mandiri_sales_receipts (
  id uuid primary key default gen_random_uuid(),
  harvest_id uuid not null references public.marketing_contract_harvests(id),
  received_on date not null default current_date,
  amount numeric(16,2) not null check (amount > 0),
  method text not null check (method in ('TRANSFER','TUNAI','LAINNYA')),
  reference text,
  notes text,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);
create index if not exists finance_mandiri_receipt_harvest_idx on public.finance_mandiri_sales_receipts(harvest_id);
alter table public.finance_mandiri_sales_receipts enable row level security;
drop policy if exists finance_mandiri_sales_receipts_read on public.finance_mandiri_sales_receipts;
create policy finance_mandiri_sales_receipts_read on public.finance_mandiri_sales_receipts
  for select to authenticated using (
    exists(select 1 from public.profiles p where p.user_id=(select auth.uid()) and p.active and p.role in ('ADMIN','KEUANGAN','OWNER'))
  );
revoke all on public.finance_mandiri_sales_receipts from public,anon,authenticated;
grant select on public.finance_mandiri_sales_receipts to authenticated;

create or replace function public.finance_receive_mandiri_sale_atomic(
  p_harvest_id uuid,p_received_on date,p_amount numeric,p_method text,p_reference text default null,p_notes text default null
) returns uuid language plpgsql security definer set search_path='' as $$
declare v_h public.marketing_contract_harvests%rowtype; v_id uuid; v_paid numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')) then raise exception 'Akses ditolak.'; end if;
  select h.* into v_h from public.marketing_contract_harvests h where h.id=p_harvest_id for update;
  if v_h.id is null or not exists(select 1 from public.logistics_contract_assignments a where a.id=v_h.contract_assignment_id and a.cycle_type='MANDIRI') then raise exception 'Penjualan Mandiri tidak ditemukan.'; end if;
  if p_received_on is null or p_received_on<v_h.harvested_on then raise exception 'Tanggal penerimaan harus pada atau sesudah tanggal panen.'; end if;
  if p_amount is null or p_amount<=0 then raise exception 'Nominal penerimaan harus lebih dari nol.'; end if;
  if p_method not in ('TRANSFER','TUNAI','LAINNYA') then raise exception 'Metode penerimaan tidak valid.'; end if;
  select coalesce(sum(r.amount),0) into v_paid from public.finance_mandiri_sales_receipts r where r.harvest_id=p_harvest_id;
  if v_paid+p_amount>v_h.total_amount then raise exception 'Penerimaan melebihi sisa piutang.'; end if;
  insert into public.finance_mandiri_sales_receipts(harvest_id,received_on,amount,method,reference,notes)
  values(p_harvest_id,p_received_on,p_amount,p_method,nullif(trim(p_reference),''),nullif(trim(p_notes),'')) returning id into v_id;
  return v_id;
end $$;
revoke execute on function public.finance_receive_mandiri_sale_atomic(uuid,date,numeric,text,text,text) from public,anon;
grant execute on function public.finance_receive_mandiri_sale_atomic(uuid,date,numeric,text,text,text) to authenticated;

create or replace function public.production_mandiri_rhpp_summary(p_contract_assignment_id uuid)
returns table(chick_in_birds numeric,total_harvest_birds numeric,total_harvest_kg numeric,weighted_age numeric,
  avg_bw_kg numeric,mortality_pct numeric,net_feed_kg numeric,fcr_actual numeric,fcr_standard numeric,
  std_bw_kg numeric,ip numeric,harvest_value numeric,sapronak_cost numeric,bop_produksi numeric,
  laba_operasional numeric,received_total numeric,receivable numeric)
language plpgsql security definer set search_path='' as $$
declare v_a public.logistics_contract_assignments%rowtype; v_role public.bms_role;
begin
  select p.role into v_role from public.profiles p where p.user_id=auth.uid() and p.active;
  select * into v_a from public.logistics_contract_assignments a where a.id=p_contract_assignment_id and a.cycle_type='MANDIRI';
  if v_a.id is null or v_role not in ('ADMIN','OWNER','PPL','KEUANGAN') or (v_role='PPL' and v_a.ppl_id<>auth.uid()) then raise exception 'Siklus Mandiri tidak ditemukan atau akses ditolak.'; end if;
  return query
  with ci as (select greatest(0,coalesce(sum(c.received-c.doa),0)) n,min(c.arrived_on) dt from public.chick_ins c where c.contract_assignment_id=v_a.id),
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
  mortality as (select coalesce(sum(r.mortality+r.culling),0) birds from public.recordings r where r.contract_assignment_id=v_a.id),
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
end $$;
revoke execute on function public.production_mandiri_rhpp_summary(uuid) from public,anon;
grant execute on function public.production_mandiri_rhpp_summary(uuid) to authenticated;

create or replace function public.finance_cashflow_entries_v2()
returns table(txn_date date,txn_type text,source text,amount numeric,barn_id uuid,
  contract_assignment_id uuid,detail text,reference text)
language plpgsql security definer set search_path='' as $$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')) then raise exception 'Akses ditolak.'; end if;
  return query
  select v.txn_date,v.txn_type,case when v.source='BOP KANDANG' then 'BOP PRODUKSI' else v.source end,
    v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference from public.finance_cashflow_entries_v1() v
  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN KANDANG'::text,m.amount,m.barn_id,m.contract_assignment_id,
    replace(m.category,'_',' ')::text,coalesce(m.reference,'') from public.barn_maintenance_costs m
  union all
  select r.received_on,'MASUK'::text,'PENJUALAN MANDIRI'::text,r.amount,h.barn_id,h.contract_assignment_id,
    coalesce(h.buyer_name,'Pelanggan')||' · Panen '||h.harvested_on::text,coalesce(r.reference,'')
  from public.finance_mandiri_sales_receipts r join public.marketing_contract_harvests h on h.id=r.harvest_id;
end $$;
revoke execute on function public.finance_cashflow_entries_v2() from public,anon;
grant execute on function public.finance_cashflow_entries_v2() to authenticated;
