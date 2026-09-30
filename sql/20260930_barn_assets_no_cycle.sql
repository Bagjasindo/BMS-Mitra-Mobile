create table if not exists public.barn_assets (
  id uuid primary key default gen_random_uuid(),
  barn_id uuid not null references public.barns(id) on delete restrict,
  name text not null check (length(btrim(name)) > 0),
  category text not null check (category in ('PERALATAN','MESIN','BANGUNAN','INSTALASI','KENDARAAN','LAINNYA')),
  acquired_on date not null,
  acquisition_value numeric(18,2) not null check (acquisition_value >= 0),
  condition text not null default 'BAIK' check (condition in ('BAIK','PERLU_PERBAIKAN','RUSAK')),
  status text not null default 'AKTIF' check (status in ('AKTIF','DIPINDAHKAN','DIJUAL','DINONAKTIFKAN')),
  reference text,
  notes text,
  created_by uuid default auth.uid() references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.barn_assets is
'Aset tetap per kandang. Tidak terkait siklus/contract_assignment dan tidak menjadi sumber BOP, perawatan, atau laba-rugi secara otomatis.';

create index if not exists barn_assets_barn_id_idx on public.barn_assets(barn_id);
create index if not exists barn_assets_acquired_on_idx on public.barn_assets(acquired_on desc);

alter table public.barn_assets enable row level security;

revoke all on table public.barn_assets from anon, authenticated;
grant select, insert, update, delete on table public.barn_assets to authenticated;

drop policy if exists barn_assets_read on public.barn_assets;
create policy barn_assets_read
on public.barn_assets for select
to authenticated
using ((select private.my_bms_role()) = any (array['ADMIN'::bms_role,'KEUANGAN'::bms_role]));

drop policy if exists barn_assets_insert on public.barn_assets;
create policy barn_assets_insert
on public.barn_assets for insert
to authenticated
with check (
  (select private.my_bms_role()) = any (array['ADMIN'::bms_role,'KEUANGAN'::bms_role])
  and exists (select 1 from public.barns b where b.id = barn_assets.barn_id)
);

drop policy if exists barn_assets_update on public.barn_assets;
create policy barn_assets_update
on public.barn_assets for update
to authenticated
using ((select private.my_bms_role()) = any (array['ADMIN'::bms_role,'KEUANGAN'::bms_role]))
with check (
  (select private.my_bms_role()) = any (array['ADMIN'::bms_role,'KEUANGAN'::bms_role])
  and exists (select 1 from public.barns b where b.id = barn_assets.barn_id)
);

drop policy if exists barn_assets_delete on public.barn_assets;
create policy barn_assets_delete
on public.barn_assets for delete
to authenticated
using ((select private.my_bms_role()) = any (array['ADMIN'::bms_role,'KEUANGAN'::bms_role]));
