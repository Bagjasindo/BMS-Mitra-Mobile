create sequence if not exists public.barn_assets_reference_seq start 1;

create or replace function public.set_barn_asset_reference()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  if new.reference is null or btrim(new.reference) = '' then
    new.reference := 'AST-' || lpad(nextval('public.barn_assets_reference_seq')::text, 4, '0');
  end if;
  return new;
end;
$$;

drop trigger if exists trg_barn_assets_reference on public.barn_assets;
create trigger trg_barn_assets_reference
before insert on public.barn_assets
for each row execute function public.set_barn_asset_reference();

update public.barn_assets
set reference = 'AST-0001'
where id = 'f2d6b322-e331-4382-a182-10e6a93b6060'
  and (reference is null or btrim(reference) = '');

select setval(
  'public.barn_assets_reference_seq',
  greatest(
    1,
    coalesce((
      select max(substring(reference from '^AST-([0-9]+)$')::bigint)
      from public.barn_assets
      where reference ~ '^AST-[0-9]+$'
    ),0)
  ),
  true
);

create unique index if not exists barn_assets_reference_uidx
on public.barn_assets(reference)
where reference is not null;
