-- BMS Mitra Online: fondasi data; semua tabel publik memakai RLS.
create extension if not exists pgcrypto;
create type public.bms_role as enum ('ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER');
create type public.cycle_state as enum ('ACTIVE','READY_RHPP','CLOSED');

create table public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role public.bms_role not null,
  full_name text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table public.barns (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  capacity integer not null check (capacity > 0),
  kind text not null check (kind in ('OPEN_HOUSE','SEMI_CLOSE_HOUSE','CLOSE_HOUSE')),
  location text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table public.cycles (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  barn_id uuid not null references public.barns(id),
  chick_in_date date,
  initial_population integer check (initial_population > 0),
  strain text,
  ppl_id uuid references public.profiles(user_id),
  state public.cycle_state not null default 'ACTIVE',
  bop_complete boolean not null default false,
  ready_at timestamptz,
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  constraint state_dates check ((state <> 'READY_RHPP' or ready_at is not null) and (state <> 'CLOSED' or closed_at is not null))
);
create unique index one_open_cycle_per_barn on public.cycles(barn_id) where state <> 'CLOSED';
create table public.contracts (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null unique references public.cycles(id),
  number text not null unique, contract_date date not null, integrator text not null,
  doc_price numeric(18,2) not null default 0, pre_starter_price numeric(18,2) not null default 0,
  starter_price numeric(18,2) not null default 0, finisher_price numeric(18,2) not null default 0,
  ovk_price numeric(18,2) not null default 0, harvest_price numeric(18,2) not null default 0,
  parameters jsonb not null default '{}'::jsonb
);
create table public.items (
  id uuid primary key default gen_random_uuid(), code text not null unique, name text not null,
  category text not null, feed_phase text, unit text not null, active boolean not null default true
);
create table public.chick_ins (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null unique references public.cycles(id),
  arrived_on date not null, hatchery text, strain text, shipped integer not null check(shipped >= 0),
  received integer not null check(received >= 0), doa integer not null check(doa >= 0),
  avg_weight numeric(12,3), delivery_number text, notes text,
  check (received + doa <= shipped)
);
create table public.supplies (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null references public.cycles(id),
  item_id uuid not null references public.items(id), quantity numeric(18,3) not null check(quantity > 0),
  received_on date not null, delivery_number text, reference text, notes text,
  created_by uuid not null default auth.uid() references public.profiles(user_id), created_at timestamptz not null default now()
);
create table public.recordings (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null references public.cycles(id),
  recorded_on date not null, age_days integer not null check(age_days >= 0),
  mortality integer not null default 0 check(mortality >= 0), culling integer not null default 0 check(culling >= 0),
  feed_kg numeric(18,3) not null default 0 check(feed_kg >= 0), avg_weight_kg numeric(12,3),
  sample_count integer check(sample_count >= 0), temperature numeric(6,2), humidity numeric(6,2), notes text,
  unique(cycle_id,recorded_on)
);
create table public.visits (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null references public.cycles(id),
  visited_on date not null, findings text, recommendation text, follow_up text, follow_up_status text, notes text
);
create table public.harvests (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null references public.cycles(id),
  harvested_on date not null, transaction_number text not null unique, delivery_number text,
  birds integer not null check(birds > 0), net_weight_kg numeric(18,3) not null check(net_weight_kg > 0),
  price_per_kg numeric(18,2) not null check(price_per_kg >= 0), buyer text,
  vehicle text, driver text, notes text
);
create table public.rhpp_real (
  cycle_id uuid primary key references public.cycles(id), amount numeric(18,2) not null,
  received_on date not null, reference text, notes text, created_by uuid not null default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now()
);
create table public.bop (
  id uuid primary key default gen_random_uuid(), cycle_id uuid not null references public.cycles(id),
  incurred_on date not null, category text not null check(category in ('OVK','TENAGA_KERJA','TRANSPORTASI','LISTRIK','PERBAIKAN','EKSPEDISI','LAINNYA')),
  amount numeric(18,2) not null check(amount >= 0), reference text, notes text
);
create table public.audit_events (
  id bigint generated always as identity primary key, actor uuid default auth.uid(), action text not null,
  table_name text not null, record_id text, old_data jsonb, new_data jsonb, occurred_at timestamptz not null default now()
);

create function public.my_bms_role() returns public.bms_role language sql stable security definer
set search_path = '' as $$ select role from public.profiles where user_id = (select auth.uid()) and active $$;
revoke all on function public.my_bms_role() from public, anon;
grant execute on function public.my_bms_role() to authenticated;
create function public.can_read_cycle(cid uuid) returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from public.cycles c where c.id = cid and
    (public.my_bms_role() in ('ADMIN','OWNER','KEUANGAN','LOGISTIK','MARKETING')
     or (public.my_bms_role() = 'PPL' and c.ppl_id = (select auth.uid())))) $$;
revoke all on function public.can_read_cycle(uuid) from public, anon;
grant execute on function public.can_read_cycle(uuid) to authenticated;
create function public.can_edit_cycle(cid uuid, allowed public.bms_role[]) returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from public.cycles c where c.id = cid and c.state = 'ACTIVE'
    and public.my_bms_role() = any(allowed)
    and (public.my_bms_role() <> 'PPL' or c.ppl_id = (select auth.uid()))) $$;
revoke all on function public.can_edit_cycle(uuid,public.bms_role[]) from public, anon;
grant execute on function public.can_edit_cycle(uuid,public.bms_role[]) to authenticated;

alter table public.profiles enable row level security;
alter table public.barns enable row level security;
alter table public.cycles enable row level security;
alter table public.contracts enable row level security;
alter table public.items enable row level security;
alter table public.chick_ins enable row level security;
alter table public.supplies enable row level security;
alter table public.recordings enable row level security;
alter table public.visits enable row level security;
alter table public.harvests enable row level security;
alter table public.rhpp_real enable row level security;
alter table public.bop enable row level security;
alter table public.audit_events enable row level security;

create policy profiles_read on public.profiles for select to authenticated using (user_id = (select auth.uid()) or public.my_bms_role() = 'ADMIN');
create policy barns_read on public.barns for select to authenticated using (public.my_bms_role() is not null);
create policy cycles_read on public.cycles for select to authenticated using
  (public.my_bms_role() in ('ADMIN','OWNER','KEUANGAN','LOGISTIK','MARKETING') or
   (public.my_bms_role() = 'PPL' and ppl_id = (select auth.uid())));
create policy items_read on public.items for select to authenticated using (public.my_bms_role() is not null);
create policy contract_read on public.contracts for select to authenticated using (public.can_read_cycle(cycle_id));
create policy chick_read on public.chick_ins for select to authenticated using (public.can_read_cycle(cycle_id));
create policy supplies_read on public.supplies for select to authenticated using (public.can_read_cycle(cycle_id));
create policy recordings_read on public.recordings for select to authenticated using (public.can_read_cycle(cycle_id));
create policy visits_read on public.visits for select to authenticated using (public.can_read_cycle(cycle_id));
create policy harvest_read on public.harvests for select to authenticated using (public.can_read_cycle(cycle_id));
create policy rhpp_read on public.rhpp_real for select to authenticated using (public.can_read_cycle(cycle_id));
create policy bop_read on public.bop for select to authenticated using (public.my_bms_role() in ('ADMIN','OWNER','KEUANGAN') and public.can_read_cycle(cycle_id));
create policy audit_read on public.audit_events for select to authenticated using (public.my_bms_role() = 'ADMIN');

-- Mutations use controlled database functions in the next phase. Direct writes remain denied by RLS.
-- This prevents bypassing status transitions and editing records after closing.
