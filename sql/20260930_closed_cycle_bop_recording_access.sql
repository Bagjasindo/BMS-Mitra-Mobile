create table public.finance_bop_period_access (
 contract_assignment_id uuid primary key references public.logistics_contract_assignments(id) on delete cascade,
 is_open boolean not null default false,
 changed_by uuid not null,
 changed_at timestamptz not null default now()
);
alter table public.finance_bop_period_access enable row level security;
grant select on public.finance_bop_period_access to authenticated;
revoke all on public.finance_bop_period_access from anon;
create policy finance_bop_access_read on public.finance_bop_period_access for select to authenticated using (
 exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER'))
);
create or replace function public.admin_set_finance_bop_period_access(p_assignment_id uuid,p_is_open boolean)
returns void language plpgsql security definer set search_path='' as $fn$
declare previous_data jsonb;
begin
 if auth.uid() is null or not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN') then raise exception 'Hanya ADMIN yang dapat membuka atau mengunci pencatatan BOP.'; end if;
 if p_is_open is null then raise exception 'Status akses BOP wajib dipilih.'; end if;
 perform 1 from public.logistics_contract_assignments a where a.id=p_assignment_id and not a.active for update;
 if not found then raise exception 'Pilih siklus CLOSED. Siklus produksi aktif tidak memerlukan pembukaan BOP.'; end if;
 select to_jsonb(x) into previous_data from public.finance_bop_period_access x where x.contract_assignment_id=p_assignment_id;
 insert into public.finance_bop_period_access(contract_assignment_id,is_open,changed_by)
 values(p_assignment_id,p_is_open,auth.uid())
 on conflict(contract_assignment_id) do update set is_open=excluded.is_open,changed_by=excluded.changed_by,changed_at=now();
 insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
 values(auth.uid(),case when p_is_open then 'OPEN_BOP_RECORDING' else 'LOCK_BOP_RECORDING' end,'finance_bop_period_access',p_assignment_id::text,previous_data,jsonb_build_object('is_open',p_is_open,'production_status','CLOSED'));
end;
$fn$;
revoke all on function public.admin_set_finance_bop_period_access(uuid,boolean) from public,anon;
grant execute on function public.admin_set_finance_bop_period_access(uuid,boolean) to authenticated;
create or replace function private.guard_assignment_operation()
returns trigger language plpgsql set search_path='' as $fn$
declare
 a public.logistics_contract_assignments%rowtype;
 aid uuid;
 finance_access boolean;
begin
 aid:=case when tg_op='DELETE' then old.contract_assignment_id else new.contract_assignment_id end;
 if aid is null then raise exception 'Kandang / Kontrak Logistik wajib dipilih.'; end if;
 select * into a from public.logistics_contract_assignments where id=aid;
 if a.id is null then raise exception 'Kontrak Logistik tidak ditemukan.'; end if;
 finance_access:=tg_table_schema='public' and tg_table_name='bop' and exists(
  select 1 from public.profiles p where p.user_id=auth.uid() and p.active
   and p.role in ('ADMIN','KEUANGAN') and (tg_op<>'DELETE' or p.role='ADMIN')
 ) and exists(select 1 from public.finance_bop_period_access x where x.contract_assignment_id=aid and x.is_open);
 if not a.active and not finance_access then raise exception 'Kontrak Logistik sudah CLOSED dan data terkunci. Untuk BOP, ADMIN dapat Buka Pencatatan BOP.'; end if;
 if tg_table_schema='public' and tg_table_name='bop' and tg_op='UPDATE' and old.contract_assignment_id is distinct from new.contract_assignment_id then
  if exists(select 1 from public.logistics_contract_assignments x where x.id=old.contract_assignment_id and not x.active)
   and not (exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')) and exists(select 1 from public.finance_bop_period_access x where x.contract_assignment_id=old.contract_assignment_id and x.is_open))
  then raise exception 'BOP periode asal CLOSED masih terkunci.'; end if;
 end if;
 if tg_op='DELETE' then return old; end if;
 new.barn_id:=a.barn_id;
 new.cycle_id:=null;
 return new;
end;
$fn$;