-- 2026-09-28
-- Koreksi klasifikasi historis berdasarkan pemetaan 5 PDF RHPP Real.
-- Aturan operasional: periode CLOSED yang memiliki PDF RHPP Real = MITRA;
-- dua periode tanpa PDF = MANDIRI.
-- Hasil audit 7 periode CLOSED: 5 MITRA + 2 MANDIRI.
-- Cicurug Chick-In 2026-06-14 tidak memiliki RHPP Real dan sudah memiliki snapshot production_mandiri_final.

do $$
begin
  alter table public.logistics_contract_assignments disable trigger user;

  update public.logistics_contract_assignments
  set cycle_type='MANDIRI',
      performance_template_name='Performa BMS',
      master_contract_id=null
  where id='b7351efc-59ef-4bd5-8f07-bf18b663d520'::uuid
    and not exists (
      select 1
      from public.rhpp_real r
      where r.contract_assignment_id='b7351efc-59ef-4bd5-8f07-bf18b663d520'::uuid
    )
    and exists (
      select 1
      from public.production_mandiri_final mf
      where mf.contract_assignment_id='b7351efc-59ef-4bd5-8f07-bf18b663d520'::uuid
    );

  alter table public.logistics_contract_assignments enable trigger user;
end $$;
