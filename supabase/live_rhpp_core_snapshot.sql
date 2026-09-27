-- BMS Mitra Online
-- LIVE RHPP CORE SNAPSHOT
-- Source: Supabase project mqqrfhwqgcpkjeaasdsr
-- Synced: 2026-09-27
-- Purpose: exact live definitions used by main-1958.js for RHPP calculation and operational flow.
-- IMPORTANT: This file mirrors production definitions for audit/recovery. Do not edit formulas here without a reviewed database migration.

-- ============================================================================
-- finance_rhpp_summary_v3()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.finance_rhpp_summary_v3()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, main_feed_kg numeric, external_feed_kg numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, main_doc_cost numeric, main_feed_cost numeric, main_ovk_cost numeric, main_other_cost numeric, main_return_cost numeric, external_sapronak_cost numeric, sapronak_cost numeric, external_meat_cost numeric, total_rhpp_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality_rate numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, population_balanced boolean, ready_financial boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with harvest as (
    select h.contract_assignment_id,
           sum(h.birds)::numeric birds,
           sum(h.net_weight_kg)::numeric kg,
           sum(h.total_amount)::numeric value,
           sum(h.birds*((h.harvested_on-ci.arrived_on)+1))::numeric/nullif(sum(h.birds),0) weighted_age
    from public.marketing_contract_harvests h
    join public.chick_ins ci on ci.contract_assignment_id=h.contract_assignment_id
    group by h.contract_assignment_id
  ),
  main_ship as (
    select s.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then si.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(case when i.category='DOC' then si.quantity*si.unit_price else 0 end),0)::numeric doc_cost,
           coalesce(sum(case when i.category='PAKAN' then si.quantity*si.unit_price else 0 end),0)::numeric feed_cost,
           coalesce(sum(case when i.category='OVK' then si.quantity*si.unit_price else 0 end),0)::numeric ovk_cost,
           coalesce(sum(case when i.category not in ('DOC','PAKAN','OVK') then si.quantity*si.unit_price else 0 end),0)::numeric other_cost,
           coalesce(sum(si.quantity*si.unit_price),0)::numeric total_cost
    from public.logistics_shipments s
    join public.logistics_shipment_items si on si.shipment_id=s.id
    join public.items i on i.id=si.item_id
    group by s.contract_assignment_id
  ),
  main_ret as (
    select r.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then ri.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(ri.quantity*ri.unit_price),0)::numeric total_cost
    from public.logistics_returns r
    join public.logistics_return_items ri on ri.return_id=r.id
    join public.items i on i.id=ri.item_id
    group by r.contract_assignment_id
  ),
  ext_ship as (
    select e.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then ei.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(ei.quantity*ei.purchase_unit_price),0)::numeric total_cost
    from public.logistics_external_shipments e
    join public.logistics_external_shipment_items ei on ei.external_shipment_id=e.id
    join public.items i on i.id=ei.item_id
    group by e.contract_assignment_id
  ),
  ext_ret as (
    select er.contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then eri.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(eri.quantity*eri.purchase_unit_price),0)::numeric total_cost
    from public.logistics_external_returns er
    join public.logistics_external_return_items eri on eri.external_return_id=er.id
    join public.items i on i.id=eri.item_id
    group by er.contract_assignment_id
  ),
  transfer_in as (
    select t.target_contract_assignment_id contract_assignment_id,
           coalesce(sum(case when i.category='PAKAN' then t.quantity_kg else 0 end),0)::numeric feed_kg,
           coalesce(sum(t.quantity*t.unit_price),0)::numeric total_cost
    from public.logistics_external_return_transfers t
    join public.items i on i.id=t.item_id
    group by t.target_contract_assignment_id
  ),
  meat as (
    select m.contract_assignment_id,
           coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric total_cost
    from public.marketing_external_meat_purchases m
    group by m.contract_assignment_id
  ),
  rec_dep as (
    select r.contract_assignment_id,coalesce(sum(r.mortality+r.culling),0)::numeric birds
    from public.recordings r group by r.contract_assignment_id
  ),
  raw as (
    select
      a.id assignment_id,a.barn_id,b.code barn_code,b.name barn_name,c.number contract_number,a.active,
      (ci.received-ci.doa)::numeric chick_in_birds,
      coalesce(h.birds,0)::numeric total_harvest_birds,
      coalesce(h.kg,0)::numeric total_harvest_kg,
      case when coalesce(h.birds,0)>0 then h.kg/h.birds else 0 end::numeric avg_bw_kg,
      coalesce(h.weighted_age,0)::numeric weighted_age,
      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric implied_depletion_birds,
      coalesce(rd.birds,0)::numeric recorded_depletion_birds,
      (((ci.received-ci.doa)-coalesce(h.birds,0))-coalesce(rd.birds,0))::numeric depletion_variance_birds,
      case when (ci.received-ci.doa)>0 then (coalesce(rd.birds,0)/(ci.received-ci.doa))*100 else 0 end::numeric mortality_pct,
      greatest(0,coalesce(ms.feed_kg,0)-coalesce(mr.feed_kg,0))::numeric main_feed_kg,
      greatest(0,coalesce(es.feed_kg,0)-coalesce(er.feed_kg,0)+coalesce(ti.feed_kg,0))::numeric external_feed_kg,
      greatest(0,coalesce(ms.feed_kg,0)-coalesce(mr.feed_kg,0)+coalesce(es.feed_kg,0)-coalesce(er.feed_kg,0)+coalesce(ti.feed_kg,0))::numeric net_feed_kg,
      coalesce(h.value,0)::numeric harvest_value,
      greatest(0,coalesce(ms.doc_cost,0))::numeric main_doc_cost,
      greatest(0,coalesce(ms.feed_cost,0))::numeric main_feed_cost,
      greatest(0,coalesce(ms.ovk_cost,0))::numeric main_ovk_cost,
      greatest(0,coalesce(ms.other_cost,0))::numeric main_other_cost,
      greatest(0,coalesce(mr.total_cost,0))::numeric main_return_cost,
      greatest(0,coalesce(es.total_cost,0)-coalesce(er.total_cost,0)+coalesce(ti.total_cost,0))::numeric external_sapronak_cost,
      greatest(0,coalesce(ms.total_cost,0)-coalesce(mr.total_cost,0)+coalesce(es.total_cost,0)-coalesce(er.total_cost,0)+coalesce(ti.total_cost,0))::numeric sapronak_cost,
      greatest(0,coalesce(me.total_cost,0))::numeric external_meat_cost,
      a.master_contract_id,a.performance_template_name
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    join public.contracts c on c.id=a.master_contract_id
    join public.chick_ins ci on ci.contract_assignment_id=a.id
    left join harvest h on h.contract_assignment_id=a.id
    left join main_ship ms on ms.contract_assignment_id=a.id
    left join main_ret mr on mr.contract_assignment_id=a.id
    left join ext_ship es on es.contract_assignment_id=a.id
    left join ext_ret er on er.contract_assignment_id=a.id
    left join transfer_in ti on ti.contract_assignment_id=a.id
    left join meat me on me.contract_assignment_id=a.id
    left join rec_dep rd on rd.contract_assignment_id=a.id
  ),
  metrics as (
    select r.*,
      case when r.total_harvest_kg>0 then r.net_feed_kg/r.total_harvest_kg else 0 end::numeric fcr_actual,
      lo.age_days lo_age,lo.std_fcr lo_fcr,hi.age_days hi_age,hi.std_fcr hi_fcr
    from raw r
    left join lateral (
      select ps.age_days,ps.std_fcr from public.performance_standards ps
      where ps.contract_id=r.master_contract_id and ps.template_name=r.performance_template_name and ps.age_days<=r.weighted_age
      order by ps.age_days desc limit 1
    ) lo on true
    left join lateral (
      select ps.age_days,ps.std_fcr from public.performance_standards ps
      where ps.contract_id=r.master_contract_id and ps.template_name=r.performance_template_name and ps.age_days>=r.weighted_age
      order by ps.age_days asc limit 1
    ) hi on true
  ),
  scored as (
    select m.*,
      case
        when m.lo_fcr is null then m.hi_fcr when m.hi_fcr is null then m.lo_fcr
        when m.hi_age=m.lo_age then m.lo_fcr
        else m.lo_fcr+((m.weighted_age-m.lo_age)/(m.hi_age-m.lo_age))*(m.hi_fcr-m.lo_fcr)
      end::numeric fcr_standard,
      case when m.weighted_age>0 and m.fcr_actual>0 then ((100-m.mortality_pct)*m.avg_bw_kg*100)/(m.weighted_age*m.fcr_actual) else 0 end::numeric ip
    from metrics m
  ),
  bonus_rates as (
    select s.*,
      coalesce(ipb.rupiah_per_kg,0)::numeric bonus_ip_rate,
      coalesce(fcb.rupiah_per_kg,0)::numeric bonus_fc_rate,
      coalesce(db.rupiah_per_kg,0)::numeric bonus_mortality_rate
    from scored s
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='IP'
        and (cb.min_value is null or s.ip>=cb.min_value)
        and (cb.max_value is null or s.ip<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) ipb on true
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='FCR_DIFFERENCE'
        and (cb.min_value is null or (coalesce(s.fcr_standard,0)-s.fcr_actual)>=cb.min_value)
        and (cb.max_value is null or (coalesce(s.fcr_standard,0)-s.fcr_actual)<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) fcb on true
    left join lateral (
      select cb.rupiah_per_kg from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id and cb.metric='DEPLETION'
        and (cb.min_value is null or s.mortality_pct>=cb.min_value)
        and (cb.max_value is null or s.mortality_pct<cb.max_value)
      order by cb.min_value desc nulls last limit 1
    ) db on true
  )
  select
    br.assignment_id,br.barn_id,br.barn_code,br.barn_name,br.contract_number,br.active,
    br.chick_in_birds,br.total_harvest_birds,br.total_harvest_kg,br.avg_bw_kg,br.weighted_age,
    br.implied_depletion_birds,br.recorded_depletion_birds,br.depletion_variance_birds,br.mortality_pct,
    br.main_feed_kg,br.external_feed_kg,br.net_feed_kg,
    br.fcr_actual,br.fcr_standard,(coalesce(br.fcr_standard,0)-br.fcr_actual)::numeric diff_fcr,br.ip,
    br.harvest_value,br.main_doc_cost,br.main_feed_cost,br.main_ovk_cost,br.main_other_cost,br.main_return_cost,
    br.external_sapronak_cost,br.sapronak_cost,br.external_meat_cost,
    (br.sapronak_cost+br.external_meat_cost)::numeric total_rhpp_cost,
    (br.harvest_value-br.sapronak_cost-br.external_meat_cost)::numeric base_profit,
    br.bonus_ip_rate,(br.total_harvest_kg*br.bonus_ip_rate)::numeric bonus_ip,
    br.bonus_fc_rate,(br.total_harvest_kg*br.bonus_fc_rate)::numeric bonus_fc,
    br.bonus_mortality_rate,(br.total_harvest_kg*br.bonus_mortality_rate)::numeric bonus_mortality,
    (br.harvest_value-br.sapronak_cost-br.external_meat_cost
      +br.total_harvest_kg*br.bonus_ip_rate
      +br.total_harvest_kg*br.bonus_fc_rate
      +br.total_harvest_kg*br.bonus_mortality_rate)::numeric farmer_profit,
    case when br.chick_in_birds>0 then
      (br.harvest_value-br.sapronak_cost-br.external_meat_cost
       +br.total_harvest_kg*br.bonus_ip_rate
       +br.total_harvest_kg*br.bonus_fc_rate
       +br.total_harvest_kg*br.bonus_mortality_rate)/br.chick_in_birds else 0 end::numeric profit_per_chick_in,
    case when br.total_harvest_birds>0 then
      (br.harvest_value-br.sapronak_cost-br.external_meat_cost
       +br.total_harvest_kg*br.bonus_ip_rate
       +br.total_harvest_kg*br.bonus_fc_rate
       +br.total_harvest_kg*br.bonus_mortality_rate)/br.total_harvest_birds else 0 end::numeric profit_per_harvested_bird,
    (abs(br.depletion_variance_birds)<0.5)::boolean population_balanced,
    (not br.active and abs(br.depletion_variance_birds)<0.5 and br.chick_in_birds>0 and br.total_harvest_birds>0 and br.total_harvest_kg>0 and br.net_feed_kg>0 and br.sapronak_cost>0)::boolean ready_financial
  from bonus_rates br
  order by br.active desc,br.barn_code;
end
$function$;

-- ============================================================================
-- finance_rhpp_summary_v4()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.finance_rhpp_summary_v4()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, main_feed_kg numeric, external_feed_kg numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, main_doc_cost numeric, main_feed_cost numeric, main_ovk_cost numeric, main_other_cost numeric, main_return_cost numeric, external_sapronak_cost numeric, sapronak_cost numeric, external_meat_cost numeric, total_rhpp_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality_rate numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, population_balanced boolean, ready_financial boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select
    x.contract_assignment_id,x.barn_id,x.barn_code,x.barn_name,x.contract_number,x.active,
    x.chick_in_birds,x.total_harvest_birds,x.total_harvest_kg,x.avg_bw_kg,x.weighted_age,
    x.implied_depletion_birds,x.recorded_depletion_birds,x.depletion_variance_birds,x.mortality_pct,
    x.main_feed_kg,x.external_feed_kg,x.net_feed_kg,x.fcr_actual,x.fcr_standard,x.diff_fcr,x.ip,
    x.harvest_value,x.main_doc_cost,x.main_feed_cost,x.main_ovk_cost,x.main_other_cost,
    x.main_return_cost,x.external_sapronak_cost,x.sapronak_cost,x.external_meat_cost,
    x.total_rhpp_cost,x.base_profit,x.bonus_ip_rate,x.bonus_ip,x.bonus_fc_rate,x.bonus_fc,
    x.bonus_mortality_rate,x.bonus_mortality,x.farmer_profit,x.profit_per_chick_in,
    x.profit_per_harvested_bird,x.population_balanced,
    (
      not x.active
      and x.chick_in_birds>0
      and x.total_harvest_birds>0
      and x.total_harvest_kg>0
      and x.net_feed_kg>0
      and x.sapronak_cost>0
    )::boolean
  from public.finance_rhpp_summary_v3() x
  order by x.active desc,x.barn_code;
end
$function$;

-- ============================================================================
-- finance_rhpp_summary_v5()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.finance_rhpp_summary_v5()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, main_feed_kg numeric, external_feed_kg numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, main_doc_cost numeric, main_feed_cost numeric, main_ovk_cost numeric, main_other_cost numeric, main_return_cost numeric, external_sapronak_cost numeric, sapronak_cost numeric, external_meat_cost numeric, total_rhpp_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality_rate numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, population_balanced boolean, ready_financial boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','LOGISTIK','PPL','MARKETING','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with base as (
    select x.*,a.master_contract_id,
      case
        when not x.active and coalesce(x.recorded_depletion_birds,0)=0
             and coalesce(x.implied_depletion_birds,0)>0
          then x.implied_depletion_birds
        else x.recorded_depletion_birds
      end::numeric as effective_depletion_birds
    from public.finance_rhpp_summary_v4() x
    join public.logistics_contract_assignments a on a.id=x.contract_assignment_id
  ),
  scored as (
    select b.*,
      case when b.chick_in_birds>0
        then (b.effective_depletion_birds/b.chick_in_birds)*100
        else 0 end::numeric as effective_mortality_pct,
      case when b.weighted_age>0 and b.fcr_actual>0
        then (
          (100-(case when b.chick_in_birds>0 then (b.effective_depletion_birds/b.chick_in_birds)*100 else 0 end))
          *b.avg_bw_kg*100
        )/(b.weighted_age*b.fcr_actual)
        else 0 end::numeric as effective_ip
    from base b
  ),
  rates as (
    select s.*,
      coalesce(ipb.rupiah_per_kg,0)::numeric as effective_bonus_ip_rate,
      coalesce(db.rupiah_per_kg,0)::numeric as effective_bonus_mortality_rate
    from scored s
    left join lateral (
      select cb.rupiah_per_kg
      from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id
        and cb.metric='IP'
        and (cb.min_value is null or s.effective_ip>=cb.min_value)
        and (cb.max_value is null or s.effective_ip<cb.max_value)
      order by cb.min_value desc nulls last
      limit 1
    ) ipb on true
    left join lateral (
      select cb.rupiah_per_kg
      from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id
        and cb.metric='DEPLETION'
        and (cb.min_value is null or s.effective_mortality_pct>=cb.min_value)
        and (cb.max_value is null or s.effective_mortality_pct<cb.max_value)
      order by cb.min_value desc nulls last
      limit 1
    ) db on true
  )
  select
    r.contract_assignment_id,r.barn_id,r.barn_code,r.barn_name,r.contract_number,r.active,
    r.chick_in_birds,r.total_harvest_birds,r.total_harvest_kg,r.avg_bw_kg,r.weighted_age,
    r.implied_depletion_birds,
    r.effective_depletion_birds::numeric as recorded_depletion_birds,
    (r.implied_depletion_birds-r.effective_depletion_birds)::numeric as depletion_variance_birds,
    r.effective_mortality_pct::numeric as mortality_pct,
    r.main_feed_kg,r.external_feed_kg,r.net_feed_kg,r.fcr_actual,r.fcr_standard,r.diff_fcr,
    r.effective_ip::numeric as ip,
    r.harvest_value,r.main_doc_cost,r.main_feed_cost,r.main_ovk_cost,r.main_other_cost,r.main_return_cost,
    r.external_sapronak_cost,r.sapronak_cost,r.external_meat_cost,r.total_rhpp_cost,r.base_profit,
    r.effective_bonus_ip_rate::numeric as bonus_ip_rate,
    (r.total_harvest_kg*r.effective_bonus_ip_rate)::numeric as bonus_ip,
    r.bonus_fc_rate,
    (r.total_harvest_kg*r.bonus_fc_rate)::numeric as bonus_fc,
    r.effective_bonus_mortality_rate::numeric as bonus_mortality_rate,
    (r.total_harvest_kg*r.effective_bonus_mortality_rate)::numeric as bonus_mortality,
    (
      r.base_profit
      + r.total_harvest_kg*r.effective_bonus_ip_rate
      + r.total_harvest_kg*r.bonus_fc_rate
      + r.total_harvest_kg*r.effective_bonus_mortality_rate
    )::numeric as farmer_profit,
    case when r.chick_in_birds>0 then (
      r.base_profit
      + r.total_harvest_kg*r.effective_bonus_ip_rate
      + r.total_harvest_kg*r.bonus_fc_rate
      + r.total_harvest_kg*r.effective_bonus_mortality_rate
    )/r.chick_in_birds else 0 end::numeric as profit_per_chick_in,
    case when r.total_harvest_birds>0 then (
      r.base_profit
      + r.total_harvest_kg*r.effective_bonus_ip_rate
      + r.total_harvest_kg*r.bonus_fc_rate
      + r.total_harvest_kg*r.effective_bonus_mortality_rate
    )/r.total_harvest_birds else 0 end::numeric as profit_per_harvested_bird,
    (abs(r.implied_depletion_birds-r.effective_depletion_birds)<0.5)::boolean as population_balanced,
    (
      not r.active
      and r.chick_in_birds>0
      and r.total_harvest_birds>0
      and r.total_harvest_kg>0
      and r.net_feed_kg>0
      and r.sapronak_cost>0
    )::boolean as ready_financial
  from rates r
  order by r.active desc,r.barn_code;
end
$function$;

-- ============================================================================
-- admin_close_production_atomic(p_contract_assignment_id uuid)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.admin_close_production_atomic(p_contract_assignment_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v record;
  v_id uuid;
  v_active boolean;
  v_std_bw numeric;
  v_chick_in_date date;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role='ADMIN'
  ) then
    raise exception 'Akses ditolak. Hanya Administrator yang dapat Close Produksi.';
  end if;

  select a.active into v_active
  from public.logistics_contract_assignments a
  where a.id=p_contract_assignment_id
  for update;

  if v_active is null then raise exception 'Kontrak kandang tidak ditemukan.'; end if;
  if not v_active then raise exception 'Periode ini sudah Close.'; end if;

  perform set_config('bms.allow_production_close','1',true);
  update public.logistics_contract_assignments
  set active=false
  where id=p_contract_assignment_id and active=true;

  select * into v
  from public.finance_rhpp_summary_v5()
  where contract_assignment_id=p_contract_assignment_id;

  if v.contract_assignment_id is null then raise exception 'RHPP Sistem tidak ditemukan.'; end if;

  if not (
    v.chick_in_birds > 0
    and v.total_harvest_birds > 0
    and v.total_harvest_kg > 0
    and v.net_feed_kg > 0
    and v.sapronak_cost > 0
  ) then
    raise exception 'RHPP Sistem belum lengkap. Periksa Chick-In, Panen, Pakan, dan biaya Sapronak.';
  end if;

  select ci.arrived_on into v_chick_in_date
  from public.chick_ins ci
  where ci.contract_assignment_id=p_contract_assignment_id
  order by ci.arrived_on
  limit 1;

  select ps.std_body_weight_g/1000.0 into v_std_bw
  from public.logistics_contract_assignments a
  join public.performance_standards ps
    on ps.contract_id=a.master_contract_id
   and ps.template_name=a.performance_template_name
  where a.id=p_contract_assignment_id
    and ps.std_body_weight_g is not null
  order by abs(ps.age_days-v.weighted_age)
  limit 1;

  insert into public.rhpp_system_final(
    contract_assignment_id,barn_id,system_amount,
    harvest_value,sapronak_cost,external_meat_cost,
    bonus_ip,bonus_fc,bonus_depletion,
    fcr_actual,fcr_standard,ip,mortality_pct,population_variance_birds,
    chick_in_date,chick_in_birds,total_harvest_birds,total_harvest_kg,avg_bw_kg,weighted_age,
    depletion_birds,net_feed_kg,std_bw_kg,
    main_doc_cost,main_feed_cost,main_ovk_cost,main_other_cost,main_return_cost,
    external_sapronak_cost,total_rhpp_cost,base_profit,
    bonus_ip_rate,bonus_fc_rate,bonus_depletion_rate,
    profit_per_chick_in,profit_per_harvested_bird
  ) values (
    v.contract_assignment_id,v.barn_id,v.farmer_profit,
    v.harvest_value,v.sapronak_cost,v.external_meat_cost,
    v.bonus_ip,v.bonus_fc,v.bonus_mortality,
    v.fcr_actual,v.fcr_standard,v.ip,v.mortality_pct,v.depletion_variance_birds,
    v_chick_in_date,v.chick_in_birds,v.total_harvest_birds,v.total_harvest_kg,v.avg_bw_kg,v.weighted_age,
    v.recorded_depletion_birds,v.net_feed_kg,v_std_bw,
    v.main_doc_cost,v.main_feed_cost,v.main_ovk_cost,v.main_other_cost,v.main_return_cost,
    v.external_sapronak_cost,v.total_rhpp_cost,v.base_profit,
    v.bonus_ip_rate,v.bonus_fc_rate,v.bonus_mortality_rate,
    v.profit_per_chick_in,v.profit_per_harvested_bird
  )
  returning id into v_id;

  return v_id;
end
$function$;

-- ============================================================================
-- finance_save_rhpp_real_atomic(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text, p_notes text)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.finance_save_rhpp_real_atomic(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  v_barn_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak. Hanya Administrator atau Keuangan yang dapat input RHPP Real.';
  end if;

  if p_amount is null or p_amount < 0 then raise exception 'Nominal RHPP Real tidak valid.'; end if;
  if p_received_on is null then raise exception 'Tanggal diterima wajib diisi.'; end if;

  select s.barn_id into v_barn_id
  from public.rhpp_system_final s
  where s.contract_assignment_id=p_contract_assignment_id;

  if v_barn_id is null then raise exception 'RHPP Sistem belum di-Close Administrator.'; end if;

  if exists (
    select 1 from public.rhpp_real r
    where r.contract_assignment_id=p_contract_assignment_id
  ) then
    raise exception 'RHPP Real untuk periode ini sudah tersimpan.';
  end if;

  insert into public.rhpp_real(
    contract_assignment_id,barn_id,amount,received_on,reference,notes,created_by
  ) values (
    p_contract_assignment_id,v_barn_id,p_amount,p_received_on,
    nullif(trim(p_reference),''),nullif(trim(p_notes),''),auth.uid()
  )
  returning id into v_id;

  return v_id;
end
$function$;

-- ============================================================================
-- production_feed_stock(p_contract_assignment_id uuid)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.production_feed_stock(p_contract_assignment_id uuid)
 RETURNS TABLE(item_id uuid, code text, name text, unit text, kg_per_unit numeric, sent_units numeric, external_units numeric, returned_units numeric, used_units numeric, remaining_units numeric, remaining_kg numeric)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_role public.bms_role;
begin
  select p.role into v_role
  from public.profiles p
  where p.user_id=auth.uid() and p.active;

  if v_role not in ('ADMIN'::public.bms_role,'PPL'::public.bms_role) then
    raise exception 'Akses ditolak.';
  end if;

  if not exists (
    select 1
    from public.logistics_contract_assignments a
    where a.id=p_contract_assignment_id
      and (
        v_role='ADMIN'::public.bms_role
        or (v_role='PPL'::public.bms_role and a.ppl_id=auth.uid())
      )
  ) then
    raise exception 'Kontrak tidak ditemukan atau bukan tugas PPL ini.';
  end if;

  return query
  with feed as (
    select i.id item_id,i.code,i.name,i.unit,coalesce(i.kg_per_unit,0) kg_per_unit
    from public.items i
    where i.active=true and i.category='PAKAN'
  ),
  sent as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_shipments s
    join public.logistics_shipment_items li on li.shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ext as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_external_shipments s
    join public.logistics_external_shipment_items li on li.external_shipment_id=s.id
    where s.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  ret as (
    select li.item_id,coalesce(sum(li.quantity),0) qty
    from public.logistics_returns r
    join public.logistics_return_items li on li.return_id=r.id
    where r.contract_assignment_id=p_contract_assignment_id
    group by li.item_id
  ),
  used as (
    select r.feed_item_id item_id,coalesce(sum(r.feed_quantity_units),0) qty
    from public.recordings r
    where r.contract_assignment_id=p_contract_assignment_id
    group by r.feed_item_id
  )
  select
    f.item_id,f.code,f.name,f.unit,f.kg_per_unit,
    coalesce(s.qty,0),coalesce(e.qty,0),coalesce(rt.qty,0),coalesce(u.qty,0),
    greatest(0,coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(u.qty,0)),
    greatest(0,coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)-coalesce(u.qty,0))*f.kg_per_unit
  from feed f
  left join sent s on s.item_id=f.item_id
  left join ext e on e.item_id=f.item_id
  left join ret rt on rt.item_id=f.item_id
  left join used u on u.item_id=f.item_id
  where coalesce(s.qty,0)+coalesce(e.qty,0)-coalesce(rt.qty,0)>0
  order by f.code;
end
$function$;

-- ============================================================================
-- save_recording_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_recording_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  x jsonb;
begin
  if coalesce(jsonb_array_length(p_weights),0)=0 then
    raise exception 'Minimal satu sampel bobot wajib diisi.';
  end if;

  if p_id is null then
    insert into public.recordings(
      contract_assignment_id,barn_id,recorded_on,age_days,mortality,culling,
      feed_item_id,feed_quantity_units,sample_count,sample_weight_total_kg,
      notes,photo_data
    ) values(
      p_assignment_id,p_barn_id,p_recorded_on,p_age_days,p_mortality,p_culling,
      p_feed_item_id,p_feed_quantity_units,p_sample_count,p_sample_weight_total_kg,
      p_notes,p_photo_data
    ) returning id into v_id;
  else
    v_id:=p_id;
    update public.recordings
       set contract_assignment_id=p_assignment_id,
           barn_id=p_barn_id,
           recorded_on=p_recorded_on,
           age_days=p_age_days,
           mortality=p_mortality,
           culling=p_culling,
           feed_item_id=p_feed_item_id,
           feed_quantity_units=p_feed_quantity_units,
           sample_count=p_sample_count,
           sample_weight_total_kg=p_sample_weight_total_kg,
           notes=p_notes,
           photo_data=p_photo_data
     where id=v_id;
    if not found then raise exception 'Recording tidak ditemukan.'; end if;
    delete from public.recording_weight_samples where recording_id=v_id;
  end if;

  for x in select * from jsonb_array_elements(p_weights)
  loop
    insert into public.recording_weight_samples(recording_id,weight_g)
    values(v_id,(x->>'weight_g')::numeric);
  end loop;
  return v_id;
end $function$;

-- ============================================================================
-- save_logistics_shipment_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_logistics_shipment_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  x jsonb;
begin
  if coalesce(jsonb_array_length(p_items),0)=0 then
    raise exception 'Minimal satu Sapronak wajib diisi.';
  end if;

  if p_id is null then
    insert into public.logistics_shipments(
      barn_id,contract_assignment_id,shipment_date,shipping_note_number,notes
    ) values (
      p_barn_id,p_assignment_id,p_shipment_date,p_shipping_note_number,p_notes
    ) returning id into v_id;
  else
    v_id:=p_id;
    update public.logistics_shipments
       set barn_id=p_barn_id,
           contract_assignment_id=p_assignment_id,
           shipment_date=p_shipment_date,
           shipping_note_number=p_shipping_note_number,
           notes=p_notes
     where id=v_id;
    if not found then raise exception 'Pengiriman tidak ditemukan.'; end if;
    delete from public.logistics_shipment_items where shipment_id=v_id;
  end if;

  for x in select * from jsonb_array_elements(p_items)
  loop
    insert into public.logistics_shipment_items(shipment_id,item_id,quantity,unit_price)
    values(
      v_id,
      (x->>'item_id')::uuid,
      (x->>'quantity')::numeric,
      nullif(x->>'unit_price','')::numeric
    );
  end loop;
  return v_id;
end $function$;

-- ============================================================================
-- save_logistics_return_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_logistics_return_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  x record;
  v_sent numeric;
  v_prev_return numeric;
begin
  if coalesce(jsonb_array_length(p_items),0)=0 then
    raise exception 'Minimal satu Sapronak retur wajib diisi.';
  end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=p_assignment_id and a.barn_id=p_barn_id and a.active=true
  ) then raise exception 'Kontrak aktif kandang tidak sesuai.'; end if;

  for x in
    select (e->>'item_id')::uuid item_id, sum((e->>'quantity')::numeric) quantity
    from jsonb_array_elements(p_items) e
    group by (e->>'item_id')::uuid
  loop
    select coalesce(sum(si.quantity),0)
      into v_sent
    from public.logistics_shipments s
    join public.logistics_shipment_items si on si.shipment_id=s.id
    where s.contract_assignment_id=p_assignment_id and si.item_id=x.item_id;

    select coalesce(sum(ri.quantity),0)
      into v_prev_return
    from public.logistics_returns r
    join public.logistics_return_items ri on ri.return_id=r.id
    where r.contract_assignment_id=p_assignment_id
      and ri.item_id=x.item_id
      and (p_id is null or r.id<>p_id);

    if x.quantity<=0 then raise exception 'Jumlah retur harus lebih dari 0.'; end if;
    if x.quantity > v_sent-v_prev_return then
      raise exception 'Jumlah retur melebihi pengiriman kontrak. Maksimal %.', greatest(0,v_sent-v_prev_return);
    end if;
  end loop;

  if p_id is null then
    insert into public.logistics_returns(barn_id,contract_assignment_id,return_date,reference,notes)
    values(p_barn_id,p_assignment_id,p_return_date,p_reference,p_notes)
    returning id into v_id;
  else
    v_id:=p_id;
    update public.logistics_returns
       set barn_id=p_barn_id,contract_assignment_id=p_assignment_id,return_date=p_return_date,
           reference=p_reference,notes=p_notes
     where id=v_id;
    if not found then raise exception 'Retur tidak ditemukan.'; end if;
    delete from public.logistics_return_items where return_id=v_id;
  end if;

  for x in
    select (e->>'item_id')::uuid item_id, sum((e->>'quantity')::numeric) quantity
    from jsonb_array_elements(p_items) e
    group by (e->>'item_id')::uuid
  loop
    insert into public.logistics_return_items(return_id,item_id,quantity)
    values(v_id,x.item_id,x.quantity);
  end loop;

  return v_id;
end
$function$;

-- ============================================================================
-- save_external_sapronak_atomic(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_external_sapronak_atomic(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_header uuid;
  v_detail uuid;
begin
  if p_header_id is null then
    insert into public.logistics_external_shipments(
      contract_assignment_id,barn_id,supplier_id,shipment_date,reference_number,notes
    ) values(
      p_assignment_id,p_barn_id,p_supplier_id,p_shipment_date,p_reference_number,p_notes
    ) returning id into v_header;

    insert into public.logistics_external_shipment_items(
      external_shipment_id,item_id,quantity,purchase_unit_price
    ) values(v_header,p_item_id,p_quantity,p_purchase_unit_price);
  else
    v_header:=p_header_id;
    update public.logistics_external_shipments
       set contract_assignment_id=p_assignment_id,
           barn_id=p_barn_id,
           supplier_id=p_supplier_id,
           shipment_date=p_shipment_date,
           reference_number=p_reference_number,
           notes=p_notes
     where id=v_header;
    if not found then raise exception 'Tambah Sapronak tidak ditemukan.'; end if;

    if p_detail_id is null then
      select id into v_detail
      from public.logistics_external_shipment_items
      where external_shipment_id=v_header
      order by created_at
      limit 1;
    else
      v_detail:=p_detail_id;
    end if;

    if v_detail is null then
      insert into public.logistics_external_shipment_items(
        external_shipment_id,item_id,quantity,purchase_unit_price
      ) values(v_header,p_item_id,p_quantity,p_purchase_unit_price);
    else
      update public.logistics_external_shipment_items
         set item_id=p_item_id,
             quantity=p_quantity,
             purchase_unit_price=p_purchase_unit_price
       where id=v_detail and external_shipment_id=v_header;
      if not found then raise exception 'Detail Tambah Sapronak tidak ditemukan.'; end if;
    end if;
  end if;
  return v_header;
end $function$;

-- ============================================================================
-- save_external_sapronak_return_atomic(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_external_sapronak_return_atomic(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  v_source record;
  v_returned numeric;
  v_transfer_count bigint;
begin
  if (select private.my_bms_role()) not in ('ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role) then
    raise exception 'Akses hanya untuk Administrator atau Logistik.';
  end if;

  if p_quantity is null or p_quantity<=0 then
    raise exception 'Jumlah retur harus lebih dari 0.';
  end if;

  select
    ei.id as source_item_id,
    ei.external_shipment_id,
    ei.item_id,
    ei.quantity as source_quantity,
    ei.purchase_unit_price,
    es.contract_assignment_id,
    es.barn_id,
    es.supplier_id,
    a.active,
    coalesce(i.kg_per_unit,0) as kg_per_unit
  into v_source
  from public.logistics_external_shipment_items ei
  join public.logistics_external_shipments es on es.id=ei.external_shipment_id
  join public.logistics_contract_assignments a on a.id=es.contract_assignment_id
  join public.items i on i.id=ei.item_id
  where ei.id=p_external_shipment_item_id;

  if v_source.source_item_id is null then raise exception 'Pembelian Tambah Sapronak tidak ditemukan.'; end if;
  if not v_source.active then raise exception 'Kontrak Logistik sudah CLOSED.'; end if;

  if p_id is not null then
    select count(*)
    into v_transfer_count
    from public.logistics_external_return_transfers t
    join public.logistics_external_return_items ri on ri.id=t.external_return_item_id
    where ri.external_return_id=p_id;

    if v_transfer_count>0 then
      raise exception 'Draft yang sudah pernah dikirim tidak dapat diubah.';
    end if;
  end if;

  select coalesce(sum(eri.quantity),0)
  into v_returned
  from public.logistics_external_return_items eri
  join public.logistics_external_returns er on er.id=eri.external_return_id
  where eri.external_shipment_item_id=p_external_shipment_item_id
    and (p_id is null or er.id<>p_id);

  if p_quantity > v_source.source_quantity-v_returned then
    raise exception 'Jumlah retur melebihi sisa pembelian luar. Maksimal %.', greatest(0,v_source.source_quantity-v_returned);
  end if;

  if p_id is null then
    insert into public.logistics_external_returns(
      external_shipment_id,contract_assignment_id,barn_id,supplier_id,return_date,reference,notes,status,sent_at
    ) values (
      v_source.external_shipment_id,v_source.contract_assignment_id,v_source.barn_id,v_source.supplier_id,
      p_return_date,p_reference,p_notes,'DRAFT',null
    ) returning id into v_id;
  else
    v_id:=p_id;
    update public.logistics_external_returns
       set external_shipment_id=v_source.external_shipment_id,
           contract_assignment_id=v_source.contract_assignment_id,
           barn_id=v_source.barn_id,
           supplier_id=v_source.supplier_id,
           return_date=p_return_date,
           reference=p_reference,
           notes=p_notes,
           status='DRAFT',
           sent_at=null,
           updated_at=now()
     where id=v_id and status='DRAFT';
    if not found then raise exception 'Draft retur tidak ditemukan atau sudah diproses.'; end if;
    delete from public.logistics_external_return_items where external_return_id=v_id;
  end if;

  insert into public.logistics_external_return_items(
    external_return_id,external_shipment_item_id,item_id,quantity,quantity_kg,purchase_unit_price
  ) values (
    v_id,p_external_shipment_item_id,v_source.item_id,p_quantity,
    case when v_source.kg_per_unit>0 then p_quantity*v_source.kg_per_unit else null end,
    v_source.purchase_unit_price
  );

  return v_id;
end
$function$;

-- ============================================================================
-- transfer_external_sapronak_return_atomic(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.transfer_external_sapronak_return_atomic(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  v_src record;
  v_target record;
  v_already numeric;
  v_total_sent numeric;
begin
  if (select private.my_bms_role()) not in ('ADMIN'::public.bms_role,'LOGISTIK'::public.bms_role) then
    raise exception 'Akses hanya untuk Administrator atau Logistik.';
  end if;

  if p_quantity is null or p_quantity<=0 then
    raise exception 'Jumlah kirim harus lebih dari 0.';
  end if;

  select
    eri.id as return_item_id,
    eri.external_return_id,
    eri.item_id,
    eri.quantity as returned_quantity,
    eri.purchase_unit_price,
    er.contract_assignment_id as source_assignment_id,
    er.barn_id as source_barn_id,
    er.status,
    coalesce(i.kg_per_unit,0) as kg_per_unit
  into v_src
  from public.logistics_external_return_items eri
  join public.logistics_external_returns er on er.id=eri.external_return_id
  join public.items i on i.id=eri.item_id
  where eri.id=p_external_return_item_id
  for update of er;

  if v_src.return_item_id is null then
    raise exception 'Draft retur tidak ditemukan.';
  end if;
  if v_src.status='SENT' then
    raise exception 'Draft retur sudah terkirim seluruhnya.';
  end if;

  select a.id,a.barn_id,a.active
  into v_target
  from public.logistics_contract_assignments a
  where a.id=p_target_assignment_id;

  if v_target.id is null or not v_target.active then
    raise exception 'Kandang tujuan belum memiliki kontrak aktif.';
  end if;
  if v_target.barn_id=v_src.source_barn_id then
    raise exception 'Kandang tujuan harus berbeda dari kandang asal.';
  end if;

  select coalesce(sum(t.quantity),0)
  into v_already
  from public.logistics_external_return_transfers t
  where t.external_return_item_id=p_external_return_item_id;

  if p_quantity > v_src.returned_quantity-v_already then
    raise exception 'Jumlah kirim melebihi stok draft. Maksimal %.', greatest(0,v_src.returned_quantity-v_already);
  end if;

  insert into public.logistics_external_return_transfers(
    external_return_item_id,source_contract_assignment_id,source_barn_id,
    target_contract_assignment_id,target_barn_id,item_id,quantity,quantity_kg,
    unit_price,transferred_on,notes
  ) values (
    v_src.return_item_id,v_src.source_assignment_id,v_src.source_barn_id,
    v_target.id,v_target.barn_id,v_src.item_id,p_quantity,
    case when v_src.kg_per_unit>0 then p_quantity*v_src.kg_per_unit else null end,
    v_src.purchase_unit_price,coalesce(p_transferred_on,current_date),p_notes
  )
  returning id into v_id;

  v_total_sent:=v_already+p_quantity;
  update public.logistics_external_returns
     set status=case when v_total_sent>=v_src.returned_quantity then 'SENT' else 'PARTIAL' end,
         sent_at=case when v_total_sent>=v_src.returned_quantity then now() else null end,
         updated_at=now()
   where id=v_src.external_return_id;

  return v_id;
end
$function$;

-- API execution grants used by the application.
grant execute on function public.finance_rhpp_summary_v3() to authenticated;
grant execute on function public.finance_rhpp_summary_v4() to authenticated;
grant execute on function public.finance_rhpp_summary_v5() to authenticated;
grant execute on function public.admin_close_production_atomic(p_contract_assignment_id uuid) to authenticated;
grant execute on function public.finance_save_rhpp_real_atomic(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text, p_notes text) to authenticated;
grant execute on function public.production_feed_stock(p_contract_assignment_id uuid) to authenticated;
grant execute on function public.save_recording_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb) to authenticated;
grant execute on function public.save_logistics_shipment_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb) to authenticated;
grant execute on function public.save_logistics_return_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb) to authenticated;
grant execute on function public.save_external_sapronak_atomic(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric) to authenticated;
grant execute on function public.save_external_sapronak_return_atomic(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric) to authenticated;
grant execute on function public.transfer_external_sapronak_return_atomic(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text) to authenticated;
