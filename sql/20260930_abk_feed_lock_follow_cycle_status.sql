-- Align ABK feed lock with global cycle status.
-- Active/PROSES: feed allocation may be corrected by authorized ADMIN/PPL.
-- CLOSED: feed allocation remains locked.

create or replace function public.prevent_locked_abk_basics_change()
returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_active boolean;
begin
  select a.active into v_active
  from public.logistics_contract_assignments a
  where a.id=coalesce(new.contract_assignment_id,old.contract_assignment_id);

  if coalesce(v_active,false)=false and old.basics_locked_at is not null and (
       new.feed_pre_bags is distinct from old.feed_pre_bags
    or new.feed_starter_bags is distinct from old.feed_starter_bags
    or new.feed_finisher_bags is distinct from old.feed_finisher_bags
    or new.basics_locked_at is distinct from old.basics_locked_at
  ) then
    raise exception 'Siklus sudah CLOSED. Penempatan Pakan ABK tidak dapat diubah.';
  end if;

  return new;
end
$$;
