alter table public.contracts
  add constraint contracts_nonnegative_prices
  check (
    doc_price >= 0
    and pre_starter_price >= 0
    and starter_price >= 0
    and finisher_price >= 0
    and ovk_price >= 0
    and harvest_price >= 0
  );

create or replace view public.contract_readiness
with (security_invoker=true) as
select
  k.id as contract_id,
  k.cycle_id,
  k.number,
  (
    k.doc_price > 0
    and k.pre_starter_price > 0
    and k.starter_price > 0
    and k.finisher_price > 0
    and nullif(trim(coalesce(k.signed_reference,'')),'') is not null
    and (
      (k.ovk_price_basis='FIXED' and k.ovk_price > 0)
      or
      (k.ovk_price_basis='DISTRIBUTOR_PLUS_VAT' and k.ovk_vat_percent is not null)
    )
    and exists(select 1 from public.contract_live_prices lp where lp.contract_id=k.id)
    and exists(select 1 from public.performance_standards ps where ps.contract_id=k.id)
  ) as is_complete,
  array_remove(array[
    case when k.doc_price <= 0 then 'Harga DOC' end,
    case when k.pre_starter_price <= 0 then 'Harga Pre Starter' end,
    case when k.starter_price <= 0 then 'Harga Starter' end,
    case when k.finisher_price <= 0 then 'Harga Finisher' end,
    case when nullif(trim(coalesce(k.signed_reference,'')),'') is null then 'Referensi kontrak ditandatangani' end,
    case when k.ovk_price_basis='FIXED' and k.ovk_price <= 0 then 'Harga OVK' end,
    case when k.ovk_price_basis='DISTRIBUTOR_PLUS_VAT' and k.ovk_vat_percent is null then 'PPN OVK' end,
    case when not exists(select 1 from public.contract_live_prices lp where lp.contract_id=k.id) then 'Harga ayam hidup' end,
    case when not exists(select 1 from public.performance_standards ps where ps.contract_id=k.id) then 'Standar performa' end
  ],null) as missing_components
from public.contracts k;

grant select on public.contract_readiness to authenticated;

create or replace function private.set_cycle_state_impl(
  p_cycle uuid,
  p_action text,
  p_reason text default null
)
returns public.cycles
language plpgsql
security definer
set search_path = ''
as $$
declare
  c public.cycles;
  role_now public.bms_role;
  contract_ok boolean;
  missing text[];
begin
  role_now := private.my_bms_role();

  select * into c
  from public.cycles
  where id=p_cycle
  for update;

  if not found then raise exception 'Siklus tidak ditemukan'; end if;

  if p_action='READY' and role_now='ADMIN' and c.state='ACTIVE' then
    select cr.is_complete, cr.missing_components
      into contract_ok, missing
    from public.contract_readiness cr
    where cr.cycle_id=p_cycle;

    if contract_ok is distinct from true then
      raise exception 'Kontrak belum lengkap: %',
        array_to_string(coalesce(missing,array['Kontrak belum tersedia']::text[]),', ');
    end if;

    if not exists(select 1 from public.chick_ins where cycle_id=p_cycle)
       or not exists(select 1 from public.supplies where cycle_id=p_cycle)
       or not exists(select 1 from public.recordings where cycle_id=p_cycle)
       or not exists(select 1 from public.harvests where cycle_id=p_cycle) then
      raise exception 'Chick-In, sapronak, recording, dan panen wajib tersedia';
    end if;

    update public.cycles
      set state='READY_RHPP',ready_at=now(),bop_complete=false
      where id=p_cycle returning * into c;

  elsif p_action='UNLOCK'
    and role_now='ADMIN'
    and c.state='READY_RHPP'
    and length(trim(coalesce(p_reason,''))) >= 10 then

    if exists(select 1 from public.rhpp_real where cycle_id=p_cycle)
       or exists(select 1 from public.bop where cycle_id=p_cycle) then
      raise exception 'Hapus atau koreksi transaksi keuangan melalui proses revisi sebelum membuka kunci';
    end if;

    update public.cycles
      set state='ACTIVE',ready_at=null,bop_complete=false
      where id=p_cycle returning * into c;

  elsif p_action='BOP_COMPLETE'
    and role_now='KEUANGAN'
    and c.state='READY_RHPP' then
    update public.cycles set bop_complete=true where id=p_cycle returning * into c;

  elsif p_action='CLOSE'
    and role_now='KEUANGAN'
    and c.state='READY_RHPP'
    and c.bop_complete
    and exists(select 1 from public.rhpp_real where cycle_id=p_cycle) then
    update public.cycles set state='CLOSED',closed_at=now()
      where id=p_cycle returning * into c;

  else
    raise exception 'Aksi ditolak: role, status, alasan, atau syarat belum sesuai';
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),p_action,'cycles',p_cycle::text,
    jsonb_build_object('reason',p_reason,'state',c.state));

  return c;
end
$$;
