-- Applied migration: advance_historical_balance_cashflow
-- New advances remain cash transactions by default; historical balances are explicit.
ALTER TABLE public.advances ADD COLUMN IF NOT EXISTS is_historical_balance boolean NOT NULL DEFAULT false;
COMMENT ON COLUMN public.advances.is_historical_balance IS 'Saldo piutang lama pada tanggal pencatatan; tidak menghasilkan kas keluar baru. Pembayaran tetap mengurangi saldo.';
DO $patch$ DECLARE v_old text; v_new text; BEGIN
SELECT pg_get_functiondef('public.finance_cashflow_entries_v1()'::regprocedure) INTO v_old;
IF v_old LIKE '%where not a.is_historical_balance%' THEN RETURN; END IF;
v_new:=replace(v_old,E'from public.advances a\n  join public.employees e on e.id=a.employee_id\n\n  union all',E'from public.advances a\n  join public.employees e on e.id=a.employee_id\n  where not a.is_historical_balance\n\n  union all');
IF v_new=v_old THEN RAISE EXCEPTION 'Cashflow pattern not found'; END IF;
EXECUTE v_new;
END $patch$;
-- The 8 confirmed September 28 balances were classified separately after exact count,
-- Rp24,700,000 total and source photograph verification; audit_events retained old/new data.
