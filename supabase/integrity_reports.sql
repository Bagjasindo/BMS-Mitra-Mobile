create function public.validate_chick_in() returns trigger language plpgsql security definer
set search_path = '' as $$
declare cap integer; planned integer;
begin
  select b.capacity,c.initial_population into cap,planned
  from public.cycles c join public.barns b on b.id=c.barn_id
  where c.id=new.cycle_id;
  if new.received > cap then raise exception 'Jumlah diterima melebihi kapasitas kandang'; end if;
  if planned is not null and new.received <> planned then
    raise exception 'Populasi Chick-In harus sama dengan populasi awal siklus';
  end if;
  return new;
end $$;
revoke all on function public.validate_chick_in() from public,anon,authenticated;
create trigger validate_chick_in before insert or update on public.chick_ins
for each row execute function public.validate_chick_in();

create function public.validate_cycle_population() returns trigger language plpgsql security definer
set search_path = '' as $$
declare qty_received integer; dead integer; harvested integer;
begin
  select ci.received into qty_received from public.chick_ins ci where cycle_id=new.cycle_id;
  if qty_received is null then raise exception 'Chick-In wajib tersedia'; end if;
  select coalesce(sum(mortality+culling),0) into dead
    from public.recordings where cycle_id=new.cycle_id and id is distinct from new.id;
  select coalesce(sum(birds),0) into harvested
    from public.harvests where cycle_id=new.cycle_id and id is distinct from new.id;
  if TG_TABLE_NAME='recordings' then dead:=dead+new.mortality+new.culling; end if;
  if TG_TABLE_NAME='harvests' then harvested:=harvested+new.birds; end if;
  if dead+harvested>qty_received then
    raise exception 'Mortalitas, afkir, dan panen melebihi populasi diterima';
  end if;
  return new;
end $$;
revoke all on function public.validate_cycle_population() from public,anon,authenticated;
create trigger validate_recording_population before insert or update on public.recordings
for each row execute function public.validate_cycle_population();
create trigger validate_harvest_population before insert or update on public.harvests
for each row execute function public.validate_cycle_population();

create view public.cycle_performance with (security_invoker=true) as
select c.id cycle_id,c.code,c.initial_population,
  coalesce(r.dead,0) mortality,coalesce(r.culled,0) culling,
  coalesce(r.feed,0) feed_kg,r.last_age,r.last_weight_kg,
  coalesce(h.birds,0) harvested_birds,coalesce(h.weight,0) harvested_weight_kg,
  c.initial_population-coalesce(r.dead,0)-coalesce(r.culled,0)-coalesce(h.birds,0) live_birds,
  round(coalesce(r.feed,0)/nullif(h.weight,0),3) fcr
from public.cycles c
left join (select cycle_id,sum(mortality) dead,sum(culling) culled,sum(feed_kg) feed,
  max(age_days) last_age,
  (array_agg(avg_weight_kg order by recorded_on desc) filter(where avg_weight_kg is not null))[1] last_weight_kg
  from public.recordings group by cycle_id) r on r.cycle_id=c.id
left join (select cycle_id,sum(birds) birds,sum(net_weight_kg) weight
  from public.harvests group by cycle_id) h on h.cycle_id=c.id;
