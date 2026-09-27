-- Expedisi master data + company bank fields
-- Applied live 2026-09-27

alter table public.company_profile
  add column if not exists bank_name text,
  add column if not exists bank_account_number text,
  add column if not exists bank_account_name text;

create table if not exists public.expedition_drivers (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  phone text,
  license_number text,
  active boolean not null default true,
  notes text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.expedition_vehicles (
  id uuid primary key default gen_random_uuid(),
  plate_number text not null unique,
  vehicle_type text,
  capacity_qty numeric,
  active boolean not null default true,
  notes text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.expedition_customers (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  address text,
  phone text,
  tax_number text,
  active boolean not null default true,
  notes text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.expedition_drivers enable row level security;
alter table public.expedition_vehicles enable row level security;
alter table public.expedition_customers enable row level security;

drop policy if exists expedition_drivers_read on public.expedition_drivers;
create policy expedition_drivers_read on public.expedition_drivers
for select to authenticated using (private.my_bms_role() in ('ADMIN','LOGISTIK','OWNER'));
drop policy if exists expedition_drivers_write on public.expedition_drivers;
create policy expedition_drivers_write on public.expedition_drivers
for all to authenticated using (private.my_bms_role()='ADMIN') with check (private.my_bms_role()='ADMIN');

drop policy if exists expedition_vehicles_read on public.expedition_vehicles;
create policy expedition_vehicles_read on public.expedition_vehicles
for select to authenticated using (private.my_bms_role() in ('ADMIN','LOGISTIK','OWNER'));
drop policy if exists expedition_vehicles_write on public.expedition_vehicles;
create policy expedition_vehicles_write on public.expedition_vehicles
for all to authenticated using (private.my_bms_role()='ADMIN') with check (private.my_bms_role()='ADMIN');

drop policy if exists expedition_customers_read on public.expedition_customers;
create policy expedition_customers_read on public.expedition_customers
for select to authenticated using (private.my_bms_role() in ('ADMIN','LOGISTIK','KEUANGAN','OWNER'));
drop policy if exists expedition_customers_write on public.expedition_customers;
create policy expedition_customers_write on public.expedition_customers
for all to authenticated using (private.my_bms_role()='ADMIN') with check (private.my_bms_role()='ADMIN');

revoke all on public.expedition_drivers,public.expedition_vehicles,public.expedition_customers from anon;
grant select on public.expedition_drivers,public.expedition_vehicles,public.expedition_customers to authenticated;
grant insert,update,delete on public.expedition_drivers,public.expedition_vehicles,public.expedition_customers to authenticated;
