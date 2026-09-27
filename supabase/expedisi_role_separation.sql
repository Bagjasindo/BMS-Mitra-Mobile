-- Expedisi role separation and atomic payment
-- Applied live 2026-09-27

drop policy if exists finance_expedition_payments_write on public.finance_expedition_payments;
create policy finance_expedition_payments_write
on public.finance_expedition_payments
for all
to authenticated
using (private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role]))
with check (private.my_bms_role() = any(array['ADMIN'::bms_role,'KEUANGAN'::bms_role]));

create or replace function public.finance_save_expedition_payment_atomic(
  p_invoice_id uuid,
  p_paid_on date,
  p_amount numeric,
  p_method text default null,
  p_reference text default null,
  p_notes text default null
)
returns uuid
language plpgsql
security definer
set search_path=''
as $$
declare
  v_total numeric;
  v_paid numeric;
  v_balance numeric;
  v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_paid_on is null then raise exception 'Tanggal pembayaran wajib.'; end if;
  if coalesce(p_amount,0)<=0 then raise exception 'Nominal pembayaran harus lebih dari 0.'; end if;

  perform pg_advisory_xact_lock(hashtextextended('EXPEDISI-INVOICE:'||p_invoice_id::text,0));

  select coalesce(sum(t.trip_price+t.additional-t.deduction),0)::numeric
    into v_total
  from public.finance_expedition_invoices i
  left join public.finance_expedition_invoice_items ii on ii.invoice_id=i.id
  left join public.finance_expedition_trips t on t.id=ii.trip_id
  where i.id=p_invoice_id and i.status<>'VOID'
  group by i.id;

  if v_total is null then raise exception 'Invoice tidak ditemukan atau sudah VOID.'; end if;

  select coalesce(sum(p.amount),0)::numeric into v_paid
  from public.finance_expedition_payments p
  where p.invoice_id=p_invoice_id;

  v_balance:=greatest(0,v_total-v_paid);
  if p_amount>v_balance+0.0001 then
    raise exception 'Pembayaran melebihi sisa piutang. Sisa Rp %.',v_balance;
  end if;

  insert into public.finance_expedition_payments(
    invoice_id,paid_on,amount,method,reference,notes,created_by
  ) values(
    p_invoice_id,p_paid_on,p_amount,
    nullif(trim(coalesce(p_method,'')),''),
    nullif(trim(coalesce(p_reference,'')),''),
    nullif(trim(coalesce(p_notes,'')),''),
    auth.uid()
  )
  returning id into v_id;

  if abs((v_paid+p_amount)-v_total)<0.001 then
    update public.finance_expedition_invoices
    set status='PAID'
    where id=p_invoice_id;
  end if;

  return v_id;
end
$$;

revoke execute on function public.finance_save_expedition_payment_atomic(uuid,date,numeric,text,text,text) from public,anon;
grant execute on function public.finance_save_expedition_payment_atomic(uuid,date,numeric,text,text,text) to authenticated;
