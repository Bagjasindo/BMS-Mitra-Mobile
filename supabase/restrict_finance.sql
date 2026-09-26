drop policy rhpp_read on public.rhpp_real;
create policy rhpp_read on public.rhpp_real for select to authenticated
using (public.my_bms_role() in ('ADMIN','OWNER','KEUANGAN')
  and public.can_read_cycle(cycle_id));
