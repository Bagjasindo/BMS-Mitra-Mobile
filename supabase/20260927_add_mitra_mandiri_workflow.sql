alter table public.logistics_contract_assignments
  add column if not exists cycle_type text not null default 'MITRA';

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid='public.logistics_contract_assignments'::regclass
      and conname='logistics_contract_assignments_cycle_type_check'
  ) then
    alter table public.logistics_contract_assignments
      add constraint logistics_contract_assignments_cycle_type_check
      check (cycle_type in ('MITRA','MANDIRI'));
  end if;
end $$;

alter table public.logistics_contract_assignments
  alter column master_contract_id drop not null,
  alter column performance_template_name drop not null;

update public.logistics_contract_assignments set cycle_type='MITRA' where cycle_type is null;

create or replace function public.prepare_logistics_contract_assignment()
returns trigger language plpgsql set search_path='' as $$
begin
  if new.cycle_type='MITRA' then
    if new.master_contract_id is null then raise exception 'Master Kontrak wajib dipilih untuk siklus Mitra'; end if;
    if new.performance_template_name is null or btrim(new.performance_template_name)='' then raise exception 'Template Performa wajib dipilih untuk siklus Mitra'; end if;
    if not exists (select 1 from public.contracts c where c.id=new.master_contract_id and c.cycle_id is null) then raise exception 'Kontrak yang dipilih bukan Master Kontrak'; end if;
    if not exists (select 1 from public.performance_standards p where p.contract_id=new.master_contract_id and p.template_name=new.performance_template_name) then raise exception 'Template Performa tidak tersedia pada kontrak yang dipilih'; end if;
  elsif new.cycle_type='MANDIRI' then
    new.master_contract_id:=null;
    new.performance_template_name:=null;
  else
    raise exception 'Jenis siklus tidak valid';
  end if;
  update public.logistics_contract_assignments set active=false
  where barn_id=new.barn_id and active=true and id is distinct from new.id;
  return new;
end $$;

create or replace function private.guard_contract_assignment_state()
returns trigger language plpgsql security definer set search_path='' as $$
begin
  if old.active=false then
    if new.active=true
       and coalesce(current_setting('bms.allow_production_reopen',true),'')='1'
       and exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN')
    then return new; end if;
    if new.active is distinct from old.active
       or new.barn_id is distinct from old.barn_id
       or new.master_contract_id is distinct from old.master_contract_id
       or new.performance_template_name is distinct from old.performance_template_name
       or new.cycle_type is distinct from old.cycle_type
       or new.start_date is distinct from old.start_date
       or new.abk_id is distinct from old.abk_id
       or new.created_by is distinct from old.created_by
       or new.created_at is distinct from old.created_at
    then raise exception 'Periode sudah Close. Gunakan Buka Kembali Siklus sebelum koreksi.'; end if;
  end if;
  if old.active=true and new.active=false
     and coalesce(current_setting('bms.allow_production_close',true),'') <> '1'
  then raise exception 'Close Produksi hanya dapat dilakukan dari proses Administrator.'; end if;
  return new;
end $$;

create table if not exists public.logistics_mandiri_purchases (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references public.suppliers(id),
  item_id uuid not null references public.items(id),
  purchase_date date not null default current_date,
  quantity numeric not null check (quantity>0),
  purchase_unit_price numeric not null check (purchase_unit_price>=0),
  reference_number text,
  notes text,
  created_by uuid default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.logistics_mandiri_purchase_allocations (
  id uuid primary key default gen_random_uuid(),
  purchase_id uuid not null references public.logistics_mandiri_purchases(id) on delete cascade,
  contract_assignment_id uuid not null references public.logistics_contract_assignments(id),
  quantity numeric not null check (quantity>0),
  created_at timestamptz not null default now(),
  unique(purchase_id,contract_assignment_id)
);

create index if not exists idx_mandiri_purchase_alloc_assignment on public.logistics_mandiri_purchase_allocations(contract_assignment_id);
create index if not exists idx_mandiri_purchase_date on public.logistics_mandiri_purchases(purchase_date);

alter table public.logistics_mandiri_purchases enable row level security;
alter table public.logistics_mandiri_purchase_allocations enable row level security;

drop policy if exists mandiri_purchase_read on public.logistics_mandiri_purchases;
create policy mandiri_purchase_read on public.logistics_mandiri_purchases for select to authenticated
using (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role,'KEUANGAN'::public.bms_role,'OWNER'::public.bms_role]));
drop policy if exists mandiri_purchase_write on public.logistics_mandiri_purchases;
create policy mandiri_purchase_write on public.logistics_mandiri_purchases for all to authenticated
using (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role]))
with check (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role]));

drop policy if exists mandiri_purchase_alloc_read on public.logistics_mandiri_purchase_allocations;
create policy mandiri_purchase_alloc_read on public.logistics_mandiri_purchase_allocations for select to authenticated
using (exists (
  select 1 from public.logistics_mandiri_purchases p
  where p.id=logistics_mandiri_purchase_allocations.purchase_id
    and private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role,'KEUANGAN'::public.bms_role,'OWNER'::public.bms_role])
));
drop policy if exists mandiri_purchase_alloc_write on public.logistics_mandiri_purchase_allocations;
create policy mandiri_purchase_alloc_write on public.logistics_mandiri_purchase_allocations for all to authenticated
using (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role]))
with check (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role]));

revoke all on public.logistics_mandiri_purchases from anon;
revoke all on public.logistics_mandiri_purchase_allocations from anon;
grant select,insert,update,delete on public.logistics_mandiri_purchases to authenticated;
grant select,insert,update,delete on public.logistics_mandiri_purchase_allocations to authenticated;

create table if not exists public.marketing_customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  phone text,
  notes text,
  active boolean not null default true,
  created_by uuid default auth.uid() references public.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.marketing_customers enable row level security;
drop policy if exists marketing_customers_read on public.marketing_customers;
create policy marketing_customers_read on public.marketing_customers for select to authenticated
using (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'MARKETING'::public.bms_role,'KEUANGAN'::public.bms_role,'OWNER'::public.bms_role]));
drop policy if exists marketing_customers_write on public.marketing_customers;
create policy marketing_customers_write on public.marketing_customers for all to authenticated
using (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'MARKETING'::public.bms_role]))
with check (private.my_bms_role() = any(array['ADMIN'::public.bms_role,'MARKETING'::public.bms_role]));
revoke all on public.marketing_customers from anon;
grant select,insert,update,delete on public.marketing_customers to authenticated;

alter table public.marketing_contract_harvests add column if not exists buyer_id uuid references public.marketing_customers(id);

create or replace function private.guard_marketing_harvest()
returns trigger language plpgsql security definer set search_path='' as $$
declare
  a public.logistics_contract_assignments%rowtype;
  v_avg_bw numeric;
  v_price numeric;
begin
  if tg_op in ('UPDATE','DELETE') then
    select * into a from public.logistics_contract_assignments where id=old.contract_assignment_id;
    if a.id is null or not a.active then raise exception 'Siklus sudah CLOSED. Data panen terkunci.'; end if;
    if tg_op='DELETE' then return old; end if;
  end if;
  select * into a from public.logistics_contract_assignments where id=new.contract_assignment_id;
  if a.id is null or not a.active then raise exception 'Siklus tidak aktif.'; end if;
  if a.barn_id<>new.barn_id then raise exception 'Kandang tidak sesuai siklus aktif.'; end if;
  if new.harvested_on<a.start_date then raise exception 'Tanggal panen tidak boleh sebelum tanggal mulai siklus.'; end if;
  if coalesce(new.birds,0)<=0 then raise exception 'Jumlah ekor harus lebih dari 0.'; end if;
  if coalesce(new.net_weight_kg,0)<=0 then raise exception 'Berat panen harus lebih dari 0 Kg.'; end if;

  v_avg_bw:=new.net_weight_kg/new.birds;
  if a.cycle_type='MANDIRI' then
    if coalesce(new.price_per_kg,0)<=0 then raise exception 'Harga jual Mandiri wajib lebih dari 0.'; end if;
    if new.buyer_id is null then raise exception 'Pelanggan Mandiri wajib dipilih.'; end if;
    if not exists(select 1 from public.marketing_customers c where c.id=new.buyer_id and c.active) then raise exception 'Pelanggan Mandiri tidak aktif atau tidak ditemukan.'; end if;
    select c.name into new.buyer_name from public.marketing_customers c where c.id=new.buyer_id;
  else
    select lp.price_per_kg into v_price
    from public.contract_live_prices lp
    where lp.contract_id=a.master_contract_id
      and v_avg_bw>=lp.min_weight_kg
      and (lp.max_weight_kg is null or v_avg_bw<lp.max_weight_kg)
    order by lp.min_weight_kg desc limit 1;
    if v_price is null then raise exception 'Harga kontrak untuk BW rata-rata % Kg belum tersedia.',round(v_avg_bw,3); end if;
    new.price_per_kg:=v_price;
    new.buyer_id:=null;
  end if;
  new.updated_at:=now();
  return new;
end $$;

create or replace function public.save_mandiri_purchase_atomic(
  p_purchase_id uuid,p_supplier_id uuid,p_item_id uuid,p_purchase_date date,p_quantity numeric,
  p_purchase_unit_price numeric,p_reference_number text,p_notes text,p_allocations jsonb
) returns uuid language plpgsql security definer set search_path='' as $$
declare
  v_id uuid;
  v_sum numeric:=0;
  v jsonb;
  v_assignment uuid;
  v_qty numeric;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  if coalesce(p_quantity,0)<=0 then raise exception 'Jumlah pembelian harus lebih dari 0.'; end if;
  if p_purchase_unit_price is null or p_purchase_unit_price<0 then raise exception 'Harga beli tidak valid.'; end if;
  if p_purchase_date is null then raise exception 'Tanggal pembelian wajib diisi.'; end if;
  if not exists(select 1 from public.suppliers s where s.id=p_supplier_id and s.active and s.supplier_type='SAPRONAK') then raise exception 'Supplier Sapronak tidak valid.'; end if;
  if not exists(select 1 from public.items i where i.id=p_item_id and i.active and i.supplier_id=p_supplier_id) then raise exception 'Barang tidak sesuai Supplier.'; end if;
  if p_purchase_id is not null and exists(
    select 1 from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=p_purchase_id and not ca.active
  ) then raise exception 'Pembelian sudah terkait siklus CLOSED dan tidak dapat diedit.'; end if;
  if p_allocations is null or jsonb_typeof(p_allocations)<>'array' then raise exception 'Distribusi kandang tidak valid.'; end if;

  for v in select value from jsonb_array_elements(p_allocations)
  loop
    v_assignment:=(v->>'assignment_id')::uuid;
    v_qty:=coalesce((v->>'quantity')::numeric,0);
    if v_qty<=0 then raise exception 'Jumlah distribusi harus lebih dari 0.'; end if;
    if not exists(select 1 from public.logistics_contract_assignments a where a.id=v_assignment and a.active and a.cycle_type='MANDIRI') then raise exception 'Distribusi hanya boleh ke siklus Mandiri aktif.'; end if;
    v_sum:=v_sum+v_qty;
  end loop;
  if v_sum>p_quantity then raise exception 'Total distribusi (%) melebihi jumlah pembelian (%).',v_sum,p_quantity; end if;

  if p_purchase_id is null then
    insert into public.logistics_mandiri_purchases(supplier_id,item_id,purchase_date,quantity,purchase_unit_price,reference_number,notes,created_by)
    values(p_supplier_id,p_item_id,p_purchase_date,p_quantity,p_purchase_unit_price,p_reference_number,p_notes,auth.uid())
    returning id into v_id;
  else
    update public.logistics_mandiri_purchases
    set supplier_id=p_supplier_id,item_id=p_item_id,purchase_date=p_purchase_date,quantity=p_quantity,
        purchase_unit_price=p_purchase_unit_price,reference_number=p_reference_number,notes=p_notes,updated_at=now()
    where id=p_purchase_id returning id into v_id;
    if v_id is null then raise exception 'Pembelian Mandiri tidak ditemukan.'; end if;
    delete from public.logistics_mandiri_purchase_allocations where purchase_id=v_id;
  end if;

  for v in select value from jsonb_array_elements(p_allocations)
  loop
    insert into public.logistics_mandiri_purchase_allocations(purchase_id,contract_assignment_id,quantity)
    values(v_id,(v->>'assignment_id')::uuid,(v->>'quantity')::numeric);
  end loop;
  return v_id;
end $$;

create or replace function public.delete_mandiri_purchase_atomic(p_purchase_id uuid)
returns void language plpgsql security definer set search_path='' as $$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','LOGISTIK')) then raise exception 'Akses ditolak.'; end if;
  if exists(
    select 1 from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=p_purchase_id and not ca.active
  ) then raise exception 'Pembelian sudah terkait siklus CLOSED dan tidak dapat dihapus.'; end if;
  delete from public.logistics_mandiri_purchases where id=p_purchase_id;
end $$;

create or replace function public.admin_close_mandiri_cycle_atomic(p_contract_assignment_id uuid)
returns uuid language plpgsql security definer set search_path='' as $$
declare v public.logistics_contract_assignments%rowtype;
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role='ADMIN') then raise exception 'Akses ditolak. Hanya Administrator yang dapat Close Produksi.'; end if;
  select * into v from public.logistics_contract_assignments where id=p_contract_assignment_id for update;
  if v.id is null then raise exception 'Siklus tidak ditemukan.'; end if;
  if not v.active then raise exception 'Siklus sudah Close.'; end if;
  if v.cycle_type<>'MANDIRI' then raise exception 'Siklus ini bukan Mandiri.'; end if;
  if not exists(select 1 from public.chick_ins c where c.contract_assignment_id=v.id and c.received>0) then raise exception 'Chick-In Mandiri belum diinput.'; end if;
  if not exists(select 1 from public.marketing_contract_harvests h where h.contract_assignment_id=v.id) then raise exception 'Panen Mandiri belum diinput.'; end if;
  perform set_config('bms.allow_production_close','1',true);
  update public.logistics_contract_assignments set active=false where id=v.id;
  return v.id;
end $$;

revoke all on function public.save_mandiri_purchase_atomic(uuid,uuid,uuid,date,numeric,numeric,text,text,jsonb) from public,anon;
grant execute on function public.save_mandiri_purchase_atomic(uuid,uuid,uuid,date,numeric,numeric,text,text,jsonb) to authenticated;
revoke all on function public.delete_mandiri_purchase_atomic(uuid) from public,anon;
grant execute on function public.delete_mandiri_purchase_atomic(uuid) to authenticated;
revoke all on function public.admin_close_mandiri_cycle_atomic(uuid) from public,anon;
grant execute on function public.admin_close_mandiri_cycle_atomic(uuid) to authenticated;

create or replace function public.finance_cycle_profit_loss_v2()
returns table(contract_assignment_id uuid,barn_id uuid,barn_code text,barn_name text,start_date date,active boolean,rhpp_system numeric,rhpp_real numeric,bop_produksi numeric,gaji_abk numeric,sapronak_luar numeric,tambah_daging numeric,kasbon_abk numeric,saldo_kasbon numeric,perawatan_jangka_panjang numeric,laba_operasional_produksi numeric,laba_bersih_akhir numeric)
language plpgsql security definer set search_path='' as $$
begin
  if not exists(select 1 from public.profiles p where p.user_id=auth.uid() and p.active and p.role in ('ADMIN','KEUANGAN','OWNER')) then raise exception 'Akses ditolak.'; end if;
  return query
  with bopx as (
    select b.contract_assignment_id,coalesce(sum(b.amount),0)::numeric bop,
      coalesce(sum(case when b.source_type='ABK_SALARY' then b.amount else 0 end),0)::numeric salary
    from public.bop b group by b.contract_assignment_id
  ), maint as (
    select m.contract_assignment_id,coalesce(sum(m.amount),0)::numeric amount from public.barn_maintenance_costs m group by m.contract_assignment_id
  ), ext_ship as (
    select h.contract_assignment_id,coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric amount
    from public.logistics_external_shipments h join public.logistics_external_shipment_items i on i.external_shipment_id=h.id group by h.contract_assignment_id
  ), ext_out as (
    select t.source_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.source_contract_assignment_id
  ), ext_in as (
    select t.target_contract_assignment_id contract_assignment_id,coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t group by t.target_contract_assignment_id
  ), mandiri_buy as (
    select a.contract_assignment_id,coalesce(sum(a.quantity*p.purchase_unit_price),0)::numeric amount
    from public.logistics_mandiri_purchase_allocations a join public.logistics_mandiri_purchases p on p.id=a.purchase_id group by a.contract_assignment_id
  ), mandiri_sales as (
    select h.contract_assignment_id,coalesce(sum(h.total_amount),0)::numeric amount
    from public.marketing_contract_harvests h group by h.contract_assignment_id
  ), meat as (
    select m.contract_assignment_id,coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric amount
    from public.marketing_external_meat_purchases m group by m.contract_assignment_id
  ), adv as (
    select a.contract_assignment_id,coalesce(sum(a.amount),0)::numeric amount,
      coalesce(sum(a.amount-coalesce(p.paid,0)),0)::numeric balance
    from public.advances a
    left join (select advance_id,sum(amount) paid from public.advance_payments group by advance_id) p on p.advance_id=a.id
    where a.contract_assignment_id is not null group by a.contract_assignment_id
  ), base as (
    select a.id contract_assignment_id,a.barn_id,b.code,b.name,a.start_date,a.active,a.cycle_type,
      case when a.cycle_type='MANDIRI' then 0 else coalesce(sf.system_amount,0) end::numeric rhpp_system,
      case when a.cycle_type='MANDIRI' then coalesce(ms.amount,0) else coalesce(rr.amount,0) end::numeric rhpp_real,
      coalesce(bx.bop,0)::numeric bop_produksi,coalesce(bx.salary,0)::numeric gaji_abk,
      case when a.cycle_type='MANDIRI' then coalesce(mb.amount,0)
           else greatest(0,coalesce(es.amount,0)-coalesce(eo.amount,0)+coalesce(ei.amount,0)) end::numeric sapronak_luar,
      coalesce(mt.amount,0)::numeric tambah_daging,coalesce(ad.amount,0)::numeric kasbon_abk,
      coalesce(ad.balance,0)::numeric saldo_kasbon,coalesce(mc.amount,0)::numeric perawatan_jangka_panjang
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    left join public.rhpp_system_final sf on sf.contract_assignment_id=a.id
    left join public.rhpp_real rr on rr.contract_assignment_id=a.id
    left join bopx bx on bx.contract_assignment_id=a.id
    left join maint mc on mc.contract_assignment_id=a.id
    left join ext_ship es on es.contract_assignment_id=a.id
    left join ext_out eo on eo.contract_assignment_id=a.id
    left join ext_in ei on ei.contract_assignment_id=a.id
    left join mandiri_buy mb on mb.contract_assignment_id=a.id
    left join mandiri_sales ms on ms.contract_assignment_id=a.id
    left join meat mt on mt.contract_assignment_id=a.id
    left join adv ad on ad.contract_assignment_id=a.id
  )
  select x.contract_assignment_id,x.barn_id,x.code,x.name,x.start_date,x.active,x.rhpp_system,x.rhpp_real,
    x.bop_produksi,x.gaji_abk,x.sapronak_luar,x.tambah_daging,x.kasbon_abk,x.saldo_kasbon,x.perawatan_jangka_panjang,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging)::numeric,
    (x.rhpp_real-x.bop_produksi-x.sapronak_luar-x.tambah_daging-x.perawatan_jangka_panjang)::numeric
  from base x order by x.start_date desc,x.code;
end $$;
