-- Close anonymous RPC access to privileged legacy finance routines.
REVOKE EXECUTE ON FUNCTION public.finance_auto_reference_trigger() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_cashflow_entries_v1() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_company_profit_loss_v1() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_cycle_profit_loss_v1() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_expedition_profit_loss_v1() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_expedition_summary_v1() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_next_reference(text,date) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.finance_rhpp_summary_v5() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_save_abk_advance_atomic(uuid,uuid,date,numeric,text,text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_save_abk_salary_atomic(uuid,uuid,numeric,numeric,date,text,text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.finance_save_employee_advance_atomic(uuid,date,numeric,uuid,text,text) FROM PUBLIC, anon;
