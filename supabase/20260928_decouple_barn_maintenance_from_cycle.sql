-- Perawatan Kandang berjalan berdasarkan kandang fisik, bukan siklus produksi.
alter table public.barn_maintenance_costs
  alter column contract_assignment_id drop not null;

comment on column public.barn_maintenance_costs.contract_assignment_id is
  'Legacy/optional only. Perawatan kandang berjalan berdasarkan kandang dan tanggal, tidak wajib terkait siklus.';
