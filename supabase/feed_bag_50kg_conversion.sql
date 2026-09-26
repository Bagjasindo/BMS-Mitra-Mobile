alter table public.items
  add column if not exists kg_per_unit numeric(10,2);

alter table public.supplies
  add column if not exists quantity_kg numeric(18,2);

create or replace function public.normalize_item_unit()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
begin
  if new.category='DOC' then
    new.unit := 'EKOR';
    new.kg_per_unit := null;
  elsif new.category='PAKAN' then
    new.unit := 'ZAK';
    new.kg_per_unit := 50.00;
  else
    new.unit := upper(trim(new.unit));
    new.kg_per_unit := null;
    if new.unit is null or new.unit='' then
      raise exception 'Satuan wajib diisi untuk OVK/LAINNYA';
    end if;
  end if;
  return new;
end
$$;

create or replace function public.compute_supply_quantity_kg()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
declare
  cat text;
  kg_unit numeric;
begin
  select category,kg_per_unit into cat,kg_unit
  from public.items
  where id=new.item_id;

  if cat='PAKAN' then
    new.quantity_kg := round(new.quantity * coalesce(kg_unit,50),2);
  else
    new.quantity_kg := null;
  end if;
  return new;
end
$$;

create or replace function public.compute_recording_feed_kg()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
declare
  cat text;
  kg_unit numeric;
begin
  if new.feed_item_id is not null and new.feed_bags_out is not null then
    select category,kg_per_unit into cat,kg_unit
    from public.items
    where id=new.feed_item_id;

    if cat='PAKAN' then
      new.feed_kg := round(new.feed_bags_out * coalesce(kg_unit,50),2);
    end if;
  end if;
  return new;
end
$$;

revoke all on function public.normalize_item_unit() from public,anon,authenticated;
revoke all on function public.compute_supply_quantity_kg() from public,anon,authenticated;
revoke all on function public.compute_recording_feed_kg() from public,anon,authenticated;

drop trigger if exists normalize_item_unit on public.items;
create trigger normalize_item_unit
before insert or update of category,unit
on public.items
for each row execute function public.normalize_item_unit();

drop trigger if exists compute_supply_quantity_kg on public.supplies;
create trigger compute_supply_quantity_kg
before insert or update of item_id,quantity
on public.supplies
for each row execute function public.compute_supply_quantity_kg();

drop trigger if exists compute_recording_feed_kg on public.recordings;
create trigger compute_recording_feed_kg
before insert or update of feed_item_id,feed_bags_out
on public.recordings
for each row execute function public.compute_recording_feed_kg();
