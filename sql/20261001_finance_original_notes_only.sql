-- 2026-10-01
-- Finance reporting: display only the original transaction note.
-- Raw transaction data is preserved; reporting strips migration/provenance narration.

CREATE OR REPLACE FUNCTION public.finance_original_note_v1(p_note text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO ''
AS $function$
  select nullif(
    btrim(
      regexp_replace(
        coalesce(p_note,''),
        '(?is)\s*(?:[.;]\s*)?(?:Sumber\s+(?:Excel\s+)?Data\s+Lama|Alokasi\s+upah|Ongkos\s+angkut\s+GROUP|GROUP\s+dibagi\s+rata|Nama\s+kandang\s+pada\s+uraian|Tujuan\s+[A-Za-z]|Perawatan\s+kandang\s+tanpa\s+siklus|Tanpa\s+siklus(?:\s+produksi)?|Keterangan\s+asli\s+BMS|sesuai\s+(?:arahan|instruksi|konfirmasi)).*$',
        '',
        'g'
      )
    ),
    ''
  );
$function$
;

CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v5()
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
         public.finance_original_note_v1(r.notes),coalesce(r.reference,'')
  from public.rhpp_real r

  union all
  select b.incurred_on,'KELUAR','BOP PRODUKSI',b.amount,b.barn_id,b.contract_assignment_id,
         public.finance_original_note_v1(b.notes),coalesce(b.reference,'')
  from public.bop b
  where coalesce(b.source_type,'')<>'ABK_SALARY' and b.paid_by='COMPANY'

  union all
  select b.incurred_on,'KELUAR','BOP UMUM',b.amount,null::uuid,null::uuid,
         public.finance_original_note_v1(b.notes),coalesce(b.reference,'')
  from public.bop_outside b
  where b.paid_by='COMPANY'

  union all
  select a.advanced_on,'KELUAR','KASBON',a.amount,a.barn_id,a.contract_assignment_id,
         public.finance_original_note_v1(a.description),coalesce(a.reference,'')
  from public.advances a
  where not a.is_historical_balance

  union all
  select p.paid_on,'MASUK','CICILAN KASBON',p.amount,a.barn_id,a.contract_assignment_id,
         public.finance_original_note_v1(p.notes),coalesce(p.reference,'')
  from public.advance_payments p
  join public.advances a on a.id=p.advance_id
  where p.method<>'POTONG_GAJI'

  union all
  select s.paid_on,'KELUAR','GAJI ABK',s.net_paid,s.barn_id,s.contract_assignment_id,
         public.finance_original_note_v1(s.notes),coalesce(s.reference,'')
  from public.abk_cycle_salaries s
  where s.net_paid>0

  union all
  select p.paid_on,'KELUAR','BAYAR HUTANG SUPPLIER',
         p.amount,p.barn_id,p.contract_assignment_id,
         public.finance_original_note_v1(p.notes),coalesce(p.reference,'')
  from public.supplier_payments p

  union all
  select r.received_on,'MASUK','PENJUALAN MANDIRI',
         r.amount,h.barn_id,h.contract_assignment_id,
         public.finance_original_note_v1(r.notes),coalesce(r.reference,'')
  from public.finance_mandiri_sales_receipts r
  join public.marketing_contract_harvests h on h.id=r.harvest_id
  join public.logistics_contract_assignments a on a.id=h.contract_assignment_id
  where a.cycle_type='MANDIRI'

  union all
  select p.paid_on,'KELUAR','BAYAR SUPPLIER MANDIRI',
         p.amount,
         case when alloc.cnt=1 then alloc.barn_id else null::uuid end,
         case when alloc.cnt=1 then alloc.contract_assignment_id else null::uuid end,
         public.finance_original_note_v1(p.notes),coalesce(p.reference,'')
  from public.finance_mandiri_supplier_payments p
  join public.logistics_mandiri_purchases mp on mp.id=p.purchase_id
  left join lateral (
    select count(*) cnt,
           max(a.contract_assignment_id::text)::uuid contract_assignment_id,
           max(ca.barn_id::text)::uuid barn_id
    from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=mp.id
  ) alloc on true

  union all
  select p.paid_on,'MASUK','PENDAPATAN EXPEDISI',p.amount,null::uuid,null::uuid,
         public.finance_original_note_v1(p.notes),coalesce(p.reference,'')
  from public.finance_expedition_payments p

  union all
  select b.incurred_on,'KELUAR','BOP EXPEDISI',b.amount,null::uuid,null::uuid,
         public.finance_original_note_v1(b.notes),coalesce(b.reference,'')
  from public.finance_expedition_bop b

  union all
  select m.incurred_on,'KELUAR','PERAWATAN KANDANG',
         m.amount,m.barn_id,m.contract_assignment_id,
         public.finance_original_note_v1(m.notes),coalesce(m.reference,'')
  from public.barn_maintenance_costs m
  where m.paid_by='COMPANY'

  union all
  select m.incurred_on,'KELUAR','PERAWATAN EXPEDISI',
         m.amount,null::uuid,null::uuid,
         public.finance_original_note_v1(m.notes),coalesce(m.reference,'')
  from public.finance_expedition_maintenance m

  union all
  select b.incurred_on,'KELUAR','GAJI ABK',
         b.amount,b.barn_id,b.contract_assignment_id,
         public.finance_original_note_v1(b.notes),coalesce(b.reference,'')
  from public.bop b
  where b.source_type='ABK_SALARY'
    and b.source_id is null and b.paid_by='COMPANY'

  union all
  select h.purchase_date,'KELUAR','BELI ASET',
         h.total_amount,h.barn_id,null::uuid,
         public.finance_original_note_v1(h.notes),coalesce(h.reference,'')
  from public.finance_asset_purchase_invoices h

  union all
  select d.purchase_date,'KELUAR','BELI ASET',
         d.total_amount,d.barn_id,null::uuid,
         public.finance_original_note_v1(coalesce(nullif(d.notes,''),d.description)),
         coalesce(d.reference,'')
  from public.finance_direct_purchases d
  where d.purchase_type='ASSET' and d.invoice_id is null

  union all
  select h.purchase_date,'KELUAR','BELI UNTUK STOK',
         h.total_amount,null::uuid,null::uuid,
         public.finance_original_note_v1(h.notes),coalesce(h.reference,'')
  from public.finance_stock_purchase_invoices h;
end
$function$
;
