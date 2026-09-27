-- Separate production BOP from long-term barn maintenance.
-- Applied to live Supabase on 2026-09-27.

create table if not exists public.barn_maintenance_costs (
  id uuid primary key default gen_random_uuid(),
  contract_assignment_id uuid not null references public.logistics_contract_assignments(id),
  barn_id uuid not null references public.barns(id),
  incurred_on date not null,
  category text not null,
  amount numeric not null check (amount > 0),
  reference text,
  notes text,
  created_by uuid references public.profiles(user_id) default auth.uid(),
  created_at timestamptz not null default now(),
  constraint barn_maintenance_category_check check (
    category in ('PERAWATAN_JANGKA_PANJANG','RENOVASI','PENGGANTIAN_KOMPONEN','PERALATAN','LAINNYA')
  )
);

create index if not exists idx_barn_maintenance_assignment on public.barn_maintenance_costs(contract_assignment_id);
create index if not exists idx_barn_maintenance_barn_date on public.barn_maintenance_costs(barn_id,incurred_on);

alter table public.barn_maintenance_costs enable row level security;

drop policy if exists barn_maintenance_read on public.barn_maintenance_costs;
create policy barn_maintenance_read on public.barn_maintenance_costs
for select to authenticated
using (
  private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role,'OWNER'::bms_role])
  and private.can_read_assignment(contract_assignment_id)
);

drop policy if exists barn_maintenance_insert on public.barn_maintenance_costs;
create policy barn_maintenance_insert on public.barn_maintenance_costs
for insert to authenticated
with check (
  private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role])
  and exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=contract_assignment_id and a.barn_id=barn_id
  )
);

drop policy if exists barn_maintenance_update on public.barn_maintenance_costs;
create policy barn_maintenance_update on public.barn_maintenance_costs
for update to authenticated
using (private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role]))
with check (
  private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role])
  and exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=contract_assignment_id and a.barn_id=barn_id
  )
);

drop policy if exists barn_maintenance_delete on public.barn_maintenance_costs;
create policy barn_maintenance_delete on public.barn_maintenance_costs
for delete to authenticated
using (private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role]));

revoke all on table public.barn_maintenance_costs from anon;
grant select,insert,update,delete on table public.barn_maintenance_costs to authenticated;

alter table public.bop drop constraint if exists bop_category_production_only_check;
alter table public.bop add constraint bop_category_production_only_check
check (category in (
  'OVK','TENAGA_KERJA','TRANSPORTASI','LISTRIK','GAS','AIR','SEKAM','SANITASI','EKSPEDISI','OPERASIONAL','LAINNYA'
));

create or replace function public.finance_cycle_profit_loss_v2()
returns table(
  contract_assignment_id uuid,
  barn_id uuid,
  barn_code text,
  barn_name text,
  start_date date,
  active boolean,
  rhpp_system numeric,
  rhpp_real numeric,
  bop_produksi numeric,
  gaji_abk numeric,
  sapronak_luar numeric,
  tambah_daging numeric,
  kasbon_abk numeric,
  saldo_kasbon numeric,
  perawatan_jangka_panjang numeric,
  laba_operasional_produksi numeric,
  laba_bersih_akhir numeric
)
language plpgsql security definer set search_path=''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  with bopx as (
    select b.contract_assignment_id,
      coalesce(sum(b.amount),0)::numeric bop,
      coalesce(sum(case when b.source_type='ABK_SALARY' then b.amount else 0 end),0)::numeric salary
    from public.bop b group by b.contract_assignment_id
  ),
  maint as (
    select m.contract_assignment_id,coalesce(sum(m.amount),0)::numeric amount
    from public.barn_maintenance_costs m group by m.contract_assignment_id
  ),
  ext_ship as (
    select h.contract_assignment_id,coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric amount
    from public.logistics_external_shipments h
    join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
    group by h.contract_assignment_id
  ),
  ext_out as (
    select t.source_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.source_contract_assignment_id
  ),
  ext_in as (
    select t.target_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.target_contract_assignment_id
  ),
  meat as (
    select m.contract_assignment_id,coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric amount
    from public.marketing_external_meat_purchases m group by m.contract_assignment_id
  ),
  adv as (
    select a.contract_assignment_id,
      coalesce(sum(a.amount),0)::numeric amount,
      coalesce(sum(a.amount-coalesce(p.paid,0)),0)::numeric balance
    from public.advances a
    left join (select advance_id,sum(amount) paid from public.advance_payments group by advance_id) p on p.advance_id=a.id
    where a.contract_assignment_id is not null
    group by a.contract_assignment_id
  ),
  base as (
    select
      a.id contract_assignment_id,a.barn_id,b.code,b.name,a.start_date,a.active,
      coalesce(sf.system_amount,0)::numeric rhpp_system,
      coalesce(rr.amount,0)::numeric rhpp_real,
      coalesce(bx.bop,0)::numeric bop_produksi,
      coalesce(bx.salary,0)::numeric gaji_abk,
      greatest(0,coalesce(es.amount,0)-coalesce(eo.amount,0)+coalesce(ei.amount,0))::numeric sapronak_luar,
      coalesce(mt.amount,0)::numeric tambah_daging,
      coalesce(ad.amount,0)::numeric kasbon_abk,
      coalesce(ad.balance,0)::numeric saldo_kasbon,
      coalesce(mc.amount,0)::numeric perawatan_jangka_panjang
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    left join public.rhpp_system_final sf on sf.contract_assignment_id=a.id
    left join public.rhpp_real rr on rr.contract_assignment_id=a.id
    left join bopx bx on bx.contract_assignment_id=a.id
    left join maint mc on mc.contract_assignment_id=a.id
    left join ext_ship es on es.contract_assignment_id=a.id
    left join ext_out eo on eo.contract_assignment_id=a.id
    left join ext_in ei on ei.contract_assignment_id=a.id
    left join meat mt on mt.contract_assignment_id=a.id
    left join adv ad on ad.contract_assignment_id=a.id
  )
  select x.contract_assignment_id,x.barn_id,x.code,x.name,x.start_date,x.active,
    x.rhpp_system,x.rhpp_real,x.bop_produksi,x.gaji_abk,x.sapronak_luar,x.tambah_daging,
    x.kasbon_abk,x.saldo_kasbon,x.perawatan_jangka_panjang,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging)::numeric,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging-x.perawatan_jangka_panjang)::numeric
  from base x order by x.start_date desc,x.code;
end
$$;

revoke execute on function public.finance_cycle_profit_loss_v2() from public,anon;
grant execute on function public.finance_cycle_profit_loss_v2() to authenticated;

create or replace function public.finance_company_profit_loss_v2()
returns table(
  kandang_operational_profit numeric,
  maintenance_long_term numeric,
  kandang_net_profit numeric,
  expedition_revenue numeric,
  expedition_bop numeric,
  expedition_profit_loss numeric,
  bop_umum numeric,
  company_profit_loss numeric
)
language plpgsql security definer set search_path=''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  with k as (
    select coalesce(sum(laba_operasional_produksi),0)::numeric operational,
           coalesce(sum(perawatan_jangka_panjang),0)::numeric maintenance,
           coalesce(sum(laba_bersih_akhir),0)::numeric net
    from public.finance_cycle_profit_loss_v2()
  ),
  e as (select * from public.finance_expedition_profit_loss_v1()),
  u as (select coalesce(sum(amount),0)::numeric amount from public.bop_outside)
  select k.operational,k.maintenance,k.net,
         e.expedition_revenue,e.expedition_bop,e.expedition_profit_loss,
         u.amount,k.net+e.expedition_profit_loss-u.amount
  from k,e,u;
end
$$;

revoke execute on function public.finance_company_profit_loss_v2() from public,anon;
grant execute on function public.finance_company_profit_loss_v2() to authenticated;

create or replace function public.finance_cashflow_entries_v2()
returns table(
  txn_date date,txn_type text,source text,amount numeric,barn_id uuid,
  contract_assignment_id uuid,detail text,reference text
)
language plpgsql security definer set search_path=''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  select v.txn_date,v.txn_type,
         case when v.source='BOP KANDANG' then 'BOP PRODUKSI' else v.source end,
         v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v1() v
  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN KANDANG'::text,m.amount,m.barn_id,m.contract_assignment_id,
         replace(m.category,'_',' ')::text,coalesce(m.reference,'')
  from public.barn_maintenance_costs m;
end
$$;

revoke execute on function public.finance_cashflow_entries_v2() from public,anon;
grant execute on function public.finance_cashflow_entries_v2() to authenticated;
