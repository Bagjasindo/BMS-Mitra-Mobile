-- 2026-10-01
-- Enrich Arus Kas printable detail with transaction notes/reference.
-- Keeps existing cashflow categories and accounting behavior unchanged.

CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v1()
 RETURNS TABLE(txn_date date, txn_type text, source text, amount numeric, barn_id uuid, contract_assignment_id uuid, detail text, reference text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  select r.received_on,'MASUK'::text,'RHPP REAL'::text,r.amount,r.barn_id,r.contract_assignment_id,
         ('RHPP Real dari perusahaan inti'||
          case when nullif(trim(coalesce(r.notes,'')),'') is not null then ' · '||trim(r.notes) else '' end)::text,
         coalesce(r.reference,'')
  from public.rhpp_real r

  union all
  select b.incurred_on,'KELUAR','BOP KANDANG',b.amount,b.barn_id,b.contract_assignment_id,
         (replace(b.category,'_',' ')||
          case when nullif(trim(coalesce(b.notes,'')),'') is not null then ' · '||trim(b.notes) else '' end)::text,
         coalesce(b.reference,'')
  from public.bop b
  where coalesce(b.source_type,'')<>'ABK_SALARY' and b.paid_by='COMPANY'

  union all
  select b.incurred_on,'KELUAR','BOP UMUM',b.amount,null::uuid,null::uuid,
         (replace(b.category,'_',' ')||
          case when nullif(trim(coalesce(b.notes,'')),'') is not null then ' · '||trim(b.notes) else '' end)::text,
         coalesce(b.reference,'')
  from public.bop_outside b
  where b.paid_by='COMPANY'

  union all
  select a.advanced_on,'KELUAR','KASBON',a.amount,a.barn_id,a.contract_assignment_id,
         (coalesce(e.code||' · ','')||e.name||
          case when nullif(trim(coalesce(a.description,'')),'') is not null then ' · '||trim(a.description) else '' end)::text,
         coalesce(a.reference,'')
  from public.advances a
  join public.employees e on e.id=a.employee_id
  where not a.is_historical_balance

  union all
  select p.paid_on,'MASUK','CICILAN KASBON',p.amount,a.barn_id,a.contract_assignment_id,
         (coalesce(e.code||' · ','')||e.name||' · '||p.method||
          case when nullif(trim(coalesce(p.notes,'')),'') is not null then ' · '||trim(p.notes) else '' end)::text,
         coalesce(p.reference,'')
  from public.advance_payments p
  join public.advances a on a.id=p.advance_id
  join public.employees e on e.id=a.employee_id
  where p.method<>'POTONG_GAJI'

  union all
  select s.paid_on,'KELUAR','GAJI ABK',s.net_paid,s.barn_id,s.contract_assignment_id,
         (coalesce(e.code||' · ','')||e.name||' · Gaji bersih'||
          case when nullif(trim(coalesce(s.notes,'')),'') is not null then ' · '||trim(s.notes) else '' end)::text,
         coalesce(s.reference,'')
  from public.abk_cycle_salaries s
  join public.employees e on e.id=s.abk_id
  where s.net_paid>0

  union all
  select p.paid_on,'KELUAR',
         case when p.source_type='SAPRONAK_LUAR' then 'SAPRONAK LUAR' else 'TAMBAH DAGING' end::text,
         p.amount,p.barn_id,p.contract_assignment_id,
         (coalesce(s.code||' · ','')||s.name||' · '||p.method||
          case when nullif(trim(coalesce(p.notes,'')),'') is not null then ' · '||trim(p.notes) else '' end)::text,
         coalesce(p.reference,'')
  from public.supplier_payments p
  join public.suppliers s on s.id=p.supplier_id
  where p.source_type in ('SAPRONAK_LUAR','TAMBAH_DAGING')

  union all
  select p.paid_on,'MASUK','PENDAPATAN EXPEDISI',p.amount,null::uuid,null::uuid,
         (i.invoice_number||' · '||i.customer_name||
          case when nullif(trim(coalesce(p.notes,'')),'') is not null then ' · '||trim(p.notes) else '' end)::text,
         coalesce(p.reference,'')
  from public.finance_expedition_payments p
  join public.finance_expedition_invoices i on i.id=p.invoice_id

  union all
  select b.incurred_on,'KELUAR','BOP EXPEDISI',b.amount,null::uuid,null::uuid,
         (replace(b.category,'_',' ')||
          case when nullif(b.vehicle,'') is not null then ' · '||b.vehicle else '' end||
          case when nullif(trim(coalesce(b.notes,'')),'') is not null then ' · '||trim(b.notes) else '' end)::text,
         coalesce(b.reference,'')
  from public.finance_expedition_bop b;
end
$function$
;

CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v2()
 RETURNS TABLE(txn_date date, txn_type text, source text, amount numeric, barn_id uuid, contract_assignment_id uuid, detail text, reference text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  select v.txn_date,v.txn_type,
         case when v.source='BOP KANDANG' then 'BOP PRODUKSI' else v.source end,
         v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v1() v
  where v.source not in ('SAPRONAK LUAR','TAMBAH DAGING')

  union all
  select m.incurred_on,'KELUAR','PERAWATAN KANDANG',
         m.amount,m.barn_id,m.contract_assignment_id,
         (replace(m.category,'_',' ')||
          case when nullif(trim(coalesce(m.notes,'')),'') is not null then ' · '||trim(m.notes) else '' end)::text,
         coalesce(m.reference,'')
  from public.barn_maintenance_costs m
  where m.paid_by='COMPANY'

  union all
  select p.paid_on,'KELUAR','BAYAR HUTANG SUPPLIER',
         p.amount,p.barn_id,p.contract_assignment_id,
         ((case
           when p.source_type='SAPRONAK_LUAR' then 'Sapronak Tambahan'
           when p.source_type='BELI_PERALATAN' then 'Beli Peralatan'
           else 'Tambah Daging'
         end)||
         case when nullif(trim(coalesce(p.notes,'')),'') is not null then ' · '||trim(p.notes) else '' end)::text,
         coalesce(p.reference,'')
  from public.supplier_payments p

  union all
  select r.received_on,'MASUK','PENJUALAN MANDIRI',
         r.amount,h.barn_id,h.contract_assignment_id,
         (coalesce(h.buyer_name,'Pelanggan')||
          case when nullif(h.transaction_number,'') is not null then ' · '||h.transaction_number else '' end||
          case when nullif(trim(coalesce(r.notes,'')),'') is not null then ' · '||trim(r.notes) else '' end)::text,
         coalesce(r.reference,'')
  from public.finance_mandiri_sales_receipts r
  join public.marketing_contract_harvests h on h.id=r.harvest_id
  join public.logistics_contract_assignments a on a.id=h.contract_assignment_id
  where a.cycle_type='MANDIRI'

  union all
  select p.paid_on,'KELUAR','BAYAR SUPPLIER MANDIRI',
         p.amount,
         case when alloc.cnt=1 then alloc.barn_id else null::uuid end,
         case when alloc.cnt=1 then alloc.contract_assignment_id else null::uuid end,
         (coalesce(s.name,'Supplier')||
          case when nullif(mp.reference_number,'') is not null then ' · '||mp.reference_number else '' end||
          case when nullif(trim(coalesce(p.notes,'')),'') is not null then ' · '||trim(p.notes) else '' end)::text,
         coalesce(p.reference,'')
  from public.finance_mandiri_supplier_payments p
  join public.logistics_mandiri_purchases mp on mp.id=p.purchase_id
  join public.suppliers s on s.id=mp.supplier_id
  left join lateral (
    select count(*) cnt,
           max(a.contract_assignment_id::text)::uuid contract_assignment_id,
           max(ca.barn_id::text)::uuid barn_id
    from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=mp.id
  ) alloc on true

  union all
  select b.incurred_on,'KELUAR','GAJI ABK',
         b.amount,b.barn_id,b.contract_assignment_id,
         ('Gaji / upah ABK historis'||
          case when nullif(trim(coalesce(b.notes,'')),'') is not null then ' · '||trim(b.notes) else '' end)::text,
         coalesce(b.reference,'')
  from public.bop b
  where b.source_type='ABK_SALARY'
    and b.source_id is null and b.paid_by='COMPANY'

  union all
  select m.incurred_on,'KELUAR','PERAWATAN EXPEDISI',
         m.amount,null::uuid,null::uuid,
         (replace(m.category,'_',' ')||
          case when nullif(m.vehicle,'') is not null then ' · '||m.vehicle else '' end||
          case when nullif(trim(coalesce(m.notes,'')),'') is not null then ' · '||trim(m.notes) else '' end)::text,
         coalesce(m.reference,'')
  from public.finance_expedition_maintenance m;
end
$function$
;

CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v3()
 RETURNS TABLE(txn_date date, txn_type text, source text, amount numeric, barn_id uuid, contract_assignment_id uuid, detail text, reference text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  select v.txn_date,v.txn_type,v.source,v.amount,v.barn_id,
         v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v2() v

  union all

  select h.purchase_date,'KELUAR'::text,'BELI ASET'::text,
         h.total_amount,h.barn_id,null::uuid,
         (coalesce(h.supplier_name,'Pembelian Aset')||
           case when h.asset_location_type='KANTOR' then ' · Kantor' else ' · Kandang' end||
           case when nullif(trim(coalesce(h.notes,'')),'') is not null then ' · '||trim(h.notes) else '' end)::text,
         coalesce(h.reference,'')
  from public.finance_asset_purchase_invoices h

  union all

  select d.purchase_date,'KELUAR'::text,'BELI ASET'::text,
         d.total_amount,d.barn_id,null::uuid,
         (d.standard_name||' · '||d.quantity::text||' '||d.unit||' · '||d.payment_method||
          case when nullif(trim(coalesce(d.description,'')),'') is not null then ' · '||trim(d.description) else '' end||
          case when nullif(trim(coalesce(d.notes,'')),'') is not null then ' · '||trim(d.notes) else '' end)::text,
         coalesce(d.reference,'')
  from public.finance_direct_purchases d
  where d.purchase_type='ASSET' and d.invoice_id is null;
end
$function$
;

CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v4()
 RETURNS TABLE(txn_date date, txn_type text, source text, amount numeric, barn_id uuid, contract_assignment_id uuid, detail text, reference text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then raise exception 'Akses ditolak.'; end if;

  return query
  select v.txn_date,v.txn_type,v.source,v.amount,v.barn_id,
         v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v3() v

  union all

  select h.purchase_date,'KELUAR'::text,'BELI UNTUK STOK'::text,
         h.total_amount,null::uuid,null::uuid,
         (coalesce(h.supplier_name,'Pembelian Stok Gudang')||
          case when nullif(trim(coalesce(h.notes,'')),'') is not null then ' · '||trim(h.notes) else '' end)::text,
         coalesce(h.reference,'')
  from public.finance_stock_purchase_invoices h;
end
$function$
;
