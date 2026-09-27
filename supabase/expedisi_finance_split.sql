-- Expedisi finance split: operational BOP, maintenance, profit/loss
-- Applied live 2026-09-27

create table if not exists public.finance_expedition_maintenance (
  id uuid primary key default gen_random_uuid(),
  incurred_on date not null,
  category text not null check (category in ('SERVIS','BAN','PAJAK_KENDARAAN','PERBAIKAN','LAINNYA')),
  vehicle text,
  amount numeric not null check (amount >= 0),
  reference text,
  notes text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now()
);

alter table public.finance_expedition_maintenance enable row level security;

drop policy if exists finance_expedition_maintenance_read on public.finance_expedition_maintenance;
create policy finance_expedition_maintenance_read on public.finance_expedition_maintenance
for select to authenticated
using (private.my_bms_role() in ('ADMIN','KEUANGAN','OWNER'));

drop policy if exists finance_expedition_maintenance_write on public.finance_expedition_maintenance;
create policy finance_expedition_maintenance_write on public.finance_expedition_maintenance
for all to authenticated
using (private.my_bms_role() in ('ADMIN','KEUANGAN'))
with check (private.my_bms_role() in ('ADMIN','KEUANGAN'));

revoke all on public.finance_expedition_maintenance from anon;
grant select,insert,update,delete on public.finance_expedition_maintenance to authenticated;

create or replace function public.finance_expedition_profit_loss_v2()
returns table(
  expedition_revenue numeric,
  operational_bop numeric,
  operational_profit numeric,
  maintenance_bop numeric,
  net_profit numeric,
  cash_received numeric,
  receivable numeric
)
language sql
security definer
set search_path=''
as $$
  with revenue as (
    select coalesce(sum(t.trip_price+t.additional-t.deduction),0)::numeric amount
    from public.finance_expedition_invoices i
    join public.finance_expedition_invoice_items ii on ii.invoice_id=i.id
    join public.finance_expedition_trips t on t.id=ii.trip_id
    where i.status in ('ISSUED','PAID')
  ),
  operational as (
    select coalesce(sum(amount),0)::numeric amount
    from public.finance_expedition_bop
    where category not in ('SERVIS','BAN','PAJAK_KENDARAAN','PERBAIKAN')
  ),
  maintenance as (
    select coalesce(sum(amount),0)::numeric amount
    from public.finance_expedition_maintenance
  ),
  paid as (
    select coalesce(sum(amount),0)::numeric amount
    from public.finance_expedition_payments
  )
  select revenue.amount,operational.amount,revenue.amount-operational.amount,
         maintenance.amount,revenue.amount-operational.amount-maintenance.amount,
         paid.amount,greatest(revenue.amount-paid.amount,0::numeric)
  from revenue,operational,maintenance,paid
  where private.my_bms_role() in ('ADMIN'::public.bms_role,'KEUANGAN'::public.bms_role,'OWNER'::public.bms_role);
$$;

revoke execute on function public.finance_expedition_profit_loss_v2() from public,anon;
grant execute on function public.finance_expedition_profit_loss_v2() to authenticated;
