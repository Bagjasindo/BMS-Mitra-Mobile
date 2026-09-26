create or replace function public.audit_and_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  cid uuid;
  state_now public.cycle_state;
  rid text;
begin
  cid := case when TG_OP = 'DELETE' then old.cycle_id else new.cycle_id end;

  select state into state_now
  from public.cycles
  where id = cid
  for update;

  if state_now is null then
    raise exception 'Siklus tidak ditemukan';
  end if;

  if TG_TABLE_NAME in ('rhpp_real','bop') then
    if state_now = 'CLOSED'
       or (TG_TABLE_NAME = 'rhpp_real' and state_now <> 'READY_RHPP') then
      raise exception 'Transaksi keuangan terkunci';
    end if;
  elsif state_now <> 'ACTIVE' then
    raise exception 'Transaksi operasional terkunci';
  end if;

  if TG_TABLE_NAME = 'rhpp_real' then
    rid := cid::text;
  elsif TG_OP = 'DELETE' then
    rid := old.id::text;
  else
    rid := new.id::text;
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(
    auth.uid(),TG_OP,TG_TABLE_NAME,rid,
    case when TG_OP in ('UPDATE','DELETE') then to_jsonb(old) end,
    case when TG_OP in ('INSERT','UPDATE') then to_jsonb(new) end
  );

  if TG_OP = 'DELETE' then return old; else return new; end if;
end
$$;

revoke all on function public.audit_and_guard() from public, anon, authenticated;
