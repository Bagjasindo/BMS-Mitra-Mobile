-- Lock RHPP Real so application users can only create it through finance_save_rhpp_real_atomic.
-- Applied to Supabase live on 2026-09-27.

alter table public.rhpp_real enable row level security;

drop policy if exists admin_full_access on public.rhpp_real;
drop policy if exists rhpp_assignment_insert on public.rhpp_real;
drop policy if exists rhpp_assignment_update on public.rhpp_real;
drop policy if exists rhpp_assignment_delete on public.rhpp_real;

revoke insert, update, delete, truncate, references, trigger
on table public.rhpp_real
from authenticated;

grant select
on table public.rhpp_real
to authenticated;

revoke execute on function public.finance_save_rhpp_real_atomic(uuid,numeric,date,text,text)
from public, anon;

grant execute on function public.finance_save_rhpp_real_atomic(uuid,numeric,date,text,text)
to authenticated;
