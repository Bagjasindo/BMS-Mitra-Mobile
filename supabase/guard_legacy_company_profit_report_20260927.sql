CREATE OR REPLACE FUNCTION public.finance_company_profit_loss_v1()
 RETURNS TABLE(kandang_profit_loss numeric, expedition_revenue numeric, expedition_bop numeric, expedition_profit_loss numeric, bop_umum numeric, company_profit_loss numeric)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
  with k as (
    select coalesce(sum(laba_rugi_real),0)::numeric amount
    from public.finance_cycle_profit_loss_v1()
  ),
  e as (
    select * from public.finance_expedition_profit_loss_v1()
  ),
  u as (
    select coalesce(sum(amount),0)::numeric amount from public.bop_outside
  )
  select
    k.amount,
    e.expedition_revenue,
    e.expedition_bop,
    e.expedition_profit_loss,
    u.amount,
    k.amount+e.expedition_profit_loss-u.amount
  from k,e,u
  where private.my_bms_role() in (
    'ADMIN'::public.bms_role,
    'KEUANGAN'::public.bms_role,
    'OWNER'::public.bms_role
  );
$function$
;