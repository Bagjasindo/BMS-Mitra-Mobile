ALTER TABLE public.bop_outside ADD COLUMN IF NOT EXISTS expense_scope text;
DO $$ BEGIN IF NOT EXISTS(SELECT 1 FROM pg_constraint WHERE conname='bop_outside_expense_scope_check' AND conrelid='public.bop_outside'::regclass) THEN ALTER TABLE public.bop_outside ADD CONSTRAINT bop_outside_expense_scope_check CHECK(expense_scope IN ('KANTOR','LUAR_KANTOR')); END IF; END $$;
COMMENT ON COLUMN public.bop_outside.expense_scope IS 'Jenis BOP Umum: Kantor atau Luar Kantor. Data lama null sampai ditentukan berdasarkan bukti.';
