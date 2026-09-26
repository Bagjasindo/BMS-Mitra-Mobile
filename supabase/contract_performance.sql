-- Contract price tables are entered per signed contract; source images are references,
-- not automatic values, because some photographed digits and clauses are unclear.
create table public.contract_live_prices (
  id uuid primary key default gen_random_uuid(),
  contract_id uuid not null references public.contracts(id),
  min_weight_kg numeric(8,3) not null check(min_weight_kg >= 0),
  max_weight_kg numeric(8,3) check(max_weight_kg > min_weight_kg),
  price_per_kg numeric(18,2) not null check(price_per_kg >= 0),
  unique(contract_id,min_weight_kg)
);
create table public.contract_bonuses (
  id uuid primary key default gen_random_uuid(),
  contract_id uuid not null references public.contracts(id),
  metric text not null check(metric in ('IP','FCR_DIFFERENCE','DEPLETION','OTHER')),
  min_value numeric(12,4),
  max_value numeric(12,4),
  rupiah_per_kg numeric(18,2) not null default 0,
  notes text, check(max_value is null or min_value is null or max_value > min_value)
);
create table public.performance_standards (
  id uuid primary key default gen_random_uuid(),
  contract_id uuid not null references public.contracts(id),
  age_days integer not null check(age_days >= 0),
  std_body_weight_g numeric(10,2) check(std_body_weight_g > 0),
  std_fcr numeric(8,3) check(std_fcr > 0),
  std_feed_g_per_bird numeric(10,2) check(std_feed_g_per_bird >= 0),
  unique(contract_id,age_days)
);
alter table public.recordings add column feed_item_id uuid references public.items(id);
alter table public.recordings add column feed_bags_in numeric(12,2) check(feed_bags_in >= 0);
alter table public.recordings add column feed_bags_out numeric(12,2) check(feed_bags_out >= 0);
alter table public.recordings add column feed_bags_balance numeric(12,2) check(feed_bags_balance >= 0);
alter table public.recordings add column actual_fcr numeric(8,3) check(actual_fcr > 0);
alter table public.recordings add column ip numeric(10,2) check(ip >= 0);
alter table public.recordings add column medication_notes text;

alter table public.contract_live_prices enable row level security;
alter table public.contract_bonuses enable row level security;
alter table public.performance_standards enable row level security;
create policy live_prices_read on public.contract_live_prices for select to authenticated
 using (exists(select 1 from public.contracts k where k.id=contract_id and public.can_read_cycle(k.cycle_id)));
create policy bonuses_read on public.contract_bonuses for select to authenticated
 using (exists(select 1 from public.contracts k where k.id=contract_id and public.can_read_cycle(k.cycle_id)));
create policy standards_read on public.performance_standards for select to authenticated
 using (exists(select 1 from public.contracts k where k.id=contract_id and public.can_read_cycle(k.cycle_id)));
create policy live_prices_insert on public.contract_live_prices for insert to authenticated
 with check (exists(select 1 from public.contracts k where k.id=contract_id and
   public.can_edit_cycle(k.cycle_id,array['ADMIN']::public.bms_role[])));
create policy bonuses_insert on public.contract_bonuses for insert to authenticated
 with check (exists(select 1 from public.contracts k where k.id=contract_id and
   public.can_edit_cycle(k.cycle_id,array['ADMIN']::public.bms_role[])));
create policy standards_insert on public.performance_standards for insert to authenticated
 with check (exists(select 1 from public.contracts k where k.id=contract_id and
   public.can_edit_cycle(k.cycle_id,array['ADMIN']::public.bms_role[])));

create function public.guard_contract_detail() returns trigger language plpgsql security definer
set search_path = '' as $$
declare cid uuid; st public.cycle_state;
begin
  select k.cycle_id,c.state into cid,st from public.contracts k
  join public.cycles c on c.id=k.cycle_id where k.id=new.contract_id for update of c;
  if st <> 'ACTIVE' then raise exception 'Kontrak siklus terkunci'; end if;
  if TG_TABLE_NAME='contract_live_prices' and exists (
    select 1 from public.contract_live_prices p where p.contract_id=new.contract_id
    and p.id<>new.id
    and numrange(p.min_weight_kg,coalesce(p.max_weight_kg,1000000),'[)')
     && numrange(new.min_weight_kg,coalesce(new.max_weight_kg,1000000),'[)')
  ) then raise exception 'Rentang bobot kontrak tumpang tindih'; end if;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
    values(auth.uid(),'INSERT',TG_TABLE_NAME,new.id::text,to_jsonb(new));
  return new;
end $$;
revoke all on function public.guard_contract_detail() from public,anon,authenticated;
create trigger guard_live_prices before insert on public.contract_live_prices
for each row execute function public.guard_contract_detail();
create trigger guard_bonuses before insert on public.contract_bonuses
for each row execute function public.guard_contract_detail();
create trigger guard_standards before insert on public.performance_standards
for each row execute function public.guard_contract_detail();

create view public.daily_performance with (security_invoker=true) as
select r.id,r.cycle_id,r.recorded_on,r.age_days,r.mortality,r.culling,r.feed_kg,
 r.avg_weight_kg,r.actual_fcr,r.ip,r.feed_bags_in,r.feed_bags_out,r.feed_bags_balance,
 s.std_body_weight_g,s.std_fcr,s.std_feed_g_per_bird,
 (r.avg_weight_kg*1000-s.std_body_weight_g) body_weight_gap_g,
 (r.actual_fcr-s.std_fcr) fcr_gap
from public.recordings r left join public.contracts k on k.cycle_id=r.cycle_id
left join public.performance_standards s on s.contract_id=k.id and s.age_days=r.age_days;
