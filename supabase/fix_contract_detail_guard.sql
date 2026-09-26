create or replace function public.guard_contract_detail()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  cid uuid;
  st public.cycle_state;
  rec_id text;
begin
  select k.cycle_id,c.state
    into cid,st
  from public.contracts k
  join public.cycles c on c.id=k.cycle_id
  where k.id=new.contract_id
  for update of c;

  if st is null then raise exception 'Kontrak atau siklus tidak ditemukan'; end if;
  if st <> 'ACTIVE' then raise exception 'Kontrak siklus terkunci'; end if;

  if TG_TABLE_NAME = 'contract_live_prices' then
    if exists (
      select 1
      from public.contract_live_prices p
      where p.contract_id=new.contract_id
        and p.id<>new.id
        and numrange(p.min_weight_kg,coalesce(p.max_weight_kg,1000000),'[)')
          && numrange(new.min_weight_kg,coalesce(new.max_weight_kg,1000000),'[)')
    ) then
      raise exception 'Rentang bobot kontrak tumpang tindih';
    end if;
  end if;

  rec_id := new.id::text;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),TG_OP,TG_TABLE_NAME,rec_id,to_jsonb(new));

  return new;
end
$$;

revoke all on function public.guard_contract_detail() from public,anon,authenticated;
