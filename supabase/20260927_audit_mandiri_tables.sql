drop trigger if exists audit_logistics_mandiri_purchases on public.logistics_mandiri_purchases;
create trigger audit_logistics_mandiri_purchases
after insert or update or delete on public.logistics_mandiri_purchases
for each row execute function public.audit_master_change();

drop trigger if exists audit_logistics_mandiri_purchase_allocations on public.logistics_mandiri_purchase_allocations;
create trigger audit_logistics_mandiri_purchase_allocations
after insert or update or delete on public.logistics_mandiri_purchase_allocations
for each row execute function public.audit_master_change();

drop trigger if exists audit_marketing_customers on public.marketing_customers;
create trigger audit_marketing_customers
after insert or update or delete on public.marketing_customers
for each row execute function public.audit_master_change();
