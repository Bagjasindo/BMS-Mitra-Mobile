-- Perawatan kandang melekat ke kandang fisik dan tidak wajib terkait siklus produksi.
alter table public.barn_maintenance_costs
  alter column contract_assignment_id drop not null;

comment on column public.barn_maintenance_costs.contract_assignment_id is
  'Legacy/optional link only. Perawatan kandang utama melekat ke kandang fisik dan tidak wajib terkait siklus produksi.';
