-- Remove anonymous Data API access and reduce authenticated table privileges.
revoke all privileges on all tables in schema public from anon;

revoke delete, truncate, references, trigger on all tables in schema public from authenticated;
revoke update on all tables in schema public from authenticated;

grant select on all tables in schema public to authenticated;

grant insert on
  public.barns,
  public.cycles,
  public.contracts,
  public.items,
  public.chick_ins,
  public.supplies,
  public.recordings,
  public.visits,
  public.harvests,
  public.rhpp_real,
  public.bop,
  public.company_profile,
  public.employees,
  public.advances,
  public.advance_payments,
  public.expeditions,
  public.rhpp_estimates,
  public.contract_live_prices,
  public.contract_bonuses,
  public.performance_standards
to authenticated;

grant update on public.company_profile to authenticated;
