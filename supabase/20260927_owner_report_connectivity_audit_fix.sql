-- Owner report connectivity audit fixes.
drop policy if exists external_return_transfer_read on public.logistics_external_return_transfers;
create policy external_return_transfer_read
on public.logistics_external_return_transfers
for select
to authenticated
using (
  private.my_bms_role() = any (
    array[
      'ADMIN'::public.bms_role,
      'LOGISTIK'::public.bms_role,
      'KEUANGAN'::public.bms_role,
      'OWNER'::public.bms_role
    ]
  )
);

create or replace function public.production_ppl_directory()
returns table(user_id uuid, full_name text)
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if v_role not in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role,'PPL'::public.bms_role) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select p.user_id,p.full_name
  from public.profiles p
  where p.active
    and p.role='PPL'::public.bms_role
    and (v_role <> 'PPL'::public.bms_role or p.user_id=auth.uid())
  order by p.full_name;
end
$function$;

grant execute on function public.production_ppl_directory() to authenticated;

create or replace function public.production_feed_stock(p_contract_assignment_id uuid)
returns table(
  item_id uuid, code text, name text, unit text, kg_per_unit numeric,
  sent_units numeric, external_units numeric, returned_units numeric,
  used_units numeric, remaining_units numeric, remaining_kg numeric
)
language plpgsql
security definer
set search_path = ''
as $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if v_role not in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role,'PPL'::public.bms_role) then
    raise exception 'Akses ditolak.';
  end if;

  if not exists (
    select 1
    from public.logistics_contract_assignments a
    where a.id=p_contract_assignment_id
      and (
        v_role in ('ADMIN'::public.bms_role,'OWNER'::public.bms_role)
        or (v_role='PPL'::public.bms_role and a.ppl_id=auth.uid())
      )
  ) then
    raise exception 'Kontrak tidak ditemukan atau tidak dapat diakses.';
  end if;

  return query
  with feed as (
    select i.id item_id,i.code,i.name,i.unit,coalesce(i.kg_per_unit,0) kg_per_unit
    from public.items i where i.active=true and i.category='PAKAN'
  ),
  sent as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_shipments s
    join public.logistics_shipment_items li on li.shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ext as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_external_shipments s
    join public.logistics_external_shipment_items li on li.external_shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ret as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_returns r
    join public.logistics_return_items li on li.return_id=r.id
    where r.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  used as (
    select r.feed_item_id item_id,coalesce(sum(r.feed_quantity_units),0) qty
    from public.recordings r
    where r.contract_assignment_id=p_contract_assignment_id
    group by r.feed_item_id
  )
  select
    f.item_id,f.code,f.name,f.unit,f.kg_per_unit,
    coalesce(s.qty,0),coalesce(e.qty,0),coalesce(rt.qty,0),coalesce(u.qty,0),
    greatest(0,coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(u.qty,0)),
    greatest(0,coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(u.qty,0))*f.kg_per_unit
  from feed f
  left join sent s on s.item_id=f.item_id
  left join ext e on e.item_id=f.item_id
  left join ret rt on rt.item_id=f.item_id
  left join used u on u.item_id=f.item_id
  where coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)>0
  order by f.code;
end
$function$;

grant execute on function public.production_feed_stock(uuid) to authenticated;
