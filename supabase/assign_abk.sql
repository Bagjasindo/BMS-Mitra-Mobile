alter table public.cycles add column abk_id uuid references public.employees(id);
create view public.ppl_league with (security_invoker=true) as
select c.ppl_id,count(*) cycles,coalesce(sum(c.initial_population),0) population,
  coalesce(sum(p.mortality+p.culling),0) depletion,
  round(avg(p.fcr),3) avg_fcr,coalesce(sum(p.harvested_birds),0) harvested_birds
from public.cycles c join public.cycle_performance p on p.cycle_id=c.id
where c.ppl_id is not null group by c.ppl_id;
create view public.abk_league with (security_invoker=true) as
select c.abk_id,count(*) cycles,coalesce(sum(c.initial_population),0) population,
  coalesce(sum(p.mortality+p.culling),0) depletion,
  round(avg(p.fcr),3) avg_fcr,coalesce(sum(p.harvested_birds),0) harvested_birds
from public.cycles c join public.cycle_performance p on p.cycle_id=c.id
where c.abk_id is not null group by c.abk_id;
