-- Lock contract templates permanently after Administrator finalizes them.
-- Once contracts.frozen_at is set, contract header and all child price/bonus/performance rows are read-only.

create or replace function public.guard_frozen_contract()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'UPDATE' then
    if old.frozen_at is not null then
      raise exception 'Kontrak sudah dikunci dan tidak dapat diubah. Buat kontrak baru untuk revisi.';
    end if;
    return new;
  elsif tg_op = 'DELETE' then
    if old.frozen_at is not null then
      raise exception 'Kontrak sudah dikunci dan tidak dapat dihapus.';
    end if;
    return old;
  end if;
  return coalesce(new,old);
end;
$$;

drop trigger if exists trg_guard_frozen_contract on public.contracts;
create trigger trg_guard_frozen_contract
before update or delete on public.contracts
for each row execute function public.guard_frozen_contract();

create or replace function public.guard_frozen_contract_child()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  old_contract uuid;
  new_contract uuid;
begin
  if tg_op in ('UPDATE','DELETE') then
    old_contract := old.contract_id;
    if exists(select 1 from public.contracts c where c.id=old_contract and c.frozen_at is not null) then
      raise exception 'Kontrak sudah dikunci. Data harga/bonus/performa tidak dapat diubah.';
    end if;
  end if;

  if tg_op in ('INSERT','UPDATE') then
    new_contract := new.contract_id;
    if exists(select 1 from public.contracts c where c.id=new_contract and c.frozen_at is not null) then
      raise exception 'Kontrak sudah dikunci. Data harga/bonus/performa tidak dapat ditambah atau diubah.';
    end if;
    return new;
  end if;

  return old;
end;
$$;

drop trigger if exists trg_guard_frozen_contract_live_prices on public.contract_live_prices;
create trigger trg_guard_frozen_contract_live_prices
before insert or update or delete on public.contract_live_prices
for each row execute function public.guard_frozen_contract_child();

drop trigger if exists trg_guard_frozen_contract_bonuses on public.contract_bonuses;
create trigger trg_guard_frozen_contract_bonuses
before insert or update or delete on public.contract_bonuses
for each row execute function public.guard_frozen_contract_child();

drop trigger if exists trg_guard_frozen_performance_standards on public.performance_standards;
create trigger trg_guard_frozen_performance_standards
before insert or update or delete on public.performance_standards
for each row execute function public.guard_frozen_contract_child();
