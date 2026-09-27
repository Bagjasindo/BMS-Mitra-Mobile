-- Trigger executes under its owner, not through direct app-user EXECUTE.
revoke execute on function public.finance_auto_reference_trigger() from authenticated;
