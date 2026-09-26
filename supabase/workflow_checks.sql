create or replace function public.set_cycle_state(p_cycle uuid, p_action text, p_reason text default null)
returns public.cycles language plpgsql security definer set search_path = '' as $$
declare c public.cycles; role_now public.bms_role;
begin
  role_now := public.my_bms_role();
  select * into c from public.cycles where id = p_cycle for update;
  if not found then raise exception 'Siklus tidak ditemukan'; end if;
  if p_action = 'READY' and role_now = 'ADMIN' and c.state = 'ACTIVE' then
    if not exists(select 1 from public.contracts where cycle_id = p_cycle) or
       not exists(select 1 from public.chick_ins where cycle_id = p_cycle) or
       not exists(select 1 from public.supplies where cycle_id = p_cycle) or
       not exists(select 1 from public.recordings where cycle_id = p_cycle) or
       not exists(select 1 from public.harvests where cycle_id = p_cycle) then
       raise exception 'Kontrak, Chick-In, sapronak, recording, dan panen wajib tersedia'; end if;
    update public.cycles set state = 'READY_RHPP',ready_at = now(),bop_complete = false where id = p_cycle returning * into c;
  elsif p_action = 'UNLOCK' and role_now = 'ADMIN' and c.state = 'READY_RHPP' and length(trim(coalesce(p_reason,''))) >= 10 then
    if exists(select 1 from public.rhpp_real where cycle_id = p_cycle) or
       exists(select 1 from public.bop where cycle_id = p_cycle) then
      raise exception 'Hapus atau koreksi transaksi keuangan melalui proses revisi sebelum membuka kunci';
    end if;
    update public.cycles set state = 'ACTIVE',ready_at = null,bop_complete = false where id = p_cycle returning * into c;
  elsif p_action = 'BOP_COMPLETE' and role_now = 'KEUANGAN' and c.state = 'READY_RHPP' then
    update public.cycles set bop_complete = true where id = p_cycle returning * into c;
  elsif p_action = 'CLOSE' and role_now = 'KEUANGAN' and c.state = 'READY_RHPP'
    and c.bop_complete and exists(select 1 from public.rhpp_real where cycle_id = p_cycle) then
    update public.cycles set state = 'CLOSED',closed_at = now() where id = p_cycle returning * into c;
  else raise exception 'Aksi ditolak: role, status, alasan, atau syarat belum sesuai';
  end if;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),p_action,'cycles',p_cycle::text,jsonb_build_object('reason',p_reason,'state',c.state));
  return c;
end $$;
