-- Informational contract projection; RHPP Real remains an entered and verified amount.
create view public.harvest_contract_preview with (security_invoker=true) as
select h.id harvest_id,h.cycle_id,h.harvested_on,h.birds,h.net_weight_kg,
  round(h.net_weight_kg/nullif(h.birds,0),3) avg_weight_kg,
  p.price_per_kg contract_price_per_kg,
  round(h.net_weight_kg*p.price_per_kg,2) contract_gross,
  h.price_per_kg sale_price_per_kg,
  round(h.net_weight_kg*h.price_per_kg,2) sale_gross
from public.harvests h
left join public.contracts k on k.cycle_id=h.cycle_id
left join public.contract_live_prices p on p.contract_id=k.id
  and h.net_weight_kg/nullif(h.birds,0)>=p.min_weight_kg
  and (p.max_weight_kg is null or h.net_weight_kg/nullif(h.birds,0)<p.max_weight_kg);
