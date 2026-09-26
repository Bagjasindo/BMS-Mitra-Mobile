alter table public.contracts add column ovk_price_basis text not null default 'FIXED'
  check(ovk_price_basis in ('FIXED','DISTRIBUTOR_PLUS_VAT'));
alter table public.contracts add column ovk_vat_percent numeric(6,3)
  check(ovk_vat_percent >= 0 and ovk_vat_percent <= 100);
alter table public.contracts add column signed_reference text;
alter table public.contracts add constraint ovk_basis_valid check (
  ovk_price_basis <> 'DISTRIBUTOR_PLUS_VAT' or ovk_vat_percent is not null
);
