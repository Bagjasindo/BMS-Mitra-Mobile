-- Correct a manually entered OP total without creating a second BOP entry.
-- The previous and replacement amounts remain visible in audit_events.
create or replace function public.finance_correct_expedition_trip_op(
  p_trip_id uuid,p_amount numeric
) returns numeric language plpgsql security definer set search_path to ''
as $function$
declare
  v_row public.finance_expedition_bop%rowtype;
  v_count integer;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_amount is null or p_amount<=0 then
    raise exception 'Nominal OP harus lebih dari nol.';
  end if;
  perform pg_advisory_xact_lock(hashtext('EXP_BOP:'||p_trip_id::text));
  select count(*) into v_count from public.finance_expedition_bop
  where trip_id=p_trip_id and reference='AUTO_TRIP';
  if v_count<>1 then
    raise exception 'Koreksi otomatis hanya tersedia untuk satu catatan OP pada trip ini.';
  end if;
  select * into v_row from public.finance_expedition_bop
  where trip_id=p_trip_id and reference='AUTO_TRIP' and category='OPERASIONAL'
  for update;
  if not found then
    raise exception 'Catatan OP trip tidak ditemukan.';
  end if;
  if v_row.amount=p_amount then return p_amount; end if;
  update public.finance_expedition_bop set amount=p_amount where id=v_row.id;
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),'UPDATE','finance_expedition_bop',v_row.id::text,
    jsonb_build_object('trip_id',p_trip_id,'amount',v_row.amount,'category',v_row.category),
    jsonb_build_object('trip_id',p_trip_id,'amount',p_amount,'category',v_row.category));
  return p_amount;
end
$function$;

revoke execute on function public.finance_correct_expedition_trip_op(uuid,numeric) from public,anon;
grant execute on function public.finance_correct_expedition_trip_op(uuid,numeric) to authenticated;
