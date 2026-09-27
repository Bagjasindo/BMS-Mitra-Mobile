-- One-click Expedisi BOP from Master Rute
-- Applied live 2026-09-27

alter table public.expedition_routes
  add column if not exists bop_bbm numeric not null default 0 check (bop_bbm >= 0),
  add column if not exists bop_tol numeric not null default 0 check (bop_tol >= 0),
  add column if not exists bop_uang_jalan numeric not null default 0 check (bop_uang_jalan >= 0),
  add column if not exists bop_makan_sopir numeric not null default 0 check (bop_makan_sopir >= 0),
  add column if not exists bop_bongkar_muat numeric not null default 0 check (bop_bongkar_muat >= 0);

create unique index if not exists uq_finance_expedition_bop_auto_trip_category
on public.finance_expedition_bop(trip_id,category)
where reference='AUTO_TRIP' and trip_id is not null;

-- RPC finance_post_expedition_bop_for_trip(uuid) is deployed live.
-- It snapshots non-zero Master Rute BOP components into finance_expedition_bop
-- and prevents duplicate posting for the same trip.
