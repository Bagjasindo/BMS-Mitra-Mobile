-- The source ledger records one OP total per trip, without a component split.
alter table public.expedition_routes
  add column if not exists bop_operasional numeric not null default 0
  check (bop_operasional >= 0);

-- Standard September 2026 ledger amounts. Historic exceptions remain per-trip.
update public.expedition_routes
set bop_operasional=685000
where route_name='Cirebon-Majalengka' and bop_operasional=0;
update public.expedition_routes
set bop_operasional=800000
where route_name='Indramayu-Majalengka' and bop_operasional=0;

create or replace function public.finance_post_expedition_bop_for_trip(p_trip_id uuid)
returns numeric language plpgsql security definer set search_path to ''
as $function$
declare
  v_trip public.finance_expedition_trips%rowtype;
  v_route public.expedition_routes%rowtype;
  v_total numeric := 0;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  select * into v_trip from public.finance_expedition_trips where id=p_trip_id;
  if not found then raise exception 'Trip tidak ditemukan.'; end if;
  perform pg_advisory_xact_lock(hashtext('EXP_BOP:'||p_trip_id::text));
  if exists (select 1 from public.finance_expedition_bop where trip_id=p_trip_id and reference='AUTO_TRIP') then
    select coalesce(sum(amount),0) into v_total from public.finance_expedition_bop
    where trip_id=p_trip_id and reference='AUTO_TRIP';
    return v_total;
  end if;
  select * into v_route from public.expedition_routes where route_name=v_trip.zone and active limit 1;
  if not found then raise exception 'Master Rute untuk trip ini tidak ditemukan.'; end if;
  v_total:=coalesce(v_route.bop_operasional,0)+coalesce(v_route.bop_bbm,0)+
    coalesce(v_route.bop_tol,0)+coalesce(v_route.bop_uang_jalan,0)+
    coalesce(v_route.bop_makan_sopir,0)+coalesce(v_route.bop_bongkar_muat,0);
  if v_total<=0 then raise exception 'Biaya standar BOP untuk rute % belum diisi di Master Rute.',v_trip.zone; end if;
  if coalesce(v_route.bop_operasional,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'OPERASIONAL',v_route.bop_operasional,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Total OP dari Master Rute',auth.uid());
  end if;
  if coalesce(v_route.bop_bbm,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'BBM',v_route.bop_bbm,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Otomatis dari Master Rute',auth.uid());
  end if;
  if coalesce(v_route.bop_tol,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'TOL',v_route.bop_tol,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Otomatis dari Master Rute',auth.uid());
  end if;
  if coalesce(v_route.bop_uang_jalan,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'UANG_JALAN',v_route.bop_uang_jalan,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Otomatis dari Master Rute',auth.uid());
  end if;
  if coalesce(v_route.bop_makan_sopir,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'MAKAN_SOPIR',v_route.bop_makan_sopir,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Otomatis dari Master Rute',auth.uid());
  end if;
  if coalesce(v_route.bop_bongkar_muat,0)>0 then
    insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
    values(v_trip.trip_date,'BONGKAR_MUAT',v_route.bop_bongkar_muat,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,'AUTO_TRIP','Otomatis dari Master Rute',auth.uid());
  end if;
  return v_total;
end
$function$;

-- Exceptional actual OP totals are entered at posting time, leaving the route standard intact.
create or replace function public.finance_post_expedition_bop_for_trip(
  p_trip_id uuid,p_operational_override numeric
) returns numeric language plpgsql security definer set search_path to ''
as $function$
declare
  v_trip public.finance_expedition_trips%rowtype;
  v_total numeric;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN')
  ) then raise exception 'Akses ditolak.'; end if;
  if p_operational_override is null then
    return public.finance_post_expedition_bop_for_trip(p_trip_id);
  end if;
  if p_operational_override<=0 then raise exception 'Total OP khusus harus lebih dari nol.'; end if;
  select * into v_trip from public.finance_expedition_trips where id=p_trip_id;
  if not found then raise exception 'Trip tidak ditemukan.'; end if;
  perform pg_advisory_xact_lock(hashtext('EXP_BOP:'||p_trip_id::text));
  if exists (select 1 from public.finance_expedition_bop where trip_id=p_trip_id and reference='AUTO_TRIP') then
    select coalesce(sum(amount),0) into v_total from public.finance_expedition_bop
    where trip_id=p_trip_id and reference='AUTO_TRIP';
    return v_total;
  end if;
  insert into public.finance_expedition_bop(incurred_on,category,amount,trip_id,driver,vehicle,route,reference,notes,created_by)
  values(v_trip.trip_date,'OPERASIONAL',p_operational_override,v_trip.id,v_trip.driver,v_trip.vehicle,v_trip.zone,
    'AUTO_TRIP','Total OP khusus sesuai buku besar',auth.uid());
  return p_operational_override;
end
$function$;

revoke execute on function public.finance_post_expedition_bop_for_trip(uuid,numeric) from public,anon;
grant execute on function public.finance_post_expedition_bop_for_trip(uuid,numeric) to authenticated;
