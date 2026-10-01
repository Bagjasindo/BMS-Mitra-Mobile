-- 2026-10-01
-- Tambah Daging: birds are required for new/edited transactions.
-- Contract price is derived from BW = weight_kg / birds and cannot be overridden by the client.
-- Existing legacy rows remain untouched; birds may stay NULL until explicitly corrected with real source data.

alter table public.marketing_external_meat_purchases
  add column if not exists birds integer;

alter table public.marketing_external_meat_purchases
  drop constraint if exists marketing_external_meat_purchases_birds_positive;

alter table public.marketing_external_meat_purchases
  add constraint marketing_external_meat_purchases_birds_positive
  check (birds is null or birds > 0);

create or replace function private.guard_external_meat_contract_price()
returns trigger
language plpgsql
security definer
set search_path=''
as $$
declare
  v_contract_id uuid;
  v_assignment_barn uuid;
  v_active boolean;
  v_avg numeric;
  v_price numeric;
begin
  if new.birds is null or new.birds <= 0 then
    raise exception 'Ekor Tambah Daging wajib lebih dari 0.';
  end if;
  if new.weight_kg is null or new.weight_kg <= 0 then
    raise exception 'Berat Tambah Daging wajib lebih dari 0 Kg.';
  end if;

  select a.master_contract_id,a.barn_id,a.active
    into v_contract_id,v_assignment_barn,v_active
  from public.logistics_contract_assignments a
  where a.id=new.contract_assignment_id;

  if v_contract_id is null then
    raise exception 'Kontrak siklus Tambah Daging tidak ditemukan.';
  end if;
  if not coalesce(v_active,false) then
    raise exception 'Siklus sudah CLOSED. Tambah Daging terkunci.';
  end if;
  if new.barn_id is distinct from v_assignment_barn then
    raise exception 'Kandang Tambah Daging tidak sesuai dengan kontrak siklus.';
  end if;

  v_avg := new.weight_kg / new.birds;

  select p.price_per_kg
    into v_price
  from public.contract_live_prices p
  where p.contract_id=v_contract_id
    and v_avg >= p.min_weight_kg
    and (p.max_weight_kg is null or v_avg < p.max_weight_kg)
  order by p.min_weight_kg desc
  limit 1;

  if v_price is null or v_price <= 0 then
    raise exception 'Harga kontrak untuk BW % Kg belum tersedia.', round(v_avg,3);
  end if;

  new.purchase_price_per_kg := v_price;
  return new;
end
$$;

revoke all on function private.guard_external_meat_contract_price() from public, anon, authenticated;

drop trigger if exists a_guard_external_meat_contract_price
  on public.marketing_external_meat_purchases;

create trigger a_guard_external_meat_contract_price
before insert or update on public.marketing_external_meat_purchases
for each row execute function private.guard_external_meat_contract_price();
