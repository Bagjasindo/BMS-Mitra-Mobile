-- Move internal RLS helpers out of the exposed public API schema.
create schema if not exists private;
revoke all on schema private from public, anon;
grant usage on schema private to authenticated;

alter function public.my_bms_role() set schema private;
alter function public.can_read_cycle(uuid) set schema private;
alter function public.can_edit_cycle(uuid, public.bms_role[]) set schema private;

create or replace function private.my_bms_role()
returns public.bms_role language sql stable security definer
set search_path = '' as $$
  select role from public.profiles
  where user_id = (select auth.uid()) and active
$$;

create or replace function private.can_read_cycle(cid uuid)
returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from public.cycles c where c.id = cid and
    (private.my_bms_role() in ('ADMIN','OWNER','KEUANGAN','LOGISTIK','MARKETING')
     or (private.my_bms_role() = 'PPL' and c.ppl_id = (select auth.uid()))))
$$;

create or replace function private.can_edit_cycle(cid uuid, allowed public.bms_role[])
returns boolean language sql stable security definer
set search_path = '' as $$
  select exists(select 1 from public.cycles c where c.id = cid and c.state = 'ACTIVE'
    and private.my_bms_role() = any(allowed)
    and (private.my_bms_role() <> 'PPL' or c.ppl_id = (select auth.uid())))
$$;

revoke all on function private.my_bms_role() from public, anon;
revoke all on function private.can_read_cycle(uuid) from public, anon;
revoke all on function private.can_edit_cycle(uuid, public.bms_role[]) from public, anon;
grant execute on function private.my_bms_role() to authenticated;
grant execute on function private.can_read_cycle(uuid) to authenticated;
grant execute on function private.can_edit_cycle(uuid, public.bms_role[]) to authenticated;
