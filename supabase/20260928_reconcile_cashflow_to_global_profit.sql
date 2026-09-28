-- 2026-09-28
-- Rekonsiliasi Arus Kas -> Laba/Rugi Global.
-- Sudah diterapkan ke database produksi.
--
-- Perbaikan:
-- 1) Gaji/upah ABK historis pada BOP (source_type=ABK_SALARY, source_id NULL)
--    tetap masuk Arus Kas sebagai kas keluar.
-- 2) Perawatan Expedisi masuk Arus Kas sebagai kas keluar.
-- 3) Tetap mempertahankan penerimaan Mandiri dan pembayaran supplier Mandiri
--    yang sudah disambungkan sebelumnya.
--
-- Catatan akuntansi:
-- Pembayaran hutang memengaruhi Arus Kas, bukan menambah biaya Laba/Rugi lagi.
-- Laba/Rugi memakai nilai transaksi sumber agar tidak terjadi double count.

create or replace function public.finance_cashflow_entries_v2()
returns table(
  txn_date date,
  txn_type text,
  source text,
  amount numeric,
  barn_id uuid,
  contract_assignment_id uuid,
  detail text,
  reference text
)
language plpgsql
security definer
set search_path=''
as $$
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
    and b.source_id is null

  union all
  select m.incurred_on,'KELUAR'::text,'PERAWATAN EXPEDISI'::text,
         m.amount,null::uuid,null::uuid,
         replace(m.category,'_',' ')||
           case when nullif(m.vehicle,'') is not null then ' · '||m.vehicle else '' end,
         ''::text
  from public.finance_expedition_maintenance m;
end
$$;

grant execute on function public.finance_cashflow_entries_v2()
to authenticated;
