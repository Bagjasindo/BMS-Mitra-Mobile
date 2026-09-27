-- Lock RHPP Sistem Final so application users can only create it through the official Close Produksi RPC.
-- Applied to Supabase live on 2026-09-27.

alter table public.rhpp_system_final enable row level security;

drop policy if exists admin_full_access on public.rhpp_system_final;

revoke insert, update, delete, truncate, references, trigger
on table public.rhpp_system_final
from authenticated;

grant select
on table public.rhpp_system_final
to authenticated;

revoke execute on function public.admin_close_production_atomic(uuid)
from public, anon;

grant execute on function public.admin_close_production_atomic(uuid)
to authenticated;
