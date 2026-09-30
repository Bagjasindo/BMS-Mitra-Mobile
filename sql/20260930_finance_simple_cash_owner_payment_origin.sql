alter table public.bop add column paid_by text not null default 'COMPANY' check (paid_by in ('COMPANY','OWNER'));
alter table public.bop_outside add column paid_by text not null default 'COMPANY' check (paid_by in ('COMPANY','OWNER'));
alter table public.barn_maintenance_costs add column paid_by text not null default 'COMPANY' check (paid_by in ('COMPANY','OWNER'));
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
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select r.received_on,'MASUK'::text,'RHPP REAL'::text,r.amount,r.barn_id,r.contract_assignment_id,
         'RHPP Real dari perusahaan inti'::text,coalesce(r.reference,'')
  from public.rhpp_real r

  union all
  select b.incurred_on,'KELUAR','BOP KANDANG',b.amount,b.barn_id,b.contract_assignment_id,
         replace(b.category,'_',' '),coalesce(b.reference,'')
  from public.bop b
  where coalesce(b.source_type,'')<>'ABK_SALARY' and b.paid_by='COMPANY'

  union all
  select b.incurred_on,'KELUAR','BOP UMUM',b.amount,null::uuid,null::uuid,
         replace(b.category,'_',' '),coalesce(b.reference,'')
  from public.bop_outside b
  where b.paid_by='COMPANY'

  union all
  select a.advanced_on,'KELUAR','KASBON',a.amount,a.barn_id,a.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name,coalesce(a.reference,'')
  from public.advances a
  join public.employees e on e.id=a.employee_id

  union all
  select p.paid_on,'MASUK','CICILAN KASBON',p.amount,a.barn_id,a.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name||' · '||p.method,coalesce(p.reference,'')
  from public.advance_payments p
  join public.advances a on a.id=p.advance_id
  join public.employees e on e.id=a.employee_id
  where p.method<>'POTONG_GAJI'

  union all
  select s.paid_on,'KELUAR','GAJI ABK',s.net_paid,s.barn_id,s.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name||' · Gaji bersih',coalesce(s.reference,'')
  from public.abk_cycle_salaries s
  join public.employees e on e.id=s.abk_id
  where s.net_paid>0

  union all
  select p.paid_on,'KELUAR',
         case when p.source_type='SAPRONAK_LUAR' then 'SAPRONAK LUAR' else 'TAMBAH DAGING' end::text,
         p.amount,p.barn_id,p.contract_assignment_id,
         coalesce(s.code||' · ','')||s.name||' · '||p.method,
         coalesce(p.reference,'')
  from public.supplier_payments p
  join public.suppliers s on s.id=p.supplier_id
  where p.source_type in ('SAPRONAK_LUAR','TAMBAH_DAGING')

  union all
  select p.paid_on,'MASUK','PENDAPATAN EXPEDISI',p.amount,null::uuid,null::uuid,
         i.invoice_number||' · '||i.customer_name,coalesce(p.reference,'')
  from public.finance_expedition_payments p
  join public.finance_expedition_invoices i on i.id=p.invoice_id

  union all
  select b.incurred_on,'KELUAR','BOP EXPEDISI',b.amount,null::uuid,null::uuid,
         replace(b.category,'_',' ')||
         case when nullif(b.vehicle,'') is not null then ' · '||b.vehicle else '' end,
         coalesce(b.reference,'')
  from public.finance_expedition_bop b;
end
$function$

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
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select v.txn_date,v.txn_type,
         case when v.source='BOP KANDANG' then 'BOP PRODUKSI' else v.source end,
         v.amount,v.barn_id,v.contract_assignment_id,v.detail,v.reference
  from public.finance_cashflow_entries_v1() v
  where v.source not in ('SAPRONAK LUAR','TAMBAH DAGING')

  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN KANDANG'::text,
         m.amount,m.barn_id,m.contract_assignment_id,
         replace(m.category,'_',' ')::text,coalesce(m.reference,'')
  from public.barn_maintenance_costs m
  where m.paid_by='COMPANY'

  union all
  select p.paid_on,'KELUAR'::text,'BAYAR HUTANG SUPPLIER'::text,
         p.amount,p.barn_id,p.contract_assignment_id,
         case when p.source_type='SAPRONAK_LUAR' then 'Sapronak Tambahan' else 'Tambah Daging' end,
         coalesce(p.reference,'')
  from public.supplier_payments p

  union all
  select r.received_on,'MASUK'::text,'PENJUALAN MANDIRI'::text,
         r.amount,h.barn_id,h.contract_assignment_id,
         coalesce(h.buyer_name,'Pelanggan')||
           case when nullif(h.transaction_number,'') is not null then ' · '||h.transaction_number else '' end,
         coalesce(r.reference,'')
  from public.finance_mandiri_sales_receipts r
  join public.marketing_contract_harvests h on h.id=r.harvest_id
  join public.logistics_contract_assignments a on a.id=h.contract_assignment_id
  where a.cycle_type='MANDIRI'

  union all
  select p.paid_on,'KELUAR'::text,'BAYAR SUPPLIER MANDIRI'::text,
         p.amount,
         case when alloc.cnt=1 then alloc.barn_id else null::uuid end,
         case when alloc.cnt=1 then alloc.contract_assignment_id else null::uuid end,
         coalesce(s.name,'Supplier')||
           case when nullif(mp.reference_number,'') is not null then ' · '||mp.reference_number else '' end,
         coalesce(p.reference,'')
  from public.finance_mandiri_supplier_payments p
  join public.logistics_mandiri_purchases mp on mp.id=p.purchase_id
  join public.suppliers s on s.id=mp.supplier_id
  left join lateral (
    select count(*) cnt,
           max(a.contract_assignment_id) contract_assignment_id,
           max(ca.barn_id) barn_id
    from public.logistics_mandiri_purchase_allocations a
    join public.logistics_contract_assignments ca on ca.id=a.contract_assignment_id
    where a.purchase_id=mp.id
  ) alloc on true

  union all
  select b.incurred_on,'KELUAR'::text,'GAJI ABK'::text,
         b.amount,b.barn_id,b.contract_assignment_id,
         'Gaji / upah ABK historis'::text,coalesce(b.reference,'')
  from public.bop b
  where b.source_type='ABK_SALARY'
    and b.source_id is null and b.paid_by='COMPANY'

  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN EXPEDISI'::text,
         m.amount,null::uuid,null::uuid,
         replace(m.category,'_',' ')||
           case when nullif(m.vehicle,'') is not null then ' · '||m.vehicle else '' end,
         ''::text
  from public.finance_expedition_maintenance m;
end
$function$
