-- Reopening a BOP entry invalidates the finance completeness confirmation.
create function public.reset_bop_complete() returns trigger language plpgsql security definer
set search_path = '' as $$
begin
  update public.cycles set bop_complete = false where id = new.cycle_id;
  return new;
end $$;
revoke all on function public.reset_bop_complete() from public, anon, authenticated;
create trigger reset_bop_confirmation after insert or update on public.bop
for each row execute function public.reset_bop_complete();
