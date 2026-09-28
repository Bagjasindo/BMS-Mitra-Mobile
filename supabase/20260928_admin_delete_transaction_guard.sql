-- Global transaction delete guard for BMS web.
-- ADMIN only. Transaction tables are explicitly whitelisted.
create or replace function public.admin_delete_transaction_v1(
  p_table text,
  p_id text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_allowed boolean := false;
  v_deleted integer := 0;
begin
  if auth.uid() is null then
    raise exception 'Sesi login tidak ditemukan.';
  end if;

  if not exists (
    select 1
    from public.profiles p
    where p.user_id = auth.uid()
      and p.active = true
      and p.role = 'ADMIN'
  ) then
    raise exception 'Hanya ADMIN yang boleh menghapus transaksi.';
  end if;

  v_allowed := p_table = any(array[
    'logistics_shipments',
    'logistics_external_shipments',
    'logistics_returns',
    'logistics_external_returns',
    'logistics_mandiri_purchases',
    'marketing_contract_harvests',
    'marketing_external_meat_purchases',
    'chick_ins',
    'recordings',
    'visits',
    'production_estimates',
    'bop',
    'barn_maintenance_costs',
    'bop_outside',
    'finance_expedition_trips',
    'finance_expedition_invoices',
    'finance_expedition_payments',
    'finance_expedition_bop',
    'finance_expedition_maintenance',
    'advances',
    'advance_payments',
    'finance_mandiri_sales_receipts',
    'finance_mandiri_supplier_payments',
    'rhpp_real',
    'abk_cycle_salaries'
  ]);

  if not v_allowed then
    raise exception 'Tabel % tidak diizinkan untuk hapus transaksi.', p_table;
  end if;

  begin
    execute format('delete from public.%I where id::text = $1', p_table)
      using p_id;
    get diagnostics v_deleted = row_count;
  exception
    when foreign_key_violation then
      raise exception 'Transaksi tidak dapat dihapus karena masih dipakai data lain. Koreksi atau hapus transaksi turunannya terlebih dahulu.';
  end;

  if v_deleted = 0 then
    raise exception 'Transaksi tidak ditemukan atau sudah terhapus.';
  end if;

  return true;
end;
$$;

revoke all on function public.admin_delete_transaction_v1(text,text) from public;
revoke all on function public.admin_delete_transaction_v1(text,text) from anon;
grant execute on function public.admin_delete_transaction_v1(text,text) to authenticated;

comment on function public.admin_delete_transaction_v1(text,text)
is 'ADMIN-only guarded delete for transaction rows. Whitelist prevents arbitrary table deletion; FK dependencies block unsafe deletion.';