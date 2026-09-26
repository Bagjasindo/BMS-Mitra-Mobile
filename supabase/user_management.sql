create function public.assign_bms_role(p_email text,p_role public.bms_role,p_name text)
returns uuid language plpgsql security definer set search_path = '' as $$
declare target_id uuid;
begin
  if public.my_bms_role() <> 'ADMIN' then raise exception 'Hanya Administrator'; end if;
  select id into target_id from auth.users
    where lower(email)=lower(trim(p_email)) and email_confirmed_at is not null;
  if target_id is null then raise exception 'Akun belum ditemukan atau email belum diverifikasi'; end if;
  insert into public.profiles(user_id,role,full_name,active)
    values(target_id,p_role,p_name,true)
    on conflict(user_id) do update set role=excluded.role,full_name=excluded.full_name,active=true;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
    values(auth.uid(),'ASSIGN_ROLE','profiles',target_id::text,
      jsonb_build_object('role',p_role,'name',p_name));
  return target_id;
end $$;
revoke all on function public.assign_bms_role(text,public.bms_role,text) from public, anon;
grant execute on function public.assign_bms_role(text,public.bms_role,text) to authenticated;
