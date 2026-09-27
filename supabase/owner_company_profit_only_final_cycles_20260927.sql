CREATE OR REPLACE FUNCTION public.finance_company_profit_loss_v2()
 RETURNS TABLE(kandang_operational_profit numeric, maintenance_long_term numeric, kandang_net_profit numeric, expedition_revenue numeric, expedition_bop numeric, expedition_profit_loss numeric, bop_umum numeric, company_profit_loss numeric)
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
  with k as (
    select
      coalesce(sum(laba_operasional_produksi),0)::numeric operational,
      coalesce(sum(perawatan_jangka_panjang),0)::numeric maintenance,
      coalesce(sum(laba_bersih_akhir),0)::numeric net
    from public.finance_cycle_profit_loss_v2() c
    where not c.active and exists (
      select 1 from public.rhpp_real rr
      where rr.contract_assignment_id=c.contract_assignment_id
    )
  ),
  e as (
    select * from public.finance_expedition_profit_loss_v1()
  ),
  u as (
    select coalesce(sum(amount),0)::numeric amount from public.bop_outside
  )
  select
    k.operational,k.maintenance,k.net,
    e.expedition_revenue,e.expedition_bop,e.expedition_profit_loss,
    u.amount,
    k.net+e.expedition_profit_loss-u.amount
  from k,e,u;
end
$function$
;