-- Multiple destinations per Expedisi trip
-- Applied live 2026-09-27

create table if not exists public.finance_expedition_trip_destinations (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.finance_expedition_trips(id) on delete cascade,
  line_no integer not null check (line_no > 0),
  destination_id uuid references public.expedition_destinations(id),
  destination_name text not null,
  cargo text,
  qty numeric check (qty is null or qty >= 0),
  unit text,
  notes text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  unique(trip_id,line_no)
);

create index if not exists idx_finance_expedition_trip_destinations_trip
  on public.finance_expedition_trip_destinations(trip_id,line_no);

alter table public.finance_expedition_trip_destinations enable row level security;

drop policy if exists finance_expedition_trip_destinations_read on public.finance_expedition_trip_destinations;
create policy finance_expedition_trip_destinations_read
on public.finance_expedition_trip_destinations
for select to authenticated
using (private.my_bms_role() in ('ADMIN','LOGISTIK','KEUANGAN','OWNER'));

drop policy if exists finance_expedition_trip_destinations_write on public.finance_expedition_trip_destinations;
create policy finance_expedition_trip_destinations_write
on public.finance_expedition_trip_destinations
for all to authenticated
using (private.my_bms_role() in ('ADMIN','LOGISTIK'))
with check (private.my_bms_role() in ('ADMIN','LOGISTIK'));

revoke all on public.finance_expedition_trip_destinations from anon;
grant select on public.finance_expedition_trip_destinations to authenticated;

create or replace function public.finance_save_expedition_trip_atomic(
  p_trip_date date,
  p_mts_sj text,
  p_rr text,
  p_driver text,
  p_vehicle text,
  p_zone text,
  p_trip_price numeric,
  p_additional numeric default 0,
  p_deduction numeric default 0,
  p_notes text default null,
  p_destinations jsonb default '[]'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v_trip_id uuid;
  v_line jsonb;
  v_no integer := 0;
  v_destination_id uuid;
  v_destination_name text;
  v_cargo text;
  v_qty numeric;
  v_unit text;
  v_total_qty numeric := 0;
  v_first_destination text;
  v_legacy_cargo text;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')
  ) then raise exception 'Akses ditolak.'; end if;

  if p_trip_date is null then raise exception 'Tanggal trip wajib diisi.'; end if;
  if nullif(trim(p_driver),'') is null then raise exception 'Sopir wajib diisi.'; end if;
  if nullif(trim(p_vehicle),'') is null then raise exception 'Kendaraan wajib diisi.'; end if;
  if nullif(trim(p_zone),'') is null then raise exception 'Zona / rute wajib diisi.'; end if;
  if p_trip_price is null or p_trip_price < 0 then raise exception 'Harga trip tidak valid.'; end if;
  if coalesce(p_additional,0) < 0 or coalesce(p_deduction,0) < 0 then raise exception 'Tambahan / potongan tidak valid.'; end if;
  if p_destinations is null or jsonb_typeof(p_destinations) <> 'array' or jsonb_array_length(p_destinations)=0 then
    raise exception 'Minimal satu tujuan wajib diisi.';
  end if;

  for v_line in select value from jsonb_array_elements(p_destinations) loop
    v_no := v_no + 1;
    v_destination_id := nullif(v_line->>'destination_id','')::uuid;
    v_destination_name := nullif(trim(v_line->>'destination_name'),'');
    v_cargo := nullif(trim(v_line->>'cargo'),'');
    v_qty := nullif(v_line->>'qty','')::numeric;
    v_unit := nullif(trim(v_line->>'unit'),'');
    if v_destination_name is null then raise exception 'Tujuan pada baris % wajib diisi.', v_no; end if;
    if v_qty is not null and v_qty < 0 then raise exception 'Qty pada baris % tidak valid.', v_no; end if;
    if v_no=1 then v_first_destination:=v_destination_name; end if;
    v_total_qty:=v_total_qty+coalesce(v_qty,0);
    v_legacy_cargo:=concat_ws(' • ',v_legacy_cargo,
      trim(concat(coalesce(v_destination_name,''),' - ',coalesce(v_cargo,''),
        case when v_qty is not null then ' '||trim(to_char(v_qty,'FM999999990.##')) else '' end,
        case when v_unit is not null then ' '||v_unit else '' end
      ))
    );
  end loop;

  insert into public.finance_expedition_trips(
    trip_date,mts_sj,rr,driver,vehicle,zone,destination,cargo,total_qty,
    trip_price,additional,deduction,reference,notes,created_by
  ) values(
    p_trip_date,nullif(trim(p_mts_sj),''),nullif(trim(p_rr),''),trim(p_driver),trim(p_vehicle),
    trim(p_zone),v_first_destination,v_legacy_cargo,v_total_qty,p_trip_price,coalesce(p_additional,0),
    coalesce(p_deduction,0),null,nullif(trim(p_notes),''),auth.uid()
  )
  returning id into v_trip_id;

  v_no:=0;
  for v_line in select value from jsonb_array_elements(p_destinations) loop
    v_no:=v_no+1;
    insert into public.finance_expedition_trip_destinations(
      trip_id,line_no,destination_id,destination_name,cargo,qty,unit,notes,created_by
    ) values(
      v_trip_id,v_no,nullif(v_line->>'destination_id','')::uuid,trim(v_line->>'destination_name'),
      nullif(trim(v_line->>'cargo'),''),nullif(v_line->>'qty','')::numeric,
      nullif(trim(v_line->>'unit'),''),nullif(trim(v_line->>'notes'),''),auth.uid()
    );
  end loop;
  return v_trip_id;
end
$$;

revoke execute on function public.finance_save_expedition_trip_atomic(
  date,text,text,text,text,text,numeric,numeric,numeric,text,jsonb
) from public,anon;
grant execute on function public.finance_save_expedition_trip_atomic(
  date,text,text,text,text,text,numeric,numeric,numeric,text,jsonb
) to authenticated;
