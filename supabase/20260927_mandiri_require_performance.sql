create or replace function public.prepare_logistics_contract_assignment()
returns trigger
language plpgsql
set search_path=''
as $$
begin
  if new.cycle_type='MITRA' then
    if new.master_contract_id is null then raise exception 'Master Kontrak wajib dipilih untuk siklus Mitra'; end if;
    if new.performance_template_name is null or btrim(new.performance_template_name)='' then raise exception 'Template Performa wajib dipilih untuk siklus Mitra'; end if;
    if not exists(select 1 from public.contracts c where c.id=new.master_contract_id and c.cycle_id is null) then raise exception 'Kontrak yang dipilih bukan Master Kontrak'; end if;
    if not exists(select 1 from public.performance_standards p where p.contract_id=new.master_contract_id and p.template_name=new.performance_template_name) then raise exception 'Template Performa tidak tersedia pada kontrak yang dipilih'; end if;
  elsif new.cycle_type='MANDIRI' then
    new.master_contract_id:=null;
    if new.performance_template_name is null or btrim(new.performance_template_name)='' then raise exception 'Template Performa wajib dipilih untuk siklus Mandiri'; end if;
    if not exists(select 1 from public.performance_standards p where p.template_name=new.performance_template_name) then raise exception 'Template Performa Mandiri tidak tersedia'; end if;
  else
    raise exception 'Jenis siklus tidak valid';
  end if;

  update public.logistics_contract_assignments
  set active=false
  where barn_id=new.barn_id and active=true and id is distinct from new.id;

  return new;
end
$$;
