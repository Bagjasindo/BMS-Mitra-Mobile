-- Operational permissions and irreversible closing.
create or replace function public.audit_and_guard() returns trigger language plpgsql security definer
set search_path = '' as $$
declare cid uuid; state_now public.cycle_state;
begin
  cid := case when TG_OP = 'DELETE' then old.cycle_id else new.cycle_id end;
  select state into state_now from public.cycles where id = cid for update;
  if state_now is null then raise exception 'Siklus tidak ditemukan'; end if;
  if TG_TABLE_NAME in ('rhpp_real','bop') then
    if state_now = 'CLOSED' or (TG_TABLE_NAME = 'rhpp_real' and state_now <> 'READY_RHPP') then
      raise exception 'Transaksi keuangan terkunci';
    end if;
  elsif state_now <> 'ACTIVE' then
    raise exception 'Transaksi operasional terkunci';
  end if;
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values (auth.uid(),TG_OP,TG_TABLE_NAME,
    case when TG_OP = 'DELETE' then old.id::text else
      case when TG_TABLE_NAME = 'rhpp_real' then cid::text else new.id::text end end,
    case when TG_OP in ('UPDATE','DELETE') then to_jsonb(old) end,
    case when TG_OP in ('INSERT','UPDATE') then to_jsonb(new) end);
  if TG_OP = 'DELETE' then return old; else return new; end if;
end $$;
revoke all on function public.audit_and_guard() from public, anon, authenticated;

do $$
declare t text;
begin
  foreach t in array array['contracts','chick_ins','supplies','recordings','visits','harvests','rhpp_real','bop'] loop
    execute format('create trigger guard_%I before insert or update or delete on public.%I for each row execute function public.audit_and_guard()',t,t);
  end loop;
end $$;

create policy admin_barns_insert on public.barns for insert to authenticated
  with check (public.my_bms_role() = 'ADMIN');
create policy admin_items_insert on public.items for insert to authenticated
  with check (public.my_bms_role() = 'ADMIN');
create policy admin_cycles_insert on public.cycles for insert to authenticated
  with check (public.my_bms_role() = 'ADMIN');
create policy contract_insert on public.contracts for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN']::public.bms_role[]));
create policy chick_insert on public.chick_ins for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN','PPL']::public.bms_role[]));
create policy supplies_insert on public.supplies for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN','LOGISTIK']::public.bms_role[]) and created_by = (select auth.uid()));
create policy recordings_insert on public.recordings for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN','PPL']::public.bms_role[]));
create policy visits_insert on public.visits for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN','PPL']::public.bms_role[]));
create policy harvest_insert on public.harvests for insert to authenticated
  with check (public.can_edit_cycle(cycle_id,array['ADMIN','MARKETING']::public.bms_role[]));
create policy rhpp_insert on public.rhpp_real for insert to authenticated
  with check (public.my_bms_role() = 'KEUANGAN' and
    exists(select 1 from public.cycles where id = cycle_id and state = 'READY_RHPP'));
create policy bop_insert on public.bop for insert to authenticated
  with check (public.my_bms_role() = 'KEUANGAN' and
    exists(select 1 from public.cycles where id = cycle_id and state <> 'CLOSED'));

create function public.set_cycle_state(p_cycle uuid, p_action text, p_reason text default null)
returns public.cycles language plpgsql security definer set search_path = '' as $$
declare c public.cycles; role_now public.bms_role;
begin
  role_now := public.my_bms_role();
  select * into c from public.cycles where id = p_cycle for update;
  if not found then raise exception 'Siklus tidak ditemukan'; end if;
  if p_action = 'READY' and role_now = 'ADMIN' and c.state = 'ACTIVE' then
    if not exists(select 1 from public.contracts where cycle_id = p_cycle) or
       not exists(select 1 from public.chick_ins where cycle_id = p_cycle) then
       raise exception 'Kontrak dan chick-in wajib tersedia'; end if;
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
revoke all on function public.set_cycle_state(uuid,text,text) from public, anon;
grant execute on function public.set_cycle_state(uuid,text,text) to authenticated;

create view public.cycle_financials with (security_invoker = true) as
select c.id cycle_id,c.code,c.state,r.amount rhpp_amount,coalesce(b.total,0) bop_total,
  r.amount-coalesce(b.total,0) profit
from public.cycles c left join public.rhpp_real r on r.cycle_id = c.id
left join (select cycle_id,sum(amount) total from public.bop group by cycle_id) b on b.cycle_id=c.id;
