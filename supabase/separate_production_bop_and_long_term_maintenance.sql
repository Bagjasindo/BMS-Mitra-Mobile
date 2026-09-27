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

-- v2 reporting functions are intentionally kept alongside v1 for compatibility.
-- Full live definitions are also present in the live schema snapshot.
