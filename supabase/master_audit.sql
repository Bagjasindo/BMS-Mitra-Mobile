create function public.audit_master_change() returns trigger language plpgsql security definer
set search_path = '' as $$
begin
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),TG_OP,TG_TABLE_NAME,
    case when TG_OP='DELETE' then old.id::text else new.id::text end,
    case when TG_OP in ('UPDATE','DELETE') then to_jsonb(old) end,
    case when TG_OP in ('INSERT','UPDATE') then to_jsonb(new) end);
  if TG_OP='DELETE' then return old; end if;
  return new;
end $$;
revoke all on function public.audit_master_change() from public,anon,authenticated;
do $$
declare table_name text;
begin
  foreach table_name in array array['barns','cycles','items','company_profile','employees','advances'] loop
    execute format('create trigger audit_%I after insert or update or delete on public.%I for each row execute function public.audit_master_change()',table_name,table_name);
  end loop;
end $$;
