-- Modules from the final design not covered by the initial cycle schema.
create table public.company_profile (
  id boolean primary key default true check(id),
  company_name text not null, legal_name text, logo_url text, address text,
  phone text, email text, website text, tax_number text, business_id text,
  signatory_name text, signatory_title text, stamp_url text,
  updated_at timestamptz not null default now()
);
create table public.employees (
  id uuid primary key default gen_random_uuid(), code text not null unique,
  name text not null, kind text not null check(kind in ('KARYAWAN','ABK')),
  phone text, job_title text, joined_on date, active boolean not null default true,
  notes text
);
create table public.advances (
  id uuid primary key default gen_random_uuid(),
  employee_id uuid not null references public.employees(id),
  advanced_on date not null, amount numeric(18,2) not null check(amount > 0),
  description text, reference text, created_at timestamptz not null default now()
);
create table public.advance_payments (
  id uuid primary key default gen_random_uuid(),
  advance_id uuid not null references public.advances(id),
  paid_on date not null, amount numeric(18,2) not null check(amount > 0),
  method text not null, reference text, notes text, created_at timestamptz not null default now()
);
create table public.expeditions (
  id uuid primary key default gen_random_uuid(),
  cycle_id uuid not null references public.cycles(id),
  departed_on date not null, destination text not null,
  vehicle text, driver text, cargo text, reference text, notes text
);
create table public.rhpp_estimates (
  id uuid primary key default gen_random_uuid(),
  cycle_id uuid not null references public.cycles(id),
  estimated_on date not null, age_days integer check(age_days >= 0),
  performance jsonb not null default '{}'::jsonb,
  projected_amount numeric(18,2), notes text,
  created_by uuid not null default auth.uid() references public.profiles(user_id)
);

alter table public.company_profile enable row level security;
alter table public.employees enable row level security;
alter table public.advances enable row level security;
alter table public.advance_payments enable row level security;
alter table public.expeditions enable row level security;
alter table public.rhpp_estimates enable row level security;
create policy company_read on public.company_profile for select to authenticated using (public.my_bms_role() is not null);
create policy company_insert on public.company_profile for insert to authenticated with check (public.my_bms_role()='ADMIN');
create policy company_update on public.company_profile for update to authenticated
  using (public.my_bms_role()='ADMIN') with check (public.my_bms_role()='ADMIN');
create policy employees_read on public.employees for select to authenticated using
  (public.my_bms_role() in ('ADMIN','KEUANGAN','OWNER'));
create policy employees_insert on public.employees for insert to authenticated with check
  (public.my_bms_role()='ADMIN');
create policy advances_read on public.advances for select to authenticated using
  (public.my_bms_role() in ('ADMIN','KEUANGAN','OWNER'));
create policy advances_insert on public.advances for insert to authenticated with check
  (public.my_bms_role()='KEUANGAN');
create policy payments_read on public.advance_payments for select to authenticated using
  (public.my_bms_role() in ('ADMIN','KEUANGAN','OWNER'));
create policy payments_insert on public.advance_payments for insert to authenticated with check
  (public.my_bms_role()='KEUANGAN');
create policy expeditions_read on public.expeditions for select to authenticated using
  (public.can_read_cycle(cycle_id));
create policy expeditions_insert on public.expeditions for insert to authenticated with check
  (public.can_edit_cycle(cycle_id,array['ADMIN','LOGISTIK','MARKETING']::public.bms_role[]));
create policy estimates_read on public.rhpp_estimates for select to authenticated using
  (public.can_read_cycle(cycle_id));
create policy estimates_insert on public.rhpp_estimates for insert to authenticated with check
  (public.can_edit_cycle(cycle_id,array['ADMIN','PPL']::public.bms_role[])
   and created_by=(select auth.uid()));

create function public.check_advance_payment() returns trigger language plpgsql security definer
set search_path = '' as $$
declare limit_amount numeric; total_paid numeric;
begin
  select amount into limit_amount from public.advances where id=new.advance_id for update;
  select coalesce(sum(amount),0) into total_paid from public.advance_payments where advance_id=new.advance_id;
  if total_paid+new.amount > limit_amount then raise exception 'Pembayaran melebihi sisa kasbon'; end if;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),'PAY_ADVANCE','advance_payments',new.id::text,to_jsonb(new));
  return new;
end $$;
revoke all on function public.check_advance_payment() from public, anon, authenticated;
create trigger guard_advance_payment before insert on public.advance_payments
for each row execute function public.check_advance_payment();

create trigger guard_expeditions before insert or update or delete on public.expeditions
for each row execute function public.audit_and_guard();
create trigger guard_rhpp_estimates before insert or update or delete on public.rhpp_estimates
for each row execute function public.audit_and_guard();

create view public.advance_balances with (security_invoker=true) as
select a.id,a.employee_id,a.advanced_on,a.amount,coalesce(p.paid,0) paid,
  a.amount-coalesce(p.paid,0) balance
from public.advances a left join
 (select advance_id,sum(amount) paid from public.advance_payments group by advance_id) p
 on p.advance_id=a.id;
