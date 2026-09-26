-- Keep public RPC endpoints SECURITY INVOKER while privileged implementations stay private.
-- This removes exposed SECURITY DEFINER RPC warnings while preserving server-side role checks.

create or replace function private.assign_bms_role_impl(
  p_email text, p_role public.bms_role, p_name text
) returns uuid
language plpgsql security definer set search_path = '' as $$
declare target_id uuid;
begin
  if private.my_bms_role() <> 'ADMIN' then raise exception 'Hanya Administrator'; end if;
  select id into target_id from auth.users
    where lower(email)=lower(trim(p_email)) and email_confirmed_at is not null;
  if target_id is null then raise exception 'Akun belum ditemukan atau email belum diverifikasi'; end if;
  insert into public.profiles(user_id,role,full_name,active)
    values(target_id,p_role,p_name,true)
    on conflict(user_id) do update
    set role=excluded.role,full_name=excluded.full_name,active=true;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
    values(auth.uid(),'ASSIGN_ROLE','profiles',target_id::text,
      jsonb_build_object('role',p_role,'name',p_name));
  return target_id;
end $$;

revoke all on function private.assign_bms_role_impl(text, public.bms_role, text) from public, anon;
grant execute on function private.assign_bms_role_impl(text, public.bms_role, text) to authenticated;

create or replace function public.assign_bms_role(
  p_email text, p_role public.bms_role, p_name text
) returns uuid language sql security invoker set search_path = '' as $$
  select private.assign_bms_role_impl(p_email,p_role,p_name)
$$;
revoke all on function public.assign_bms_role(text, public.bms_role, text) from public, anon;
grant execute on function public.assign_bms_role(text, public.bms_role, text) to authenticated;

create or replace function private.set_cycle_state_impl(
  p_cycle uuid, p_action text, p_reason text default null
) returns public.cycles
language plpgsql security definer set search_path = '' as $$
declare c public.cycles; role_now public.bms_role;
begin
  role_now := private.my_bms_role();
  select * into c from public.cycles where id = p_cycle for update;
  if not found then raise exception 'Siklus tidak ditemukan'; end if;

  if p_action='READY' and role_now='ADMIN' and c.state='ACTIVE' then
    if not exists(select 1 from public.contracts where cycle_id=p_cycle)
       or not exists(select 1 from public.chick_ins where cycle_id=p_cycle)
       or not exists(select 1 from public.supplies where cycle_id=p_cycle)
       or not exists(select 1 from public.recordings where cycle_id=p_cycle)
       or not exists(select 1 from public.harvests where cycle_id=p_cycle) then
      raise exception 'Kontrak, Chick-In, sapronak, recording, dan panen wajib tersedia';
    end if;
    update public.cycles set state='READY_RHPP',ready_at=now(),bop_complete=false
      where id=p_cycle returning * into c;
  elsif p_action='UNLOCK' and role_now='ADMIN' and c.state='READY_RHPP'
    and length(trim(coalesce(p_reason,''))) >= 10 then
    if exists(select 1 from public.rhpp_real where cycle_id=p_cycle)
       or exists(select 1 from public.bop where cycle_id=p_cycle) then
      raise exception 'Hapus atau koreksi transaksi keuangan melalui proses revisi sebelum membuka kunci';
    end if;
    update public.cycles set state='ACTIVE',ready_at=null,bop_complete=false
      where id=p_cycle returning * into c;
  elsif p_action='BOP_COMPLETE' and role_now='KEUANGAN' and c.state='READY_RHPP' then
    update public.cycles set bop_complete=true where id=p_cycle returning * into c;
  elsif p_action='CLOSE' and role_now='KEUANGAN' and c.state='READY_RHPP'
    and c.bop_complete and exists(select 1 from public.rhpp_real where cycle_id=p_cycle) then
    update public.cycles set state='CLOSED',closed_at=now()
      where id=p_cycle returning * into c;
  else
    raise exception 'Aksi ditolak: role, status, alasan, atau syarat belum sesuai';
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),p_action,'cycles',p_cycle::text,
    jsonb_build_object('reason',p_reason,'state',c.state));
  return c;
end $$;

revoke all on function private.set_cycle_state_impl(uuid,text,text) from public, anon;
grant execute on function private.set_cycle_state_impl(uuid,text,text) to authenticated;

create or replace function public.set_cycle_state(
  p_cycle uuid, p_action text, p_reason text default null
) returns public.cycles language sql security invoker set search_path = '' as $$
  select private.set_cycle_state_impl(p_cycle,p_action,p_reason)
$$;
revoke all on function public.set_cycle_state(uuid,text,text) from public, anon;
grant execute on function public.set_cycle_state(uuid,text,text) to authenticated;
