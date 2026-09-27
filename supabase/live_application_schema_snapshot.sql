-- BMS Mitra Online
-- LIVE APPLICATION DATABASE SCHEMA SNAPSHOT
-- Source: Supabase project mqqrfhwqgcpkjeaasdsr
-- Synced: 2026-09-27
-- Scope: public + private application schema; structure only, no production data.
-- This file is generated from the LIVE PostgreSQL catalog for audit/recovery.

create extension if not exists pgcrypto;
create schema if not exists private;
set search_path = public, private, extensions;

-- ENUM TYPES
do $$ begin
  create type "public"."bms_role" as enum ('ADMIN', 'LOGISTIK', 'PPL', 'MARKETING', 'KEUANGAN', 'OWNER');
exception when duplicate_object then null;
end $$;
do $$ begin
  create type "public"."cycle_state" as enum ('ACTIVE', 'READY_RHPP', 'CLOSED');
exception when duplicate_object then null;
end $$;

-- TABLES (columns first; constraints added afterward)
create table if not exists public."abk_cycle_salaries" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "abk_id" uuid not null,
  "gross_salary" numeric not null,
  "advance_deduction" numeric default 0 not null,
  "net_paid" numeric not null,
  "paid_on" date not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."abk_league_settings" (
  "id" boolean default true not null,
  "season_start" date default CURRENT_DATE not null,
  "reset_count" integer default 0 not null,
  "updated_by" uuid,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists public."advance_payments" (
  "id" uuid default gen_random_uuid() not null,
  "advance_id" uuid not null,
  "paid_on" date not null,
  "amount" numeric(18,2) not null,
  "method" text not null,
  "reference" text,
  "notes" text,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."advances" (
  "id" uuid default gen_random_uuid() not null,
  "employee_id" uuid not null,
  "advanced_on" date not null,
  "amount" numeric(18,2) not null,
  "description" text,
  "reference" text,
  "created_at" timestamp with time zone default now() not null,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."audit_events" (
  "id" bigint generated always as identity not null,
  "actor" uuid default auth.uid(),
  "action" text not null,
  "table_name" text not null,
  "record_id" text,
  "old_data" jsonb,
  "new_data" jsonb,
  "occurred_at" timestamp with time zone default now() not null
);
create table if not exists public."barns" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "name" text not null,
  "capacity" integer not null,
  "kind" text not null,
  "location" text,
  "active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."bop" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "incurred_on" date not null,
  "category" text not null,
  "amount" numeric(18,2) not null,
  "reference" text,
  "notes" text,
  "contract_assignment_id" uuid,
  "barn_id" uuid,
  "source_type" text,
  "source_id" uuid
);
create table if not exists public."bop_outside" (
  "id" uuid default gen_random_uuid() not null,
  "incurred_on" date not null,
  "category" text not null,
  "amount" numeric not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."chick_ins" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "arrived_on" date not null,
  "hatchery" text,
  "strain" text,
  "shipped" integer not null,
  "received" integer not null,
  "doa" integer not null,
  "avg_weight" numeric(10,2),
  "delivery_number" text,
  "notes" text,
  "sample_count" integer,
  "sample_weight_total_g" numeric(12,2),
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."company_profile" (
  "id" boolean default true not null,
  "company_name" text not null,
  "legal_name" text,
  "logo_url" text,
  "address" text,
  "phone" text,
  "email" text,
  "website" text,
  "tax_number" text,
  "business_id" text,
  "signatory_name" text,
  "signatory_title" text,
  "stamp_url" text,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists public."contract_bonuses" (
  "id" uuid default gen_random_uuid() not null,
  "contract_id" uuid not null,
  "metric" text not null,
  "min_value" numeric(12,4),
  "max_value" numeric(12,4),
  "rupiah_per_kg" numeric(18,2) default 0 not null,
  "notes" text
);
create table if not exists public."contract_live_prices" (
  "id" uuid default gen_random_uuid() not null,
  "contract_id" uuid not null,
  "min_weight_kg" numeric(8,3) not null,
  "max_weight_kg" numeric(8,3),
  "price_per_kg" numeric(18,2) not null
);
create table if not exists public."contracts" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "number" text not null,
  "contract_date" date,
  "integrator" text,
  "doc_price" numeric(18,2) default 0 not null,
  "pre_starter_price" numeric(18,2) default 0 not null,
  "starter_price" numeric(18,2) default 0 not null,
  "finisher_price" numeric(18,2) default 0 not null,
  "ovk_price" numeric(18,2) default 0 not null,
  "harvest_price" numeric(18,2) default 0 not null,
  "parameters" jsonb default '{}'::jsonb not null,
  "ovk_price_basis" text default 'FIXED'::text not null,
  "ovk_vat_percent" numeric(6,3),
  "signed_reference" text,
  "source_master_contract_id" uuid,
  "frozen_at" timestamp with time zone,
  "performance_template_name" text default 'Performa Bounty'::text
);
create table if not exists public."cycles" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "barn_id" uuid not null,
  "chick_in_date" date,
  "initial_population" integer,
  "strain" text,
  "ppl_id" uuid,
  "state" cycle_state default 'ACTIVE'::cycle_state not null,
  "bop_complete" boolean default false not null,
  "ready_at" timestamp with time zone,
  "closed_at" timestamp with time zone,
  "created_at" timestamp with time zone default now() not null,
  "abk_id" uuid
);
create table if not exists public."employees" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "name" text not null,
  "kind" text not null,
  "phone" text,
  "job_title" text,
  "joined_on" date,
  "active" boolean default true not null,
  "notes" text
);
create table if not exists public."expeditions" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "departed_on" date not null,
  "destination" text not null,
  "vehicle" text,
  "driver" text,
  "cargo" text,
  "reference" text,
  "notes" text,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."finance_expedition_bop" (
  "id" uuid default gen_random_uuid() not null,
  "incurred_on" date not null,
  "category" text not null,
  "amount" numeric not null,
  "trip_id" uuid,
  "driver" text,
  "vehicle" text,
  "route" text,
  "qty" numeric,
  "unit_price" numeric,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."finance_expedition_invoice_items" (
  "id" uuid default gen_random_uuid() not null,
  "invoice_id" uuid not null,
  "trip_id" uuid not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."finance_expedition_invoices" (
  "id" uuid default gen_random_uuid() not null,
  "invoice_number" text not null,
  "invoice_date" date not null,
  "due_date" date,
  "customer_name" text not null,
  "customer_address" text,
  "status" text default 'DRAFT'::text not null,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."finance_expedition_payments" (
  "id" uuid default gen_random_uuid() not null,
  "invoice_id" uuid not null,
  "paid_on" date not null,
  "amount" numeric not null,
  "method" text,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."finance_expedition_trips" (
  "id" uuid default gen_random_uuid() not null,
  "trip_date" date not null,
  "mts_sj" text,
  "rr" text,
  "driver" text,
  "vehicle" text,
  "zone" text,
  "destination" text not null,
  "cargo" text,
  "total_qty" numeric,
  "trip_price" numeric default 0 not null,
  "additional" numeric default 0 not null,
  "deduction" numeric default 0 not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."finance_reference_counters" (
  "prefix" text not null,
  "ref_date" date not null,
  "last_no" integer default 0 not null
);
create table if not exists public."harvests" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "harvested_on" date not null,
  "transaction_number" text not null,
  "delivery_number" text,
  "birds" integer not null,
  "net_weight_kg" numeric(18,2) not null,
  "price_per_kg" numeric(18,2) not null,
  "buyer" text,
  "vehicle" text,
  "driver" text,
  "notes" text,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."items" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "name" text not null,
  "category" text not null,
  "feed_phase" text,
  "unit" text not null,
  "active" boolean default true not null,
  "kg_per_unit" numeric(10,2),
  "supplier_id" uuid
);
create table if not exists public."logistics_contract_assignment_abks" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "abk_id" uuid not null,
  "created_at" timestamp with time zone default now() not null,
  "initial_birds" integer,
  "feed_pre_bags" numeric,
  "feed_starter_bags" numeric,
  "feed_finisher_bags" numeric,
  "basics_locked_at" timestamp with time zone
);
create table if not exists public."logistics_contract_assignments" (
  "id" uuid default gen_random_uuid() not null,
  "barn_id" uuid not null,
  "master_contract_id" uuid not null,
  "performance_template_name" text not null,
  "active" boolean default true not null,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "start_date" date default CURRENT_DATE not null,
  "abk_id" uuid,
  "ppl_id" uuid
);
create table if not exists public."logistics_external_return_items" (
  "id" uuid default gen_random_uuid() not null,
  "external_return_id" uuid not null,
  "external_shipment_item_id" uuid not null,
  "item_id" uuid not null,
  "quantity" numeric not null,
  "quantity_kg" numeric,
  "purchase_unit_price" numeric not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."logistics_external_return_transfers" (
  "id" uuid default gen_random_uuid() not null,
  "external_return_item_id" uuid not null,
  "source_contract_assignment_id" uuid not null,
  "source_barn_id" uuid not null,
  "target_contract_assignment_id" uuid not null,
  "target_barn_id" uuid not null,
  "item_id" uuid not null,
  "quantity" numeric not null,
  "quantity_kg" numeric,
  "unit_price" numeric not null,
  "transferred_on" date default CURRENT_DATE not null,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."logistics_external_returns" (
  "id" uuid default gen_random_uuid() not null,
  "external_shipment_id" uuid not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "supplier_id" uuid not null,
  "return_date" date default CURRENT_DATE not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "status" text default 'DRAFT'::text not null,
  "sent_at" timestamp with time zone
);
create table if not exists public."logistics_external_shipment_items" (
  "id" uuid default gen_random_uuid() not null,
  "external_shipment_id" uuid not null,
  "item_id" uuid not null,
  "quantity" numeric(14,2) not null,
  "quantity_kg" numeric(14,2),
  "purchase_unit_price" numeric(14,2) not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."logistics_external_shipments" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "supplier_id" uuid not null,
  "shipment_date" date default CURRENT_DATE not null,
  "reference_number" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists public."logistics_return_items" (
  "id" uuid default gen_random_uuid() not null,
  "return_id" uuid not null,
  "item_id" uuid not null,
  "quantity" numeric not null,
  "quantity_kg" numeric,
  "created_at" timestamp with time zone default now() not null,
  "unit_price" numeric(14,2)
);
create table if not exists public."logistics_returns" (
  "id" uuid default gen_random_uuid() not null,
  "barn_id" uuid not null,
  "return_date" date default CURRENT_DATE not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "contract_assignment_id" uuid not null
);
create table if not exists public."logistics_shipment_items" (
  "id" uuid default gen_random_uuid() not null,
  "shipment_id" uuid not null,
  "item_id" uuid not null,
  "quantity" numeric not null,
  "quantity_kg" numeric,
  "created_at" timestamp with time zone default now() not null,
  "unit_price" numeric(14,2)
);
create table if not exists public."logistics_shipments" (
  "id" uuid default gen_random_uuid() not null,
  "barn_id" uuid not null,
  "shipment_date" date default CURRENT_DATE not null,
  "delivery_number" text,
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "shipping_note_number" text,
  "contract_assignment_id" uuid not null
);
create table if not exists public."marketing_contract_harvests" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "harvested_on" date default CURRENT_DATE not null,
  "birds" numeric(14,2) not null,
  "net_weight_kg" numeric(14,2) not null,
  "avg_weight_kg" numeric(14,4) generated always as ((net_weight_kg / NULLIF(birds, (0)::numeric))) stored,
  "price_per_kg" numeric(14,2) not null,
  "total_amount" numeric(16,2) generated always as ((net_weight_kg * COALESCE(price_per_kg, (0)::numeric))) stored,
  "buyer_name" text,
  "transaction_number" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "vehicle_number" text,
  "market_price_per_kg" numeric,
  "market_total_amount" numeric
);
create table if not exists public."marketing_external_meat_purchases" (
  "id" uuid default gen_random_uuid() not null,
  "supplier_id" uuid not null,
  "purchase_date" date default CURRENT_DATE not null,
  "product_name" text default 'Daging/Ayam'::text not null,
  "weight_kg" numeric(14,2) not null,
  "purchase_price_per_kg" numeric(14,2) not null,
  "reference_number" text,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null
);
create table if not exists public."performance_standards" (
  "id" uuid default gen_random_uuid() not null,
  "contract_id" uuid not null,
  "age_days" integer not null,
  "std_body_weight_g" numeric(10,2),
  "std_fcr" numeric(8,2),
  "std_feed_g_per_bird" numeric(10,2),
  "template_name" text default 'Performa Bounty'::text not null
);
create table if not exists public."production_abk_result_sizes" (
  "id" uuid default gen_random_uuid() not null,
  "result_id" uuid not null,
  "birds" integer not null,
  "weight_kg" numeric not null,
  "created_at" timestamp with time zone default now() not null,
  "harvest_date" date not null
);
create table if not exists public."production_abk_results" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "abk_id" uuid not null,
  "harvest_date" date not null,
  "feed_pre_kg" numeric default 0 not null,
  "feed_starter_kg" numeric default 0 not null,
  "feed_finisher_kg" numeric default 0 not null,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null
);
create table if not exists public."production_estimate_sizes" (
  "id" uuid default gen_random_uuid() not null,
  "estimate_id" uuid not null,
  "birds" integer not null,
  "bw_kg" numeric not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."production_estimates" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "estimated_on" date default CURRENT_DATE not null,
  "remaining_birds" integer not null,
  "feed_used_kg" numeric not null,
  "notes" text,
  "created_by" uuid default auth.uid(),
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "estimated_revenue" numeric,
  "estimated_cost" numeric,
  "estimated_profit" numeric,
  "profit_per_chick_in" numeric
);
create table if not exists public."profiles" (
  "user_id" uuid not null,
  "role" bms_role not null,
  "full_name" text not null,
  "active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."recording_weight_samples" (
  "id" uuid default gen_random_uuid() not null,
  "recording_id" uuid not null,
  "weight_g" numeric not null,
  "created_at" timestamp with time zone default now() not null
);
create table if not exists public."recordings" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "recorded_on" date not null,
  "age_days" integer not null,
  "mortality" integer default 0 not null,
  "culling" integer default 0 not null,
  "feed_kg" numeric(18,2) default 0 not null,
  "avg_weight_kg" numeric(12,2),
  "sample_count" integer,
  "temperature" numeric(6,2),
  "humidity" numeric(6,2),
  "notes" text,
  "feed_item_id" uuid,
  "feed_bags_in" numeric(12,2),
  "feed_bags_out" numeric(12,2),
  "feed_bags_balance" numeric(12,2),
  "actual_fcr" numeric(8,2),
  "ip" numeric(10,2),
  "medication_notes" text,
  "sample_weight_total_kg" numeric(12,2),
  "contract_assignment_id" uuid,
  "barn_id" uuid,
  "feed_quantity_units" numeric,
  "photo_data" text
);
create table if not exists public."rhpp_estimates" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "estimated_on" date not null,
  "age_days" integer,
  "performance" jsonb default '{}'::jsonb not null,
  "projected_amount" numeric(18,2),
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."rhpp_real" (
  "cycle_id" uuid,
  "amount" numeric(18,2) not null,
  "received_on" date not null,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."rhpp_system_final" (
  "id" uuid default gen_random_uuid() not null,
  "contract_assignment_id" uuid not null,
  "barn_id" uuid not null,
  "system_amount" numeric not null,
  "harvest_value" numeric default 0 not null,
  "sapronak_cost" numeric default 0 not null,
  "external_meat_cost" numeric default 0 not null,
  "bonus_ip" numeric default 0 not null,
  "bonus_fc" numeric default 0 not null,
  "bonus_depletion" numeric default 0 not null,
  "fcr_actual" numeric,
  "fcr_standard" numeric,
  "ip" numeric,
  "mortality_pct" numeric,
  "population_variance_birds" numeric,
  "closed_on" date default ((now() AT TIME ZONE 'Asia/Jakarta'::text))::date not null,
  "closed_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "chick_in_birds" numeric,
  "total_harvest_birds" numeric,
  "total_harvest_kg" numeric,
  "avg_bw_kg" numeric,
  "weighted_age" numeric,
  "depletion_birds" numeric,
  "net_feed_kg" numeric,
  "main_doc_cost" numeric,
  "main_feed_cost" numeric,
  "main_ovk_cost" numeric,
  "main_other_cost" numeric,
  "main_return_cost" numeric,
  "external_sapronak_cost" numeric,
  "total_rhpp_cost" numeric,
  "base_profit" numeric,
  "bonus_ip_rate" numeric,
  "bonus_fc_rate" numeric,
  "bonus_depletion_rate" numeric,
  "profit_per_chick_in" numeric,
  "profit_per_harvested_bird" numeric,
  "std_bw_kg" numeric,
  "chick_in_date" date
);
create table if not exists public."suppliers" (
  "id" uuid default gen_random_uuid() not null,
  "code" text not null,
  "name" text not null,
  "address" text,
  "phone" text,
  "contact_person" text,
  "bank_name" text,
  "bank_account_number" text,
  "bank_account_name" text,
  "tax_number" text,
  "business_id" text,
  "notes" text,
  "active" boolean default true not null,
  "created_at" timestamp with time zone default now() not null,
  "updated_at" timestamp with time zone default now() not null,
  "supplier_type" text default 'SAPRONAK'::text not null
);
create table if not exists public."supplies" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "item_id" uuid not null,
  "quantity" numeric(18,3) not null,
  "received_on" date not null,
  "delivery_number" text,
  "reference" text,
  "notes" text,
  "created_by" uuid default auth.uid() not null,
  "created_at" timestamp with time zone default now() not null,
  "quantity_kg" numeric(18,2),
  "contract_assignment_id" uuid,
  "barn_id" uuid
);
create table if not exists public."visits" (
  "id" uuid default gen_random_uuid() not null,
  "cycle_id" uuid,
  "visited_on" date not null,
  "findings" text,
  "recommendation" text,
  "follow_up" text,
  "follow_up_status" text,
  "notes" text,
  "contract_assignment_id" uuid,
  "barn_id" uuid
);

-- CONSTRAINTS
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_abk_id_fkey" FOREIGN KEY (abk_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_advance_deduction_check" CHECK (advance_deduction >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_contract_assignment_id_abk_id_key" UNIQUE (contract_assignment_id, abk_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_gross_salary_check" CHECK (gross_salary >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_net_paid_check" CHECK (net_paid >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_cycle_salaries" add constraint "abk_cycle_salaries_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_league_settings" add constraint "abk_league_settings_id_check" CHECK (id = true);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_league_settings" add constraint "abk_league_settings_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."abk_league_settings" add constraint "abk_league_settings_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES auth.users(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advance_payments" add constraint "advance_payments_advance_id_fkey" FOREIGN KEY (advance_id) REFERENCES advances(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advance_payments" add constraint "advance_payments_amount_check" CHECK (amount > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advance_payments" add constraint "advance_payments_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advances" add constraint "advances_amount_check" CHECK (amount > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advances" add constraint "advances_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advances" add constraint "advances_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advances" add constraint "advances_employee_id_fkey" FOREIGN KEY (employee_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."advances" add constraint "advances_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."audit_events" add constraint "audit_events_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."barns" add constraint "barns_capacity_check" CHECK (capacity > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."barns" add constraint "barns_code_key" UNIQUE (code);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."barns" add constraint "barns_kind_check" CHECK (kind = ANY (ARRAY['OPEN_HOUSE'::text, 'SEMI_CLOSE_HOUSE'::text, 'CLOSE_HOUSE'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."barns" add constraint "barns_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_amount_check" CHECK (amount >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_category_check" CHECK (category = ANY (ARRAY['OVK'::text, 'TENAGA_KERJA'::text, 'TRANSPORTASI'::text, 'LISTRIK'::text, 'PERBAIKAN'::text, 'EKSPEDISI'::text, 'LAINNYA'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop" add constraint "bop_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop_outside" add constraint "bop_outside_amount_check" CHECK (amount >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."bop_outside" add constraint "bop_outside_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_check" CHECK (doa <= received);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_cycle_id_key" UNIQUE (cycle_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_doa_check" CHECK (doa >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_received_check" CHECK (received >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."chick_ins" add constraint "chick_ins_shipped_check" CHECK (shipped >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."company_profile" add constraint "company_profile_id_check" CHECK (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."company_profile" add constraint "company_profile_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_bonuses" add constraint "contract_bonuses_check" CHECK (max_value IS NULL OR min_value IS NULL OR max_value > min_value);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_bonuses" add constraint "contract_bonuses_contract_id_fkey" FOREIGN KEY (contract_id) REFERENCES contracts(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_bonuses" add constraint "contract_bonuses_metric_check" CHECK (metric = ANY (ARRAY['IP'::text, 'FCR_DIFFERENCE'::text, 'DEPLETION'::text, 'OTHER'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_bonuses" add constraint "contract_bonuses_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_check" CHECK (max_weight_kg > min_weight_kg);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_contract_id_fkey" FOREIGN KEY (contract_id) REFERENCES contracts(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_contract_id_min_weight_kg_key" UNIQUE (contract_id, min_weight_kg);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_min_weight_kg_check" CHECK (min_weight_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contract_live_prices" add constraint "contract_live_prices_price_per_kg_check" CHECK (price_per_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_cycle_id_key" UNIQUE (cycle_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_nonnegative_prices" CHECK (doc_price >= 0::numeric AND pre_starter_price >= 0::numeric AND starter_price >= 0::numeric AND finisher_price >= 0::numeric AND ovk_price >= 0::numeric AND harvest_price >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_number_key" UNIQUE (number);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_ovk_price_basis_check" CHECK (ovk_price_basis = ANY (ARRAY['FIXED'::text, 'DISTRIBUTOR_PLUS_VAT'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_ovk_vat_percent_check" CHECK (ovk_vat_percent >= 0::numeric AND ovk_vat_percent <= 100::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "contracts_source_master_contract_id_fkey" FOREIGN KEY (source_master_contract_id) REFERENCES contracts(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."contracts" add constraint "ovk_basis_valid" CHECK (ovk_price_basis <> 'DISTRIBUTOR_PLUS_VAT'::text OR ovk_vat_percent IS NOT NULL OR cycle_id IS NULL);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_abk_id_fkey" FOREIGN KEY (abk_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_code_key" UNIQUE (code);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_initial_population_check" CHECK (initial_population > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "cycles_ppl_id_fkey" FOREIGN KEY (ppl_id) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."cycles" add constraint "state_dates" CHECK ((state <> 'READY_RHPP'::cycle_state OR ready_at IS NOT NULL) AND (state <> 'CLOSED'::cycle_state OR closed_at IS NOT NULL));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."employees" add constraint "employees_code_key" UNIQUE (code);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."employees" add constraint "employees_kind_check" CHECK (kind = ANY (ARRAY['KARYAWAN'::text, 'ABK'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."employees" add constraint "employees_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."expeditions" add constraint "expeditions_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."expeditions" add constraint "expeditions_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."expeditions" add constraint "expeditions_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."expeditions" add constraint "expeditions_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_bop" add constraint "finance_expedition_bop_amount_check" CHECK (amount >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_bop" add constraint "finance_expedition_bop_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_bop" add constraint "finance_expedition_bop_trip_id_fkey" FOREIGN KEY (trip_id) REFERENCES finance_expedition_trips(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoice_items" add constraint "finance_expedition_invoice_items_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES finance_expedition_invoices(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoice_items" add constraint "finance_expedition_invoice_items_invoice_id_trip_id_key" UNIQUE (invoice_id, trip_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoice_items" add constraint "finance_expedition_invoice_items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoice_items" add constraint "finance_expedition_invoice_items_trip_id_fkey" FOREIGN KEY (trip_id) REFERENCES finance_expedition_trips(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoice_items" add constraint "finance_expedition_invoice_items_trip_id_key" UNIQUE (trip_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoices" add constraint "finance_expedition_invoices_invoice_number_key" UNIQUE (invoice_number);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoices" add constraint "finance_expedition_invoices_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_invoices" add constraint "finance_expedition_invoices_status_check" CHECK (status = ANY (ARRAY['DRAFT'::text, 'ISSUED'::text, 'PAID'::text, 'VOID'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_payments" add constraint "finance_expedition_payments_amount_check" CHECK (amount > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_payments" add constraint "finance_expedition_payments_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES finance_expedition_invoices(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_payments" add constraint "finance_expedition_payments_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_trips" add constraint "finance_expedition_trips_additional_check" CHECK (additional >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_trips" add constraint "finance_expedition_trips_deduction_check" CHECK (deduction >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_trips" add constraint "finance_expedition_trips_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_expedition_trips" add constraint "finance_expedition_trips_trip_price_check" CHECK (trip_price >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."finance_reference_counters" add constraint "finance_reference_counters_pkey" PRIMARY KEY (prefix, ref_date);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_birds_check" CHECK (birds > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_net_weight_kg_check" CHECK (net_weight_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_price_per_kg_check" CHECK (price_per_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."harvests" add constraint "harvests_transaction_number_key" UNIQUE (transaction_number);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."items" add constraint "items_code_key" UNIQUE (code);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."items" add constraint "items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."items" add constraint "items_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_abk_id_fkey" FOREIGN KEY (abk_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_feed_finisher_bags_check" CHECK (feed_finisher_bags IS NULL OR feed_finisher_bags >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_feed_pre_bags_check" CHECK (feed_pre_bags IS NULL OR feed_pre_bags >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_feed_starter_bags_check" CHECK (feed_starter_bags IS NULL OR feed_starter_bags >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_initial_birds_check" CHECK (initial_birds IS NULL OR initial_birds > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_abks_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignment_abks" add constraint "logistics_contract_assignment_contract_assignment_id_abk_id_key" UNIQUE (contract_assignment_id, abk_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_abk_id_fkey" FOREIGN KEY (abk_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_master_contract_id_fkey" FOREIGN KEY (master_contract_id) REFERENCES contracts(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_contract_assignments" add constraint "logistics_contract_assignments_ppl_id_fkey" FOREIGN KEY (ppl_id) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_items" add constraint "logistics_external_return_items_external_return_id_fkey" FOREIGN KEY (external_return_id) REFERENCES logistics_external_returns(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_items" add constraint "logistics_external_return_items_external_shipment_item_id_fkey" FOREIGN KEY (external_shipment_item_id) REFERENCES logistics_external_shipment_items(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_items" add constraint "logistics_external_return_items_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_items" add constraint "logistics_external_return_items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_items" add constraint "logistics_external_return_items_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_tra_source_contract_assignment_i_fkey" FOREIGN KEY (source_contract_assignment_id) REFERENCES logistics_contract_assignments(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_tra_target_contract_assignment_i_fkey" FOREIGN KEY (target_contract_assignment_id) REFERENCES logistics_contract_assignments(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfer_external_return_item_id_fkey" FOREIGN KEY (external_return_item_id) REFERENCES logistics_external_return_items(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfers_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfers_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfers_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfers_source_barn_id_fkey" FOREIGN KEY (source_barn_id) REFERENCES barns(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_return_transfers" add constraint "logistics_external_return_transfers_target_barn_id_fkey" FOREIGN KEY (target_barn_id) REFERENCES barns(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_external_shipment_id_fkey" FOREIGN KEY (external_shipment_id) REFERENCES logistics_external_shipments(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_status_check" CHECK (status = ANY (ARRAY['DRAFT'::text, 'PARTIAL'::text, 'SENT'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_returns" add constraint "logistics_external_returns_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE RESTRICT;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipment_items" add constraint "logistics_external_shipment_items_external_shipment_id_fkey" FOREIGN KEY (external_shipment_id) REFERENCES logistics_external_shipments(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipment_items" add constraint "logistics_external_shipment_items_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipment_items" add constraint "logistics_external_shipment_items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipment_items" add constraint "logistics_external_shipment_items_purchase_unit_price_check" CHECK (purchase_unit_price >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipment_items" add constraint "logistics_external_shipment_items_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipments" add constraint "logistics_external_shipments_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipments" add constraint "logistics_external_shipments_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipments" add constraint "logistics_external_shipments_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_external_shipments" add constraint "logistics_external_shipments_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_return_items" add constraint "logistics_return_items_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_return_items" add constraint "logistics_return_items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_return_items" add constraint "logistics_return_items_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_return_items" add constraint "logistics_return_items_return_id_fkey" FOREIGN KEY (return_id) REFERENCES logistics_returns(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_return_items" add constraint "logistics_return_items_return_id_item_id_key" UNIQUE (return_id, item_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_returns" add constraint "logistics_returns_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_returns" add constraint "logistics_returns_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_returns" add constraint "logistics_returns_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_returns" add constraint "logistics_returns_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipment_items" add constraint "logistics_shipment_items_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipment_items" add constraint "logistics_shipment_items_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipment_items" add constraint "logistics_shipment_items_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipment_items" add constraint "logistics_shipment_items_shipment_id_fkey" FOREIGN KEY (shipment_id) REFERENCES logistics_shipments(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipment_items" add constraint "logistics_shipment_items_shipment_id_item_id_key" UNIQUE (shipment_id, item_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipments" add constraint "logistics_shipments_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipments" add constraint "logistics_shipments_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipments" add constraint "logistics_shipments_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."logistics_shipments" add constraint "logistics_shipments_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_birds_check" CHECK (birds > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_net_weight_kg_check" CHECK (net_weight_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_contract_harvests" add constraint "marketing_contract_harvests_price_positive" CHECK (price_per_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchase_price_positive" CHECK (purchase_price_per_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_purchase_price_per_kg_check" CHECK (purchase_price_per_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES suppliers(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."marketing_external_meat_purchases" add constraint "marketing_external_meat_purchases_weight_kg_check" CHECK (weight_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_age_days_check" CHECK (age_days >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_contract_id_fkey" FOREIGN KEY (contract_id) REFERENCES contracts(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_contract_template_age_key" UNIQUE (contract_id, template_name, age_days);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_std_body_weight_g_check" CHECK (std_body_weight_g > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_std_fcr_check" CHECK (std_fcr > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."performance_standards" add constraint "performance_standards_std_feed_g_per_bird_check" CHECK (std_feed_g_per_bird >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_result_sizes" add constraint "production_abk_result_sizes_birds_check" CHECK (birds > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_result_sizes" add constraint "production_abk_result_sizes_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_result_sizes" add constraint "production_abk_result_sizes_result_id_fkey" FOREIGN KEY (result_id) REFERENCES production_abk_results(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_result_sizes" add constraint "production_abk_result_sizes_weight_kg_check" CHECK (weight_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_abk_id_fkey" FOREIGN KEY (abk_id) REFERENCES employees(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_contract_assignment_id_abk_id_key" UNIQUE (contract_assignment_id, abk_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_feed_finisher_kg_check" CHECK (feed_finisher_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_feed_pre_kg_check" CHECK (feed_pre_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_feed_starter_kg_check" CHECK (feed_starter_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_abk_results" add constraint "production_abk_results_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimate_sizes" add constraint "production_estimate_sizes_birds_check" CHECK (birds > 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimate_sizes" add constraint "production_estimate_sizes_bw_kg_check" CHECK (bw_kg > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimate_sizes" add constraint "production_estimate_sizes_estimate_id_fkey" FOREIGN KEY (estimate_id) REFERENCES production_estimates(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimate_sizes" add constraint "production_estimate_sizes_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_feed_used_kg_check" CHECK (feed_used_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."production_estimates" add constraint "production_estimates_remaining_birds_check" CHECK (remaining_birds >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."profiles" add constraint "profiles_pkey" PRIMARY KEY (user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."profiles" add constraint "profiles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recording_weight_samples" add constraint "recording_weight_samples_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recording_weight_samples" add constraint "recording_weight_samples_recording_id_fkey" FOREIGN KEY (recording_id) REFERENCES recordings(id) ON DELETE CASCADE;
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recording_weight_samples" add constraint "recording_weight_samples_weight_g_check" CHECK (weight_g > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_actual_fcr_check" CHECK (actual_fcr > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_age_days_check" CHECK (age_days >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_culling_check" CHECK (culling >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_cycle_id_recorded_on_key" UNIQUE (cycle_id, recorded_on);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_feed_bags_balance_check" CHECK (feed_bags_balance >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_feed_bags_in_check" CHECK (feed_bags_in >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_feed_bags_out_check" CHECK (feed_bags_out >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_feed_item_id_fkey" FOREIGN KEY (feed_item_id) REFERENCES items(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_feed_kg_check" CHECK (feed_kg >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_ip_check" CHECK (ip >= 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_mortality_check" CHECK (mortality >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."recordings" add constraint "recordings_sample_count_check" CHECK (sample_count >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_age_days_check" CHECK (age_days >= 0);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_estimates" add constraint "rhpp_estimates_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_real" add constraint "rhpp_real_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_real" add constraint "rhpp_real_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_real" add constraint "rhpp_real_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_real" add constraint "rhpp_real_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_real" add constraint "rhpp_real_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_system_final" add constraint "rhpp_system_final_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_system_final" add constraint "rhpp_system_final_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_system_final" add constraint "rhpp_system_final_contract_assignment_id_key" UNIQUE (contract_assignment_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."rhpp_system_final" add constraint "rhpp_system_final_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."suppliers" add constraint "suppliers_code_key" UNIQUE (code);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."suppliers" add constraint "suppliers_name_key" UNIQUE (name);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."suppliers" add constraint "suppliers_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."suppliers" add constraint "suppliers_supplier_type_check" CHECK (supplier_type = ANY (ARRAY['SAPRONAK'::text, 'DAGING'::text]));
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_created_by_fkey" FOREIGN KEY (created_by) REFERENCES profiles(user_id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_item_id_fkey" FOREIGN KEY (item_id) REFERENCES items(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."supplies" add constraint "supplies_quantity_check" CHECK (quantity > 0::numeric);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."visits" add constraint "visits_barn_id_fkey" FOREIGN KEY (barn_id) REFERENCES barns(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."visits" add constraint "visits_contract_assignment_id_fkey" FOREIGN KEY (contract_assignment_id) REFERENCES logistics_contract_assignments(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."visits" add constraint "visits_cycle_id_fkey" FOREIGN KEY (cycle_id) REFERENCES cycles(id);
exception when duplicate_object then null;
end $$;
do $$ begin
  alter table public."visits" add constraint "visits_pkey" PRIMARY KEY (id);
exception when duplicate_object then null;
end $$;

-- INDEXES
CREATE INDEX IF NOT EXISTS salaries_assignment_idx ON public.abk_cycle_salaries USING btree (contract_assignment_id, abk_id);
CREATE INDEX IF NOT EXISTS idx_abk_league_settings_updated_by ON public.abk_league_settings USING btree (updated_by);
CREATE INDEX IF NOT EXISTS idx_advance_payments_advance_id ON public.advance_payments USING btree (advance_id);
CREATE INDEX IF NOT EXISTS advances_assignment_idx ON public.advances USING btree (contract_assignment_id, employee_id);
CREATE INDEX IF NOT EXISTS idx_advances_employee_id ON public.advances USING btree (employee_id);
CREATE INDEX IF NOT EXISTS bop_source_idx ON public.bop USING btree (source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_bop_barn_id ON public.bop USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_bop_contract_assignment_id ON public.bop USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_bop_cycle_id ON public.bop USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_chick_ins_barn_id ON public.chick_ins USING btree (barn_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_chick_ins_contract_assignment ON public.chick_ins USING btree (contract_assignment_id) WHERE (contract_assignment_id IS NOT NULL);
CREATE INDEX IF NOT EXISTS idx_contract_bonuses_contract_id ON public.contract_bonuses USING btree (contract_id);
CREATE INDEX IF NOT EXISTS idx_contracts_source_master_contract_id ON public.contracts USING btree (source_master_contract_id);
CREATE INDEX IF NOT EXISTS idx_cycles_abk_id ON public.cycles USING btree (abk_id);
CREATE INDEX IF NOT EXISTS idx_cycles_ppl_id ON public.cycles USING btree (ppl_id);
CREATE UNIQUE INDEX IF NOT EXISTS one_open_cycle_per_barn ON public.cycles USING btree (barn_id) WHERE (state <> 'CLOSED'::cycle_state);
CREATE INDEX IF NOT EXISTS idx_expeditions_barn_id ON public.expeditions USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_expeditions_contract_assignment_id ON public.expeditions USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_expeditions_cycle_id ON public.expeditions USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS fx_bop_date_idx ON public.finance_expedition_bop USING btree (incurred_on);
CREATE INDEX IF NOT EXISTS fx_invoice_date_idx ON public.finance_expedition_invoices USING btree (invoice_date);
CREATE INDEX IF NOT EXISTS fx_trip_date_idx ON public.finance_expedition_trips USING btree (trip_date);
CREATE INDEX IF NOT EXISTS idx_harvests_barn_id ON public.harvests USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_harvests_contract_assignment_id ON public.harvests USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_harvests_cycle_id ON public.harvests USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_items_supplier_id ON public.items USING btree (supplier_id);
CREATE INDEX IF NOT EXISTS idx_lcaa_abk ON public.logistics_contract_assignment_abks USING btree (abk_id);
CREATE INDEX IF NOT EXISTS idx_lcaa_assignment ON public.logistics_contract_assignment_abks USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_contract_assignments_abk_id ON public.logistics_contract_assignments USING btree (abk_id);
CREATE INDEX IF NOT EXISTS idx_logistics_contract_assignments_contract ON public.logistics_contract_assignments USING btree (master_contract_id);
CREATE INDEX IF NOT EXISTS idx_logistics_contract_assignments_created_by ON public.logistics_contract_assignments USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_logistics_contract_assignments_ppl_id ON public.logistics_contract_assignments USING btree (ppl_id);
CREATE INDEX IF NOT EXISTS idx_logistics_contract_assignments_start_date ON public.logistics_contract_assignments USING btree (start_date);
CREATE UNIQUE INDEX IF NOT EXISTS ux_logistics_contract_assignments_active_barn ON public.logistics_contract_assignments USING btree (barn_id) WHERE (active = true);
CREATE INDEX IF NOT EXISTS idx_external_return_items_source ON public.logistics_external_return_items USING btree (external_shipment_item_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_items_external_return_id ON public.logistics_external_return_items USING btree (external_return_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_items_item_id ON public.logistics_external_return_items USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_external_return_transfer_source ON public.logistics_external_return_transfers USING btree (external_return_item_id);
CREATE INDEX IF NOT EXISTS idx_external_return_transfer_target ON public.logistics_external_return_transfers USING btree (target_contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_transfers_item_id ON public.logistics_external_return_transfers USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_transfers_source_barn_id ON public.logistics_external_return_transfers USING btree (source_barn_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_transfers_source_contract_assignm ON public.logistics_external_return_transfers USING btree (source_contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_return_transfers_target_barn_id ON public.logistics_external_return_transfers USING btree (target_barn_id);
CREATE INDEX IF NOT EXISTS idx_external_returns_assignment ON public.logistics_external_returns USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_external_returns_source ON public.logistics_external_returns USING btree (external_shipment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_returns_barn_id ON public.logistics_external_returns USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_logistics_external_returns_supplier_id ON public.logistics_external_returns USING btree (supplier_id);
CREATE INDEX IF NOT EXISTS idx_external_items_header ON public.logistics_external_shipment_items USING btree (external_shipment_id);
CREATE INDEX IF NOT EXISTS idx_external_items_item ON public.logistics_external_shipment_items USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_external_shipments_assignment ON public.logistics_external_shipments USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_external_shipments_barn ON public.logistics_external_shipments USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_external_shipments_supplier ON public.logistics_external_shipments USING btree (supplier_id);
CREATE INDEX IF NOT EXISTS idx_logistics_return_items_item ON public.logistics_return_items USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_logistics_return_items_return ON public.logistics_return_items USING btree (return_id);
CREATE INDEX IF NOT EXISTS idx_logistics_returns_assignment ON public.logistics_returns USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_returns_barn ON public.logistics_returns USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_logistics_returns_created_by ON public.logistics_returns USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_logistics_shipment_items_item ON public.logistics_shipment_items USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_logistics_shipment_items_shipment ON public.logistics_shipment_items USING btree (shipment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_shipments_assignment ON public.logistics_shipments USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_logistics_shipments_barn ON public.logistics_shipments USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_logistics_shipments_created_by ON public.logistics_shipments USING btree (created_by);
CREATE UNIQUE INDEX IF NOT EXISTS uq_logistics_shipments_shipping_note_number ON public.logistics_shipments USING btree (lower(TRIM(BOTH FROM shipping_note_number))) WHERE (COALESCE(TRIM(BOTH FROM shipping_note_number), ''::text) <> ''::text);
CREATE INDEX IF NOT EXISTS idx_marketing_contract_harvest_assignment ON public.marketing_contract_harvests USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_marketing_contract_harvest_barn ON public.marketing_contract_harvests USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_marketing_contract_harvest_date ON public.marketing_contract_harvests USING btree (harvested_on);
CREATE INDEX IF NOT EXISTS idx_marketing_external_meat_assignment ON public.marketing_external_meat_purchases USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_marketing_external_meat_barn ON public.marketing_external_meat_purchases USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_marketing_external_meat_date ON public.marketing_external_meat_purchases USING btree (purchase_date);
CREATE INDEX IF NOT EXISTS idx_marketing_external_meat_supplier ON public.marketing_external_meat_purchases USING btree (supplier_id);
CREATE INDEX IF NOT EXISTS idx_abk_result_size_date ON public.production_abk_result_sizes USING btree (result_id, harvest_date);
CREATE INDEX IF NOT EXISTS idx_prod_abk_result_sizes_header ON public.production_abk_result_sizes USING btree (result_id);
CREATE INDEX IF NOT EXISTS idx_prod_abk_result_abk ON public.production_abk_results USING btree (abk_id);
CREATE INDEX IF NOT EXISTS idx_prod_abk_result_assignment ON public.production_abk_results USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_production_abk_results_barn_id ON public.production_abk_results USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_production_abk_results_created_by ON public.production_abk_results USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_prod_est_sizes_header ON public.production_estimate_sizes USING btree (estimate_id);
CREATE INDEX IF NOT EXISTS idx_prod_est_assignment ON public.production_estimates USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_production_estimates_barn_id ON public.production_estimates USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_production_estimates_created_by ON public.production_estimates USING btree (created_by);
CREATE UNIQUE INDEX IF NOT EXISTS uq_production_estimate_assignment_date ON public.production_estimates USING btree (contract_assignment_id, estimated_on);
CREATE INDEX IF NOT EXISTS idx_recording_weight_samples_recording ON public.recording_weight_samples USING btree (recording_id);
CREATE INDEX IF NOT EXISTS idx_recordings_assignment ON public.recordings USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_recordings_barn ON public.recordings USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_recordings_feed_item_id ON public.recordings USING btree (feed_item_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_recordings_assignment_date ON public.recordings USING btree (contract_assignment_id, recorded_on) WHERE (contract_assignment_id IS NOT NULL);
CREATE INDEX IF NOT EXISTS idx_rhpp_estimates_barn_id ON public.rhpp_estimates USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_rhpp_estimates_contract_assignment_id ON public.rhpp_estimates USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_rhpp_estimates_created_by ON public.rhpp_estimates USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_rhpp_estimates_cycle_id ON public.rhpp_estimates USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_rhpp_real_barn_id ON public.rhpp_real USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_rhpp_real_created_by ON public.rhpp_real USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_rhpp_real_cycle_id ON public.rhpp_real USING btree (cycle_id);
CREATE UNIQUE INDEX IF NOT EXISTS rhpp_real_assignment_key ON public.rhpp_real USING btree (contract_assignment_id) WHERE (contract_assignment_id IS NOT NULL);
CREATE INDEX IF NOT EXISTS idx_rhpp_system_final_barn_id ON public.rhpp_system_final USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_suppliers_supplier_type ON public.suppliers USING btree (supplier_type);
CREATE INDEX IF NOT EXISTS idx_supplies_barn_id ON public.supplies USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_supplies_contract_assignment_id ON public.supplies USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_supplies_created_by ON public.supplies USING btree (created_by);
CREATE INDEX IF NOT EXISTS idx_supplies_cycle_id ON public.supplies USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_supplies_item_id ON public.supplies USING btree (item_id);
CREATE INDEX IF NOT EXISTS idx_visits_assignment ON public.visits USING btree (contract_assignment_id);
CREATE INDEX IF NOT EXISTS idx_visits_barn ON public.visits USING btree (barn_id);
CREATE INDEX IF NOT EXISTS idx_visits_cycle_id ON public.visits USING btree (cycle_id);

-- VIEWS
create or replace view public."abk_league" with (security_invoker=true) as
SELECT c.abk_id,
    count(*) AS cycles,
    COALESCE(sum(c.initial_population), 0::bigint) AS population,
    COALESCE(sum(p.mortality + p.culling), 0::numeric) AS depletion,
    round(avg(p.fcr), 2) AS avg_fcr,
    COALESCE(sum(p.harvested_birds), 0::numeric) AS harvested_birds
   FROM cycles c
     JOIN cycle_performance p ON p.cycle_id = c.id
  WHERE c.abk_id IS NOT NULL
  GROUP BY c.abk_id;
;
create or replace view public."advance_balances" with (security_invoker=true) as
SELECT a.id,
    a.employee_id,
    a.advanced_on,
    a.amount,
    COALESCE(p.paid, 0::numeric) AS paid,
    a.amount - COALESCE(p.paid, 0::numeric) AS balance
   FROM advances a
     LEFT JOIN ( SELECT advance_payments.advance_id,
            sum(advance_payments.amount) AS paid
           FROM advance_payments
          GROUP BY advance_payments.advance_id) p ON p.advance_id = a.id;
;
create or replace view public."contract_readiness" with (security_invoker=true) as
SELECT id AS contract_id,
    cycle_id,
    number,
    doc_price > 0::numeric AND pre_starter_price > 0::numeric AND starter_price > 0::numeric AND finisher_price > 0::numeric AND NULLIF(TRIM(BOTH FROM COALESCE(signed_reference, ''::text)), ''::text) IS NOT NULL AND (ovk_price_basis = 'FIXED'::text AND ovk_price > 0::numeric OR ovk_price_basis = 'DISTRIBUTOR_PLUS_VAT'::text AND ovk_vat_percent IS NOT NULL) AND (EXISTS ( SELECT 1
           FROM contract_live_prices lp
          WHERE lp.contract_id = k.id)) AND (EXISTS ( SELECT 1
           FROM performance_standards ps
          WHERE ps.contract_id = k.id)) AS is_complete,
    array_remove(ARRAY[
        CASE
            WHEN doc_price <= 0::numeric THEN 'Harga DOC'::text
            ELSE NULL::text
        END,
        CASE
            WHEN pre_starter_price <= 0::numeric THEN 'Harga Pre Starter'::text
            ELSE NULL::text
        END,
        CASE
            WHEN starter_price <= 0::numeric THEN 'Harga Starter'::text
            ELSE NULL::text
        END,
        CASE
            WHEN finisher_price <= 0::numeric THEN 'Harga Finisher'::text
            ELSE NULL::text
        END,
        CASE
            WHEN NULLIF(TRIM(BOTH FROM COALESCE(signed_reference, ''::text)), ''::text) IS NULL THEN 'Referensi kontrak ditandatangani'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ovk_price_basis = 'FIXED'::text AND ovk_price <= 0::numeric THEN 'Harga OVK'::text
            ELSE NULL::text
        END,
        CASE
            WHEN ovk_price_basis = 'DISTRIBUTOR_PLUS_VAT'::text AND ovk_vat_percent IS NULL THEN 'PPN OVK'::text
            ELSE NULL::text
        END,
        CASE
            WHEN NOT (EXISTS ( SELECT 1
               FROM contract_live_prices lp
              WHERE lp.contract_id = k.id)) THEN 'Harga ayam hidup'::text
            ELSE NULL::text
        END,
        CASE
            WHEN NOT (EXISTS ( SELECT 1
               FROM performance_standards ps
              WHERE ps.contract_id = k.id)) THEN 'Standar performa'::text
            ELSE NULL::text
        END], NULL::text) AS missing_components
   FROM contracts k;
;
create or replace view public."cycle_financials" with (security_invoker=true) as
SELECT c.id AS cycle_id,
    c.code,
    c.state,
    r.amount AS rhpp_amount,
    COALESCE(b.total, 0::numeric) AS bop_total,
    r.amount - COALESCE(b.total, 0::numeric) AS profit
   FROM cycles c
     LEFT JOIN rhpp_real r ON r.cycle_id = c.id
     LEFT JOIN ( SELECT bop.cycle_id,
            sum(bop.amount) AS total
           FROM bop
          GROUP BY bop.cycle_id) b ON b.cycle_id = c.id;
;
create or replace view public."cycle_performance" with (security_invoker=true) as
SELECT c.id AS cycle_id,
    c.code,
    c.initial_population,
    COALESCE(r.dead, 0::bigint) AS mortality,
    COALESCE(r.culled, 0::bigint) AS culling,
    round(COALESCE(r.feed, 0::numeric), 2) AS feed_kg,
    r.last_age,
    round(r.last_weight_kg, 2) AS last_weight_kg,
    COALESCE(h.birds, 0::bigint) AS harvested_birds,
    round(COALESCE(h.weight, 0::numeric), 2) AS harvested_weight_kg,
    c.initial_population - COALESCE(r.dead, 0::bigint) - COALESCE(r.culled, 0::bigint) - COALESCE(h.birds, 0::bigint) AS live_birds,
    round(COALESCE(r.feed, 0::numeric) / NULLIF(h.weight, 0::numeric), 2) AS fcr
   FROM cycles c
     LEFT JOIN ( SELECT recordings.cycle_id,
            sum(recordings.mortality) AS dead,
            sum(recordings.culling) AS culled,
            sum(recordings.feed_kg) AS feed,
            max(recordings.age_days) AS last_age,
            (array_agg(recordings.avg_weight_kg ORDER BY recordings.recorded_on DESC) FILTER (WHERE recordings.avg_weight_kg IS NOT NULL))[1] AS last_weight_kg
           FROM recordings
          GROUP BY recordings.cycle_id) r ON r.cycle_id = c.id
     LEFT JOIN ( SELECT harvests.cycle_id,
            sum(harvests.birds) AS birds,
            sum(harvests.net_weight_kg) AS weight
           FROM harvests
          GROUP BY harvests.cycle_id) h ON h.cycle_id = c.id;
;
create or replace view public."daily_performance" with (security_invoker=true) as
SELECT r.id,
    r.cycle_id,
    r.recorded_on,
    r.age_days,
    r.mortality,
    r.culling,
    round(r.feed_kg, 2) AS feed_kg,
    round(r.avg_weight_kg, 2) AS avg_weight_kg,
    r.sample_count,
    round(r.sample_weight_total_kg, 2) AS sample_weight_total_kg,
    round(r.actual_fcr, 2) AS actual_fcr,
    round(r.ip, 2) AS ip,
    round(r.feed_bags_in, 2) AS feed_bags_in,
    round(r.feed_bags_out, 2) AS feed_bags_out,
    round(r.feed_bags_balance, 2) AS feed_bags_balance,
    round(s.std_body_weight_g, 2) AS std_body_weight_g,
    round(s.std_fcr, 2) AS std_fcr,
    round(s.std_feed_g_per_bird, 2) AS std_feed_g_per_bird,
    round(r.avg_weight_kg * 1000::numeric - s.std_body_weight_g, 2) AS body_weight_gap_g,
    round(r.actual_fcr - s.std_fcr, 2) AS fcr_gap
   FROM recordings r
     LEFT JOIN contracts k ON k.cycle_id = r.cycle_id
     LEFT JOIN performance_standards s ON s.contract_id = k.id AND s.age_days = r.age_days;
;
create or replace view public."harvest_contract_preview" with (security_invoker=true) as
SELECT h.id AS harvest_id,
    h.cycle_id,
    h.harvested_on,
    h.birds,
    round(h.net_weight_kg, 2) AS net_weight_kg,
    round(h.net_weight_kg / NULLIF(h.birds, 0)::numeric, 2) AS avg_weight_kg,
    p.price_per_kg AS contract_price_per_kg,
    round(h.net_weight_kg * p.price_per_kg, 2) AS contract_gross,
    h.price_per_kg AS sale_price_per_kg,
    round(h.net_weight_kg * h.price_per_kg, 2) AS sale_gross
   FROM harvests h
     LEFT JOIN contracts k ON k.cycle_id = h.cycle_id
     LEFT JOIN contract_live_prices p ON p.contract_id = k.id AND (h.net_weight_kg / NULLIF(h.birds, 0)::numeric) >= p.min_weight_kg AND (p.max_weight_kg IS NULL OR (h.net_weight_kg / NULLIF(h.birds, 0)::numeric) < p.max_weight_kg);
;
create or replace view public."logistics_company_adjustment_summary" with (security_invoker=true) as
WITH external_lines AS (
         SELECT eh.contract_assignment_id,
            i.category,
            i.feed_phase,
            i.kg_per_unit,
            ei.quantity,
            ei.purchase_unit_price,
            c.doc_price,
            c.pre_starter_price,
            c.starter_price,
            c.finisher_price,
            c.ovk_price_basis,
            c.ovk_price,
                CASE
                    WHEN i.category = 'DOC'::text THEN c.doc_price
                    WHEN i.category = 'PAKAN'::text AND i.kg_per_unit IS NOT NULL AND lower(COALESCE(i.feed_phase, ''::text)) ~~ '%pre%'::text THEN c.pre_starter_price * i.kg_per_unit
                    WHEN i.category = 'PAKAN'::text AND i.kg_per_unit IS NOT NULL AND lower(COALESCE(i.feed_phase, ''::text)) ~~ '%starter%'::text THEN c.starter_price * i.kg_per_unit
                    WHEN i.category = 'PAKAN'::text AND i.kg_per_unit IS NOT NULL AND lower(COALESCE(i.feed_phase, ''::text)) ~~ '%fin%'::text THEN c.finisher_price * i.kg_per_unit
                    WHEN i.category = 'OVK'::text AND c.ovk_price_basis = 'FIXED'::text THEN c.ovk_price
                    ELSE NULL::numeric
                END AS contract_unit_price
           FROM logistics_external_shipments eh
             JOIN logistics_external_shipment_items ei ON ei.external_shipment_id = eh.id
             JOIN items i ON i.id = ei.item_id
             JOIN logistics_contract_assignments a_1 ON a_1.id = eh.contract_assignment_id
             JOIN contracts c ON c.id = a_1.master_contract_id
        ), external_by_assignment AS (
         SELECT external_lines.contract_assignment_id,
            sum(external_lines.quantity * external_lines.purchase_unit_price)::numeric(16,2) AS actual_purchase_total,
            sum(
                CASE
                    WHEN external_lines.contract_unit_price IS NOT NULL THEN external_lines.quantity * external_lines.contract_unit_price
                    ELSE 0::numeric
                END)::numeric(16,2) AS contract_equivalent_total,
            sum(
                CASE
                    WHEN external_lines.contract_unit_price IS NOT NULL THEN external_lines.quantity * (external_lines.purchase_unit_price - external_lines.contract_unit_price)
                    ELSE 0::numeric
                END)::numeric(16,2) AS sapronak_price_adjustment,
            sum(
                CASE
                    WHEN external_lines.contract_unit_price IS NULL THEN external_lines.quantity * external_lines.purchase_unit_price
                    ELSE 0::numeric
                END)::numeric(16,2) AS sapronak_unpriced_contract_total
           FROM external_lines
          GROUP BY external_lines.contract_assignment_id
        ), bl_by_assignment AS (
         SELECT marketing_external_meat_purchases.contract_assignment_id,
            sum(marketing_external_meat_purchases.weight_kg * marketing_external_meat_purchases.purchase_price_per_kg)::numeric(16,2) AS trading_bl_total
           FROM marketing_external_meat_purchases
          WHERE marketing_external_meat_purchases.contract_assignment_id IS NOT NULL
          GROUP BY marketing_external_meat_purchases.contract_assignment_id
        )
 SELECT a.id AS contract_assignment_id,
    a.barn_id,
    a.master_contract_id,
    a.performance_template_name,
    a.start_date,
    a.active,
    COALESCE(e.actual_purchase_total, 0::numeric)::numeric(16,2) AS external_sapronak_actual_total,
    COALESCE(e.contract_equivalent_total, 0::numeric)::numeric(16,2) AS external_sapronak_contract_total,
    COALESCE(e.sapronak_price_adjustment, 0::numeric)::numeric(16,2) AS sapronak_price_adjustment,
    COALESCE(e.sapronak_unpriced_contract_total, 0::numeric)::numeric(16,2) AS sapronak_unpriced_contract_total,
    COALESCE(b.trading_bl_total, 0::numeric)::numeric(16,2) AS trading_bl_total,
    (COALESCE(e.sapronak_price_adjustment, 0::numeric) + COALESCE(b.trading_bl_total, 0::numeric))::numeric(16,2) AS total_company_adjustment
   FROM logistics_contract_assignments a
     LEFT JOIN external_by_assignment e ON e.contract_assignment_id = a.id
     LEFT JOIN bl_by_assignment b ON b.contract_assignment_id = a.id;
;
create or replace view public."logistics_rhpp_cost_summary" with (security_invoker=true) as
WITH ship AS (
         SELECT s.contract_assignment_id,
            sum(si.quantity * si.unit_price) AS shipment_total,
            sum(
                CASE
                    WHEN i.category = 'DOC'::text THEN si.quantity * si.unit_price
                    ELSE 0::numeric
                END) AS doc_cost,
            sum(
                CASE
                    WHEN i.category = 'PAKAN'::text THEN si.quantity * si.unit_price
                    ELSE 0::numeric
                END) AS feed_cost,
            sum(
                CASE
                    WHEN i.category = 'OVK'::text THEN si.quantity * si.unit_price
                    ELSE 0::numeric
                END) AS ovk_cost
           FROM logistics_shipments s
             JOIN logistics_shipment_items si ON si.shipment_id = s.id
             JOIN items i ON i.id = si.item_id
          GROUP BY s.contract_assignment_id
        ), ret AS (
         SELECT r.contract_assignment_id,
            sum(ri.quantity * ri.unit_price) AS return_total
           FROM logistics_returns r
             JOIN logistics_return_items ri ON ri.return_id = r.id
          GROUP BY r.contract_assignment_id
        )
 SELECT a.id AS contract_assignment_id,
    a.barn_id,
    a.master_contract_id,
    a.performance_template_name,
    a.start_date,
    a.active,
    COALESCE(ship.doc_cost, 0::numeric)::numeric(16,2) AS doc_cost,
    COALESCE(ship.feed_cost, 0::numeric)::numeric(16,2) AS feed_cost,
    COALESCE(ship.ovk_cost, 0::numeric)::numeric(16,2) AS ovk_cost,
    COALESCE(ship.shipment_total, 0::numeric)::numeric(16,2) AS shipment_total,
    COALESCE(ret.return_total, 0::numeric)::numeric(16,2) AS return_total,
    (COALESCE(ship.shipment_total, 0::numeric) - COALESCE(ret.return_total, 0::numeric))::numeric(16,2) AS net_sapronak_cost
   FROM logistics_contract_assignments a
     LEFT JOIN ship ON ship.contract_assignment_id = a.id
     LEFT JOIN ret ON ret.contract_assignment_id = a.id;
;
create or replace view public."ppl_league" with (security_invoker=true) as
SELECT c.ppl_id,
    count(*) AS cycles,
    COALESCE(sum(c.initial_population), 0::bigint) AS population,
    COALESCE(sum(p.mortality + p.culling), 0::numeric) AS depletion,
    round(avg(p.fcr), 2) AS avg_fcr,
    COALESCE(sum(p.harvested_birds), 0::numeric) AS harvested_birds
   FROM cycles c
     JOIN cycle_performance p ON p.cycle_id = c.id
  WHERE c.ppl_id IS NOT NULL
  GROUP BY c.ppl_id;
;

-- FUNCTIONS
set check_function_bodies = off;

-- private.admin_list_bms_users_impl()
CREATE OR REPLACE FUNCTION private.admin_list_bms_users_impl()
 RETURNS TABLE(user_id uuid, email text, full_name text, role bms_role, active boolean, email_confirmed boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if private.my_bms_role() <> 'ADMIN'::public.bms_role then
    raise exception 'Akses hanya untuk Administrator';
  end if;

  return query
  select p.user_id,
         u.email::text,
         p.full_name,
         p.role,
         p.active,
         (u.email_confirmed_at is not null)
  from public.profiles p
  join auth.users u on u.id=p.user_id
  order by p.full_name, u.email;
end
$function$;

-- private.admin_update_bms_user_impl(p_user_id uuid, p_name text, p_role bms_role, p_active boolean)
CREATE OR REPLACE FUNCTION private.admin_update_bms_user_impl(p_user_id uuid, p_name text, p_role bms_role, p_active boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if private.my_bms_role() <> 'ADMIN'::public.bms_role then
    raise exception 'Akses hanya untuk Administrator';
  end if;

  if p_user_id is null or nullif(trim(p_name),'') is null then
    raise exception 'Data pengguna tidak lengkap';
  end if;

  if p_user_id = auth.uid()
     and (p_role <> 'ADMIN'::public.bms_role or coalesce(p_active,true)=false) then
    raise exception 'ADMIN yang sedang login tidak boleh menonaktifkan atau mengganti role akun sendiri';
  end if;

  update public.profiles
  set full_name=trim(p_name),
      role=p_role,
      active=coalesce(p_active,true)
  where user_id=p_user_id;

  if not found then
    raise exception 'Pengguna tidak ditemukan';
  end if;
end
$function$;

-- private.assign_bms_role_impl(p_email text, p_role bms_role, p_name text)
CREATE OR REPLACE FUNCTION private.assign_bms_role_impl(p_email text, p_role bms_role, p_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare target_id uuid;
begin
  if private.my_bms_role() <> 'ADMIN' then
    raise exception 'Hanya Administrator';
  end if;

  select id into target_id
  from auth.users
  where lower(email)=lower(trim(p_email))
    and email_confirmed_at is not null;

  if target_id is null then
    raise exception 'Akun belum ditemukan atau email belum diverifikasi';
  end if;

  insert into public.profiles(user_id,role,full_name,active)
  values(target_id,p_role,p_name,true)
  on conflict(user_id) do update
    set role=excluded.role,full_name=excluded.full_name,active=true;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),'ASSIGN_ROLE','profiles',target_id::text,
    jsonb_build_object('role',p_role,'name',p_name));

  return target_id;
end
$function$;

-- private.bind_master_contract_to_cycle_core(p_master_contract_id uuid, p_cycle_id uuid)
CREATE OR REPLACE FUNCTION private.bind_master_contract_to_cycle_core(p_master_contract_id uuid, p_cycle_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  m public.contracts%rowtype;
  new_contract_id uuid;
  st public.cycle_state;
begin
  if private.my_bms_role() <> 'ADMIN'::public.bms_role then
    raise exception 'Hanya ADMIN yang dapat mengikat kontrak';
  end if;

  select * into m
  from public.contracts
  where id=p_master_contract_id
    and cycle_id is null;

  if not found then
    raise exception 'Master Kontrak tidak ditemukan';
  end if;

  if m.performance_template_name is null then
    raise exception 'Template performa belum dipilih';
  end if;

  if not exists(
    select 1 from public.performance_standards
    where contract_id=m.id and template_name=m.performance_template_name
  ) then
    raise exception 'Template performa tidak ditemukan';
  end if;

  select state into st
  from public.cycles
  where id=p_cycle_id
  for update;

  if st is null then raise exception 'Siklus tidak ditemukan'; end if;
  if st <> 'ACTIVE' then raise exception 'Siklus tidak aktif'; end if;
  if exists(select 1 from public.contracts where cycle_id=p_cycle_id) then
    raise exception 'Siklus sudah memiliki kontrak';
  end if;

  insert into public.contracts(
    cycle_id,number,contract_date,integrator,
    doc_price,pre_starter_price,starter_price,finisher_price,
    ovk_price,harvest_price,parameters,ovk_price_basis,
    ovk_vat_percent,signed_reference,
    source_master_contract_id,frozen_at,performance_template_name
  )
  values(
    p_cycle_id,
    m.number || '-' || (select code from public.cycles where id=p_cycle_id),
    m.contract_date,m.integrator,
    m.doc_price,m.pre_starter_price,m.starter_price,m.finisher_price,
    m.ovk_price,m.harvest_price,m.parameters,m.ovk_price_basis,
    m.ovk_vat_percent,m.signed_reference,
    m.id,now(),m.performance_template_name
  )
  returning id into new_contract_id;

  insert into public.contract_live_prices(contract_id,min_weight_kg,max_weight_kg,price_per_kg)
  select new_contract_id,min_weight_kg,max_weight_kg,price_per_kg
  from public.contract_live_prices
  where contract_id=p_master_contract_id;

  insert into public.contract_bonuses(contract_id,metric,min_value,max_value,rupiah_per_kg,notes)
  select new_contract_id,metric,min_value,max_value,rupiah_per_kg,notes
  from public.contract_bonuses
  where contract_id=p_master_contract_id;

  insert into public.performance_standards(
    contract_id,template_name,age_days,std_body_weight_g,std_fcr,std_feed_g_per_bird
  )
  select new_contract_id,template_name,age_days,std_body_weight_g,std_fcr,std_feed_g_per_bird
  from public.performance_standards
  where contract_id=p_master_contract_id
    and template_name=m.performance_template_name;

  return new_contract_id;
end
$function$;

-- private.can_edit_assignment(aid uuid, allowed bms_role[])
CREATE OR REPLACE FUNCTION private.can_edit_assignment(aid uuid, allowed bms_role[])
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists(
    select 1
    from public.logistics_contract_assignments a
    join public.profiles p on p.user_id=(select auth.uid()) and p.active
    where a.id=aid
      and p.role=any(allowed)
      and (
        p.role='ADMIN'::public.bms_role
        or (
          a.active=true
          and (p.role <> 'PPL'::public.bms_role or a.ppl_id=(select auth.uid()))
        )
      )
  )
$function$;

-- private.can_edit_cycle(cid uuid, allowed bms_role[])
CREATE OR REPLACE FUNCTION private.can_edit_cycle(cid uuid, allowed bms_role[])
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists(
    select 1
    from public.cycles c
    where c.id=cid
      and c.state='ACTIVE'
      and (
        private.my_bms_role()='ADMIN'::public.bms_role
        or (
          private.my_bms_role()=any(allowed)
          and (private.my_bms_role()<>'PPL'::public.bms_role or c.ppl_id=(select auth.uid()))
        )
      )
  )
$function$;

-- private.can_read_assignment(aid uuid)
CREATE OR REPLACE FUNCTION private.can_read_assignment(aid uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists(
    select 1
    from public.logistics_contract_assignments a
    join public.profiles p on p.user_id=(select auth.uid()) and p.active
    where a.id=aid
      and p.role in ('ADMIN','OWNER','KEUANGAN','LOGISTIK','MARKETING','PPL')
      and (p.role <> 'PPL'::public.bms_role or a.ppl_id=(select auth.uid()))
  )
$function$;

-- private.can_read_cycle(cid uuid)
CREATE OR REPLACE FUNCTION private.can_read_cycle(cid uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists(
    select 1
    from public.cycles c
    where c.id = cid
      and (
        private.my_bms_role() in ('ADMIN','OWNER','KEUANGAN','LOGISTIK','MARKETING')
        or (private.my_bms_role() = 'PPL' and c.ppl_id = (select auth.uid()))
      )
  )
$function$;

-- private.guard_assignment_operation()
CREATE OR REPLACE FUNCTION private.guard_assignment_operation()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  aid uuid;
begin
  aid := case when tg_op='DELETE' then old.contract_assignment_id else new.contract_assignment_id end;
  if aid is null then
    raise exception 'Kandang / Kontrak Logistik wajib dipilih.';
  end if;

  select * into a from public.logistics_contract_assignments where id=aid;
  if a.id is null then
    raise exception 'Kontrak Logistik tidak ditemukan.';
  end if;
  if not a.active then
    raise exception 'Kontrak Logistik sudah CLOSED dan data terkunci.';
  end if;

  if tg_op='DELETE' then return old; end if;

  new.barn_id := a.barn_id;
  new.cycle_id := null;
  return new;
end;
$function$;

-- private.guard_chick_in_contract()
CREATE OR REPLACE FUNCTION private.guard_chick_in_contract()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
begin
  if tg_op='DELETE' then
    select * into a
    from public.logistics_contract_assignments
    where id=old.contract_assignment_id;

    if old.contract_assignment_id is not null and coalesce(a.active,false)=false then
      raise exception 'Kontrak sudah CLOSED. Chick-In terkunci.';
    end if;
    return old;
  end if;

  if new.contract_assignment_id is null or new.barn_id is null then
    raise exception 'Kandang / Kontrak Aktif wajib dipilih.';
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null then
    raise exception 'Kontrak kandang tidak ditemukan.';
  end if;

  if a.active=false then
    raise exception 'Kontrak sudah CLOSED. Chick-In terkunci.';
  end if;

  if a.barn_id<>new.barn_id then
    raise exception 'Kandang tidak sesuai kontrak aktif.';
  end if;

  if new.arrived_on<a.start_date then
    raise exception 'Tanggal Chick-In tidak boleh sebelum tanggal mulai kontrak.';
  end if;

  if new.received<=0 or new.doa<0 or new.doa>=new.received then
    raise exception 'Jumlah DOC/DOA tidak valid. Populasi bersih harus lebih dari 0.';
  end if;

  if new.avg_weight is not null and new.avg_weight<=0 then
    raise exception 'Bobot DOC rata-rata harus lebih dari 0.';
  end if;

  new.shipped:=new.received;
  new.cycle_id:=null;
  return new;
end;
$function$;

-- private.guard_contract_assignment_state()
CREATE OR REPLACE FUNCTION private.guard_contract_assignment_state()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if old.active=false then
    if new.active=true
       and coalesce(current_setting('bms.allow_production_reopen',true),'')='1'
       and exists(
         select 1 from public.profiles p
         where p.user_id=auth.uid() and p.active and p.role='ADMIN'
       )
    then
      return new;
    end if;

    if new.active is distinct from old.active
       or new.barn_id is distinct from old.barn_id
       or new.master_contract_id is distinct from old.master_contract_id
       or new.performance_template_name is distinct from old.performance_template_name
       or new.start_date is distinct from old.start_date
       or new.abk_id is distinct from old.abk_id
       or new.created_by is distinct from old.created_by
       or new.created_at is distinct from old.created_at
    then
      raise exception 'Periode sudah Close. Gunakan Buka Kembali Siklus sebelum koreksi.';
    end if;
  end if;

  if old.active=true and new.active=false then
    if coalesce(current_setting('bms.allow_production_close',true),'') <> '1' then
      raise exception 'Close Produksi hanya dapat dilakukan dari RHPP Administrator.';
    end if;
  end if;

  return new;
end
$function$;

-- private.guard_item_supplier_type()
CREATE OR REPLACE FUNCTION private.guard_item_supplier_type()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare st text;
begin
  if new.supplier_id is not null then
    select supplier_type into st from public.suppliers where id=new.supplier_id;
    if st is distinct from 'SAPRONAK' then
      raise exception 'Master Sapronak hanya boleh memakai Supplier Sapronak.';
    end if;
  end if;
  return new;
end $function$;

-- private.guard_logistics_assignment_close()
CREATE OR REPLACE FUNCTION private.guard_logistics_assignment_close()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if old.active=true and new.active=false then
    if coalesce(current_setting('bms.allow_production_close',true),'') <> '1' then
      raise exception 'Close Produksi hanya dapat dilakukan dari RHPP Administrator.';
    end if;
  end if;

  if old.active=false and new.active=true then
    raise exception 'Periode yang sudah Close tidak dapat diaktifkan kembali.';
  end if;

  return new;
end;
$function$;

-- private.guard_logistics_external_header()
CREATE OR REPLACE FUNCTION private.guard_logistics_external_header()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  st text;
begin
  if tg_op in ('UPDATE','DELETE') then
    select * into a from public.logistics_contract_assignments where id=old.contract_assignment_id;
    if a.id is null or not a.active then
      raise exception 'Kontrak Logistik sudah CLOSED. Tambah Sapronak terkunci.';
    end if;
    if tg_op='DELETE' then return old; end if;
  end if;

  select * into a from public.logistics_contract_assignments where id=new.contract_assignment_id;
  if a.id is null or not a.active then
    raise exception 'Kontrak Logistik tidak aktif.';
  end if;
  if a.barn_id<>new.barn_id then
    raise exception 'Kandang tidak sesuai kontrak aktif.';
  end if;
  if new.shipment_date<a.start_date then
    raise exception 'Tanggal Tambah Sapronak tidak boleh sebelum tanggal mulai kontrak.';
  end if;
  select supplier_type into st from public.suppliers where id=new.supplier_id and active=true;
  if st is distinct from 'SAPRONAK' then
    raise exception 'Supplier harus berasal dari Master Supplier Sapronak.';
  end if;
  return new;
end $function$;

-- private.guard_logistics_external_item()
CREATE OR REPLACE FUNCTION private.guard_logistics_external_item()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  header_supplier uuid;
  item_supplier uuid;
  st text;
begin
  select h.supplier_id into header_supplier
  from public.logistics_external_shipments h
  where h.id=new.external_shipment_id;
  if header_supplier is null then
    raise exception 'Header Tambah Sapronak tidak ditemukan.';
  end if;

  select i.supplier_id,s.supplier_type into item_supplier,st
  from public.items i
  left join public.suppliers s on s.id=i.supplier_id
  where i.id=new.item_id;

  if item_supplier is null or item_supplier<>header_supplier then
    raise exception 'Sapronak tidak sesuai Supplier.';
  end if;
  if st is distinct from 'SAPRONAK' then
    raise exception 'Item harus terkait Supplier Sapronak.';
  end if;
  return new;
end $function$;

-- private.guard_marketing_harvest()
CREATE OR REPLACE FUNCTION private.guard_marketing_harvest()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  v_avg_bw numeric;
  v_price numeric;
begin
  if tg_op in ('UPDATE','DELETE') then
    select * into a
    from public.logistics_contract_assignments
    where id=old.contract_assignment_id;

    if a.id is null or not a.active then
      raise exception 'Kontrak sudah CLOSED. Panen Kontrak terkunci.';
    end if;

    if tg_op='DELETE' then
      return old;
    end if;
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null or not a.active then
    raise exception 'Kontrak tidak aktif.';
  end if;

  if a.barn_id<>new.barn_id then
    raise exception 'Kandang tidak sesuai kontrak aktif.';
  end if;

  if new.harvested_on<a.start_date then
    raise exception 'Tanggal panen tidak boleh sebelum tanggal mulai kontrak.';
  end if;

  if coalesce(new.birds,0)<=0 then
    raise exception 'Jumlah ekor harus lebih dari 0.';
  end if;

  if coalesce(new.net_weight_kg,0)<=0 then
    raise exception 'Berat panen harus lebih dari 0 Kg.';
  end if;

  v_avg_bw := new.net_weight_kg / new.birds;

  select lp.price_per_kg
    into v_price
  from public.contract_live_prices lp
  where lp.contract_id=a.master_contract_id
    and v_avg_bw>=lp.min_weight_kg
    and (lp.max_weight_kg is null or v_avg_bw<lp.max_weight_kg)
  order by lp.min_weight_kg desc
  limit 1;

  if v_price is null then
    raise exception 'Harga kontrak untuk BW rata-rata % Kg belum tersedia.', round(v_avg_bw,3);
  end if;

  new.price_per_kg := v_price;
  new.updated_at := now();

  return new;
end
$function$;

-- private.guard_marketing_meat()
CREATE OR REPLACE FUNCTION private.guard_marketing_meat()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  st text;
begin
  if tg_op in ('UPDATE','DELETE') then
    select * into a from public.logistics_contract_assignments where id=old.contract_assignment_id;
    if a.id is null or not a.active then
      raise exception 'Kontrak sudah CLOSED. Tambah Daging terkunci.';
    end if;
    if tg_op='DELETE' then return old; end if;
  end if;

  select * into a from public.logistics_contract_assignments where id=new.contract_assignment_id;
  if a.id is null or not a.active then raise exception 'Kontrak tidak aktif.'; end if;
  if a.barn_id<>new.barn_id then raise exception 'Kandang tidak sesuai kontrak aktif.'; end if;
  if new.purchase_date<a.start_date then raise exception 'Tanggal Tambah Daging tidak boleh sebelum tanggal mulai kontrak.'; end if;
  select supplier_type into st from public.suppliers where id=new.supplier_id and active=true;
  if st is distinct from 'DAGING' then raise exception 'Supplier harus berasal dari Master Supplier Daging.'; end if;
  if new.purchase_price_per_kg<=0 then raise exception 'Harga beli per Kg wajib lebih dari 0.'; end if;
  return new;
end $function$;

-- private.guard_production_abk_result()
CREATE OR REPLACE FUNCTION private.guard_production_abk_result()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
    declare a public.logistics_contract_assignments%rowtype;
            ci public.chick_ins%rowtype;
    begin
      if tg_op='DELETE' then
        select * into a from public.logistics_contract_assignments where id=old.contract_assignment_id;
        if coalesce(a.active,false)=false then raise exception 'Kontrak sudah CLOSED. Liga ABK terkunci.'; end if;
        return old;
      end if;
      select * into a from public.logistics_contract_assignments where id=new.contract_assignment_id;
      if a.id is null or not a.active or a.barn_id<>new.barn_id then raise exception 'Kontrak/kandang tidak aktif atau tidak sesuai.'; end if;
      if not exists(select 1 from public.logistics_contract_assignment_abks x where x.contract_assignment_id=a.id and x.abk_id=new.abk_id) then
        raise exception 'ABK tidak terdaftar pada kontrak kandang ini.';
      end if;
      select * into ci from public.chick_ins where contract_assignment_id=a.id;
      if ci.id is null or new.harvest_date<ci.arrived_on then raise exception 'Tanggal panen tidak valid.'; end if;
      return new;
    end $function$;

-- private.guard_production_estimate()
CREATE OR REPLACE FUNCTION private.guard_production_estimate()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  ci public.chick_ins%rowtype;
begin
  if tg_op='DELETE' then
    select * into a
    from public.logistics_contract_assignments
    where id=old.contract_assignment_id;

    if coalesce(a.active,false)=false then
      raise exception 'Kontrak sudah CLOSED. Estimasi terkunci.';
    end if;
    return old;
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null or not a.active or a.barn_id<>new.barn_id then
    raise exception 'Kontrak/kandang tidak aktif atau tidak sesuai.';
  end if;

  select * into ci
  from public.chick_ins
  where contract_assignment_id=a.id;

  if ci.id is null then
    raise exception 'Chick-In belum tersedia.';
  end if;

  -- Hari Chick-In dihitung sebagai umur 1.
  if ((new.estimated_on - ci.arrived_on) + 1) < 23 then
    raise exception 'Estimasi dimulai minimal umur 23 hari.';
  end if;

  return new;
end
$function$;

-- private.guard_production_recording()
CREATE OR REPLACE FUNCTION private.guard_production_recording()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  ci public.chick_ins%rowtype;
  kg_per numeric;
  used_dead integer;
  sent_units numeric;
  external_units numeric;
  returned_units numeric;
  used_units numeric;
  available_units numeric;
begin
  if tg_op='DELETE' then
    select * into a
    from public.logistics_contract_assignments
    where id=old.contract_assignment_id;

    if old.contract_assignment_id is not null and coalesce(a.active,false)=false then
      raise exception 'Kontrak sudah CLOSED. Recording terkunci.';
    end if;
    return old;
  end if;

  if new.contract_assignment_id is null or new.barn_id is null then
    raise exception 'Kandang / Kontrak Aktif wajib dipilih.';
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null or not a.active then
    raise exception 'Kontrak tidak aktif.';
  end if;

  if a.barn_id<>new.barn_id then
    raise exception 'Kandang tidak sesuai kontrak.';
  end if;

  select * into ci
  from public.chick_ins
  where contract_assignment_id=a.id
  order by arrived_on desc
  limit 1;

  if ci.id is null then
    raise exception 'Chick-In harus diisi sebelum Recording PPL.';
  end if;

  if new.age_days is null or new.age_days < 1 then
    raise exception 'Hari recording harus dimulai dari Hari ke-1.';
  end if;

  -- Umur 1 adalah hari Chick-In.
  new.recorded_on := ci.arrived_on + (new.age_days - 1);

  if exists (
    select 1
    from public.recordings r
    where r.contract_assignment_id=new.contract_assignment_id
      and r.age_days=new.age_days
      and r.id is distinct from new.id
  ) then
    raise exception 'Hari ke-% sudah pernah diisi.', new.age_days;
  end if;

  if new.feed_item_id is null or new.feed_quantity_units is null or new.feed_quantity_units<=0 then
    raise exception 'Pakan dan jumlah pemakaian wajib diisi.';
  end if;

  select i.kg_per_unit into kg_per
  from public.items i
  where i.id=new.feed_item_id and i.category='PAKAN' and i.active=true;

  if kg_per is null or kg_per<=0 then
    raise exception 'Konversi Kg/Satuan pakan belum tersedia.';
  end if;

  select coalesce(sum(li.quantity),0)
    into sent_units
  from public.logistics_shipments s
  join public.logistics_shipment_items li on li.shipment_id=s.id
  where s.contract_assignment_id=new.contract_assignment_id
    and li.item_id=new.feed_item_id;

  select coalesce(sum(li.quantity),0)
    into external_units
  from public.logistics_external_shipments s
  join public.logistics_external_shipment_items li on li.external_shipment_id=s.id
  where s.contract_assignment_id=new.contract_assignment_id
    and li.item_id=new.feed_item_id;

  select coalesce(sum(li.quantity),0)
    into returned_units
  from public.logistics_returns r
  join public.logistics_return_items li on li.return_id=r.id
  where r.contract_assignment_id=new.contract_assignment_id
    and li.item_id=new.feed_item_id;

  select coalesce(sum(r.feed_quantity_units),0)
    into used_units
  from public.recordings r
  where r.contract_assignment_id=new.contract_assignment_id
    and r.feed_item_id=new.feed_item_id
    and r.id is distinct from new.id;

  available_units := sent_units + external_units - returned_units - used_units;

  if available_units<=0 then
    raise exception 'Stok pakan ini sudah habis.';
  end if;

  if new.feed_quantity_units>available_units then
    raise exception 'Pemakaian pakan melebihi sisa stok. Sisa: % satuan.', available_units;
  end if;

  new.feed_kg := new.feed_quantity_units*kg_per;

  select coalesce(sum(r.mortality+r.culling),0)
    into used_dead
  from public.recordings r
  where r.contract_assignment_id=new.contract_assignment_id
    and r.id is distinct from new.id;

  if used_dead + coalesce(new.mortality,0) + coalesce(new.culling,0) >= (ci.received-ci.doa) then
    raise exception 'Kematian dan afkir tidak boleh menghabiskan seluruh populasi.';
  end if;

  new.cycle_id:=null;
  return new;
end;
$function$;

-- private.guard_production_visit()
CREATE OR REPLACE FUNCTION private.guard_production_visit()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
  ci public.chick_ins%rowtype;
begin
  if tg_op='DELETE' then
    select * into a
    from public.logistics_contract_assignments
    where id=old.contract_assignment_id;

    if old.contract_assignment_id is not null
       and coalesce(a.active,false)=false then
      raise exception 'Kontrak sudah CLOSED. Kunjungan terkunci.';
    end if;
    return old;
  end if;

  if new.contract_assignment_id is null or new.barn_id is null then
    raise exception 'Kandang / Kontrak Aktif wajib dipilih.';
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null or not a.active or a.barn_id<>new.barn_id then
    raise exception 'Kontrak/kandang tidak aktif atau tidak sesuai.';
  end if;

  select * into ci
  from public.chick_ins
  where contract_assignment_id=a.id
  limit 1;

  if ci.id is null then
    raise exception 'Chick-In harus tersedia sebelum Kunjungan PPL.';
  end if;

  if new.visited_on < ci.arrived_on then
    raise exception 'Tanggal Kunjungan tidak boleh sebelum Chick-In.';
  end if;

  if length(trim(coalesce(new.findings,''))) < 3 then
    raise exception 'Temuan Kunjungan wajib diisi.';
  end if;

  if length(trim(coalesce(new.recommendation,''))) < 3 then
    raise exception 'Rekomendasi Kunjungan wajib diisi.';
  end if;

  if length(trim(coalesce(new.follow_up,''))) < 3 then
    raise exception 'Tindak lanjut Kunjungan wajib diisi.';
  end if;

  new.follow_up_status := upper(trim(coalesce(new.follow_up_status,'')));
  if new.follow_up_status not in ('BELUM','PROSES','SELESAI') then
    raise exception 'Status tindak lanjut harus BELUM, PROSES, atau SELESAI.';
  end if;

  new.cycle_id := null;
  return new;
end
$function$;

-- private.guard_rhpp_real_operation()
CREATE OR REPLACE FUNCTION private.guard_rhpp_real_operation()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  a public.logistics_contract_assignments%rowtype;
begin
  if tg_op='DELETE' then
    raise exception 'RHPP Real yang sudah tersimpan tidak dapat dihapus.';
  end if;

  if new.contract_assignment_id is null then
    raise exception 'Kandang / Siklus wajib dipilih.';
  end if;

  select * into a
  from public.logistics_contract_assignments
  where id=new.contract_assignment_id;

  if a.id is null then
    raise exception 'Siklus tidak ditemukan.';
  end if;

  if tg_op='UPDATE' then
    raise exception 'RHPP Real yang sudah tersimpan tidak dapat diubah.';
  end if;

  if a.active then
    raise exception 'RHPP Real hanya dapat diinput setelah Administrator Close.';
  end if;

  if not exists (
    select 1
    from public.rhpp_system_final s
    where s.contract_assignment_id=new.contract_assignment_id
  ) then
    raise exception 'RHPP Sistem Final belum tersedia.';
  end if;

  new.barn_id:=a.barn_id;
  new.cycle_id:=null;
  return new;
end
$function$;

-- private.my_bms_role()
CREATE OR REPLACE FUNCTION private.my_bms_role()
 RETURNS bms_role
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select role
  from public.profiles
  where user_id = (select auth.uid()) and active
$function$;

-- private.reject_closed_assignment_write()
CREATE OR REPLACE FUNCTION private.reject_closed_assignment_write()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_old uuid;
  v_new uuid;
begin
  if tg_op in ('UPDATE','DELETE') then
    v_old := nullif(to_jsonb(old)->>'contract_assignment_id','')::uuid;
  end if;
  if tg_op in ('UPDATE','INSERT') then
    v_new := nullif(to_jsonb(new)->>'contract_assignment_id','')::uuid;
  end if;

  if exists(
    select 1 from public.logistics_contract_assignments a
    where a.id in (v_old,v_new) and a.active=false
  ) then
    raise exception 'Periode sudah Close. Buka kembali siklus melalui Administrator sebelum mengubah data.';
  end if;

  if tg_op='DELETE' then return old; else return new; end if;
end
$function$;

-- private.reject_closed_logistics_child_write()
CREATE OR REPLACE FUNCTION private.reject_closed_logistics_child_write()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_old_aid uuid;
  v_new_aid uuid;
begin
  if tg_table_name='logistics_shipment_items' then
    if tg_op in ('UPDATE','DELETE') then
      select s.contract_assignment_id into v_old_aid from public.logistics_shipments s where s.id=old.shipment_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select s.contract_assignment_id into v_new_aid from public.logistics_shipments s where s.id=new.shipment_id;
    end if;
  elsif tg_table_name='logistics_return_items' then
    if tg_op in ('UPDATE','DELETE') then
      select r.contract_assignment_id into v_old_aid from public.logistics_returns r where r.id=old.return_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select r.contract_assignment_id into v_new_aid from public.logistics_returns r where r.id=new.return_id;
    end if;
  elsif tg_table_name='logistics_external_shipment_items' then
    if tg_op in ('UPDATE','DELETE') then
      select s.contract_assignment_id into v_old_aid from public.logistics_external_shipments s where s.id=old.external_shipment_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select s.contract_assignment_id into v_new_aid from public.logistics_external_shipments s where s.id=new.external_shipment_id;
    end if;
  elsif tg_table_name='logistics_external_return_items' then
    if tg_op in ('UPDATE','DELETE') then
      select r.contract_assignment_id into v_old_aid from public.logistics_external_returns r where r.id=old.external_return_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select r.contract_assignment_id into v_new_aid from public.logistics_external_returns r where r.id=new.external_return_id;
    end if;
  end if;

  if exists(
    select 1 from public.logistics_contract_assignments a
    where a.id in (v_old_aid,v_new_aid) and a.active=false
  ) then
    raise exception 'Periode sudah Close. Buka kembali siklus melalui Administrator sebelum mengubah detail transaksi.';
  end if;

  if tg_op='DELETE' then return old; else return new; end if;
end
$function$;

-- private.reject_closed_production_child_write()
CREATE OR REPLACE FUNCTION private.reject_closed_production_child_write()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_old_aid uuid;
  v_new_aid uuid;
begin
  if tg_table_name='production_estimate_sizes' then
    if tg_op in ('UPDATE','DELETE') then
      select p.contract_assignment_id into v_old_aid from public.production_estimates p where p.id=old.estimate_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select p.contract_assignment_id into v_new_aid from public.production_estimates p where p.id=new.estimate_id;
    end if;
  elsif tg_table_name='production_abk_result_sizes' then
    if tg_op in ('UPDATE','DELETE') then
      select p.contract_assignment_id into v_old_aid from public.production_abk_results p where p.id=old.result_id;
    end if;
    if tg_op in ('UPDATE','INSERT') then
      select p.contract_assignment_id into v_new_aid from public.production_abk_results p where p.id=new.result_id;
    end if;
  end if;

  if exists(
    select 1 from public.logistics_contract_assignments a
    where a.id in (v_old_aid,v_new_aid) and a.active=false
  ) then
    raise exception 'Periode sudah Close. Buka kembali siklus melalui Administrator sebelum mengubah detail produksi.';
  end if;

  if tg_op='DELETE' then return old; else return new; end if;
end
$function$;

-- private.reject_closed_transfer_write()
CREATE OR REPLACE FUNCTION private.reject_closed_transfer_write()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  os uuid; ot uuid; ns uuid; nt uuid;
begin
  if tg_op in ('UPDATE','DELETE') then
    os:=old.source_contract_assignment_id;
    ot:=old.target_contract_assignment_id;
  end if;
  if tg_op in ('UPDATE','INSERT') then
    ns:=new.source_contract_assignment_id;
    nt:=new.target_contract_assignment_id;
  end if;

  if exists(
    select 1 from public.logistics_contract_assignments a
    where a.id in (os,ot,ns,nt) and a.active=false
  ) then
    raise exception 'Periode sumber/tujuan sudah Close. Buka kembali siklus melalui Administrator sebelum mengubah alih Sapronak.';
  end if;

  if tg_op='DELETE' then return old; else return new; end if;
end
$function$;

-- private.set_cycle_state_impl(p_cycle uuid, p_action text, p_reason text)
CREATE OR REPLACE FUNCTION private.set_cycle_state_impl(p_cycle uuid, p_action text, p_reason text DEFAULT NULL::text)
 RETURNS cycles
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  c public.cycles;
  role_now public.bms_role;
  contract_ok boolean;
  missing text[];
begin
  role_now := private.my_bms_role();

  select * into c
  from public.cycles
  where id=p_cycle
  for update;

  if not found then
    raise exception 'Siklus tidak ditemukan';
  end if;

  if p_action='READY' and role_now='ADMIN' and c.state='ACTIVE' then
    select cr.is_complete, cr.missing_components
      into contract_ok, missing
    from public.contract_readiness cr
    where cr.cycle_id=p_cycle;

    if contract_ok is distinct from true then
      raise exception 'Kontrak belum lengkap: %',
        array_to_string(coalesce(missing,array['Kontrak belum tersedia']::text[]),', ');
    end if;

    if not exists(select 1 from public.chick_ins where cycle_id=p_cycle)
       or not exists(select 1 from public.supplies where cycle_id=p_cycle)
       or not exists(select 1 from public.recordings where cycle_id=p_cycle)
       or not exists(select 1 from public.harvests where cycle_id=p_cycle) then
      raise exception 'Chick-In, sapronak, recording, dan panen wajib tersedia';
    end if;

    update public.cycles
      set state='READY_RHPP',ready_at=now(),bop_complete=false
      where id=p_cycle returning * into c;

  elsif p_action='UNLOCK'
    and role_now='ADMIN'
    and c.state='READY_RHPP'
    and length(trim(coalesce(p_reason,''))) >= 10 then

    if exists(select 1 from public.rhpp_real where cycle_id=p_cycle)
       or exists(select 1 from public.bop where cycle_id=p_cycle) then
      raise exception 'Hapus atau koreksi transaksi keuangan melalui proses revisi sebelum membuka kunci';
    end if;

    update public.cycles
      set state='ACTIVE',ready_at=null,bop_complete=false
      where id=p_cycle returning * into c;

  elsif p_action='BOP_COMPLETE'
    and role_now in ('ADMIN','KEUANGAN')
    and c.state='READY_RHPP' then

    update public.cycles
      set bop_complete=true
      where id=p_cycle returning * into c;

  elsif p_action='CLOSE'
    and role_now in ('ADMIN','KEUANGAN')
    and c.state='READY_RHPP'
    and c.bop_complete
    and exists(select 1 from public.rhpp_real where cycle_id=p_cycle) then

    update public.cycles
      set state='CLOSED',closed_at=now()
      where id=p_cycle returning * into c;

  else
    raise exception 'Aksi ditolak: role, status, alasan, atau syarat belum sesuai';
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(
    auth.uid(),p_action,'cycles',p_cycle::text,
    jsonb_build_object('reason',p_reason,'state',c.state)
  );

  return c;
end
$function$;

-- private.sync_bop_assignment_barn()
CREATE OR REPLACE FUNCTION private.sync_bop_assignment_barn()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_barn uuid;
begin
  if new.contract_assignment_id is null then
    raise exception 'Kandang / periode wajib dipilih.';
  end if;

  select a.barn_id into v_barn
  from public.logistics_contract_assignments a
  where a.id=new.contract_assignment_id;

  if v_barn is null then
    raise exception 'Kandang / periode tidak ditemukan.';
  end if;

  new.barn_id := v_barn;
  new.cycle_id := null;
  return new;
end
$function$;

-- private.validate_assignment_ppl()
CREATE OR REPLACE FUNCTION private.validate_assignment_ppl()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if new.ppl_id is not null and not exists (
    select 1
    from public.profiles p
    where p.user_id=new.ppl_id
      and p.active=true
      and p.role='PPL'::public.bms_role
  ) then
    raise exception 'PPL penanggung jawab harus akun PPL aktif.';
  end if;
  return new;
end;
$function$;

-- public.admin_close_production_atomic(p_contract_assignment_id uuid)
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

-- public.admin_list_bms_users()
CREATE OR REPLACE FUNCTION public.admin_list_bms_users()
 RETURNS TABLE(user_id uuid, email text, full_name text, role bms_role, active boolean, email_confirmed boolean)
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select * from private.admin_list_bms_users_impl()
$function$;

-- public.admin_reopen_production_atomic(p_contract_assignment_id uuid)
CREATE OR REPLACE FUNCTION public.admin_reopen_production_atomic(p_contract_assignment_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_active boolean;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active and p.role='ADMIN'
  ) then
    raise exception 'Akses ditolak. Hanya Administrator yang dapat membuka kembali siklus.';
  end if;

  select a.active into v_active
  from public.logistics_contract_assignments a
  where a.id=p_contract_assignment_id
  for update;

  if v_active is null then
    raise exception 'Siklus tidak ditemukan.';
  end if;

  if v_active then
    raise exception 'Siklus ini sudah aktif.';
  end if;

  perform set_config('bms.allow_production_reopen','1',true);

  update public.logistics_contract_assignments
  set active=true
  where id=p_contract_assignment_id;

  delete from public.rhpp_system_final
  where contract_assignment_id=p_contract_assignment_id;

  return p_contract_assignment_id;
end
$function$;

-- public.admin_update_bms_user(p_user_id uuid, p_name text, p_role bms_role, p_active boolean)
CREATE OR REPLACE FUNCTION public.admin_update_bms_user(p_user_id uuid, p_name text, p_role bms_role, p_active boolean)
 RETURNS void
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select private.admin_update_bms_user_impl(p_user_id,p_name,p_role,p_active)
$function$;

-- public.assign_barn_code()
CREATE OR REPLACE FUNCTION public.assign_barn_code()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.code is null or btrim(new.code) = '' then
    loop
      new.code := 'KD-' || lpad(nextval('public.barn_code_seq')::text,3,'0');
      exit when not exists(select 1 from public.barns where code=new.code);
    end loop;
  end if;
  return new;
end
$function$;

-- public.assign_bms_role(p_email text, p_role bms_role, p_name text)
CREATE OR REPLACE FUNCTION public.assign_bms_role(p_email text, p_role bms_role, p_name text)
 RETURNS uuid
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select private.assign_bms_role_impl(p_email,p_role,p_name)
$function$;

-- public.assign_master_auto_code()
CREATE OR REPLACE FUNCTION public.assign_master_auto_code()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  prefix text;
  seq regclass;
begin
  case TG_TABLE_NAME
    when 'barns' then
      prefix := 'KD-';
      seq := 'public.barn_code_seq'::regclass;
    when 'cycles' then
      prefix := 'SK-';
      seq := 'public.cycle_code_seq'::regclass;
    when 'items' then
      prefix := 'SP-';
      seq := 'public.item_code_seq'::regclass;
    when 'employees' then
      if new.kind='ABK' then
        prefix := 'ABK-';
        seq := 'public.abk_code_seq'::regclass;
      else
        prefix := 'KY-';
        seq := 'public.employee_code_seq'::regclass;
      end if;
    else
      raise exception 'Tabel tidak didukung untuk kode otomatis: %', TG_TABLE_NAME;
  end case;

  loop
    new.code := prefix || lpad(nextval(seq)::text,3,'0');

    exit when not exists (
      select 1 from public.barns b
      where TG_TABLE_NAME='barns' and b.code=new.code
    )
    and not exists (
      select 1 from public.cycles c
      where TG_TABLE_NAME='cycles' and c.code=new.code
    )
    and not exists (
      select 1 from public.items i
      where TG_TABLE_NAME='items' and i.code=new.code
    )
    and not exists (
      select 1 from public.employees e
      where TG_TABLE_NAME='employees' and e.code=new.code
    );
  end loop;

  return new;
end
$function$;

-- public.assign_supplier_code()
CREATE OR REPLACE FUNCTION public.assign_supplier_code()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.code is null or btrim(new.code)='' then
    loop
      new.code := 'SUP-' || lpad(nextval('public.supplier_code_seq')::text,3,'0');
      exit when not exists(select 1 from public.suppliers s where s.code=new.code);
    end loop;
  end if;
  return new;
end
$function$;

-- public.audit_and_guard()
CREATE OR REPLACE FUNCTION public.audit_and_guard()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  cid uuid;
  state_now public.cycle_state;
  rid text;
begin
  cid := case when TG_OP = 'DELETE' then old.cycle_id else new.cycle_id end;

  if not (TG_TABLE_NAME = 'contracts' and cid is null) then
    select state into state_now
    from public.cycles
    where id = cid
    for update;

    if state_now is null then
      raise exception 'Siklus tidak ditemukan';
    end if;

    if TG_TABLE_NAME in ('rhpp_real','bop') then
      if state_now = 'CLOSED'
         or (TG_TABLE_NAME = 'rhpp_real' and state_now <> 'READY_RHPP') then
        raise exception 'Transaksi keuangan terkunci';
      end if;
    elsif state_now <> 'ACTIVE' then
      raise exception 'Transaksi operasional terkunci';
    end if;
  end if;

  if TG_TABLE_NAME = 'rhpp_real' then
    rid := cid::text;
  elsif TG_OP = 'DELETE' then
    rid := old.id::text;
  else
    rid := new.id::text;
  end if;

  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    rid,
    case when TG_OP in ('UPDATE','DELETE') then to_jsonb(old) end,
    case when TG_OP in ('INSERT','UPDATE') then to_jsonb(new) end
  );

  if TG_OP = 'DELETE' then
    return old;
  end if;
  return new;
end
$function$;

-- public.audit_master_change()
CREATE OR REPLACE FUNCTION public.audit_master_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.audit_events(actor,action,table_name,record_id,old_data,new_data)
  values(auth.uid(),TG_OP,TG_TABLE_NAME,
    case when TG_OP='DELETE' then old.id::text else new.id::text end,
    case when TG_OP in ('UPDATE','DELETE') then to_jsonb(old) end,
    case when TG_OP in ('INSERT','UPDATE') then to_jsonb(new) end);
  if TG_OP='DELETE' then return old; end if;
  return new;
end $function$;

-- public.autofill_logistics_return_price()
CREATE OR REPLACE FUNCTION public.autofill_logistics_return_price()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_category text;
  v_phase text;
  v_kg numeric;
  v_doc numeric;
  v_pre numeric;
  v_start numeric;
  v_finish numeric;
  v_ovk_basis text;
  v_ovk numeric;
begin
  select i.category::text,coalesce(i.feed_phase,''),coalesce(i.kg_per_unit,50)
    into v_category,v_phase,v_kg
  from public.items i
  where i.id=new.item_id;

  select c.doc_price,c.pre_starter_price,c.starter_price,c.finisher_price,
         c.ovk_price_basis::text,c.ovk_price
    into v_doc,v_pre,v_start,v_finish,v_ovk_basis,v_ovk
  from public.logistics_returns r
  join public.logistics_contract_assignments a on a.id=r.contract_assignment_id
  join public.contracts c on c.id=a.master_contract_id
  where r.id=new.return_id;

  if v_category='DOC' then
    new.unit_price:=v_doc;
  elsif v_category='PAKAN' then
    if lower(v_phase) like '%pre%' then
      new.unit_price:=v_pre*v_kg;
    elsif lower(v_phase) like '%fin%' then
      new.unit_price:=v_finish*v_kg;
    elsif lower(v_phase) like '%starter%' then
      new.unit_price:=v_start*v_kg;
    else
      raise exception 'Fase pakan belum dipetakan ke harga kontrak.';
    end if;
  elsif v_category='OVK' and v_ovk_basis='FIXED' then
    new.unit_price:=v_ovk;
  end if;

  return new;
end
$function$;

-- public.autofill_logistics_shipment_price()
CREATE OR REPLACE FUNCTION public.autofill_logistics_shipment_price()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_category text;
  v_phase text;
  v_kg numeric;
  v_doc numeric;
  v_pre numeric;
  v_start numeric;
  v_finish numeric;
  v_ovk_basis text;
  v_ovk numeric;
begin
  select i.category::text,coalesce(i.feed_phase,''),coalesce(i.kg_per_unit,50)
    into v_category,v_phase,v_kg
  from public.items i
  where i.id=new.item_id;

  select c.doc_price,c.pre_starter_price,c.starter_price,c.finisher_price,
         c.ovk_price_basis::text,c.ovk_price
    into v_doc,v_pre,v_start,v_finish,v_ovk_basis,v_ovk
  from public.logistics_shipments s
  join public.logistics_contract_assignments a on a.id=s.contract_assignment_id
  join public.contracts c on c.id=a.master_contract_id
  where s.id=new.shipment_id;

  if v_category='DOC' then
    new.unit_price:=v_doc;
  elsif v_category='PAKAN' then
    if lower(v_phase) like '%pre%' then
      new.unit_price:=v_pre*v_kg;
    elsif lower(v_phase) like '%fin%' then
      new.unit_price:=v_finish*v_kg;
    elsif lower(v_phase) like '%starter%' then
      new.unit_price:=v_start*v_kg;
    else
      raise exception 'Fase pakan belum dipetakan ke harga kontrak.';
    end if;
  elsif v_category='OVK' and v_ovk_basis='FIXED' then
    new.unit_price:=v_ovk;
  end if;

  return new;
end
$function$;

-- public.bind_master_contract_to_cycle(p_master_contract_id uuid, p_cycle_id uuid)
CREATE OR REPLACE FUNCTION public.bind_master_contract_to_cycle(p_master_contract_id uuid, p_cycle_id uuid)
 RETURNS uuid
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select private.bind_master_contract_to_cycle_core(p_master_contract_id,p_cycle_id)
$function$;

-- public.bms_backup_download_payload(p_token text)
CREATE OR REPLACE FUNCTION public.bms_backup_download_payload(p_token text)
 RETURNS TABLE(backup_date date, payload jsonb, checksum text, expires_at timestamp with time zone)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public', 'bms_backup'
AS $function$
  select s.backup_date, s.payload, s.checksum, t.expires_at
  from bms_backup.download_tokens t
  join bms_backup.daily_snapshots s on s.backup_date=t.backup_date
  where t.token=p_token
    and t.expires_at > now()
  limit 1;
$function$;

-- public.check_advance_payment()
CREATE OR REPLACE FUNCTION public.check_advance_payment()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare limit_amount numeric; total_paid numeric;
begin
  select amount into limit_amount from public.advances where id=new.advance_id for update;
  select coalesce(sum(amount),0) into total_paid from public.advance_payments where advance_id=new.advance_id;
  if total_paid+new.amount > limit_amount then raise exception 'Pembayaran melebihi sisa kasbon'; end if;
  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),'PAY_ADVANCE','advance_payments',new.id::text,to_jsonb(new));
  return new;
end $function$;

-- public.compute_chickin_avg_weight()
CREATE OR REPLACE FUNCTION public.compute_chickin_avg_weight()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.sample_count is not null and new.sample_count > 0
     and new.sample_weight_total_g is not null then
    new.avg_weight := round(new.sample_weight_total_g / new.sample_count, 2);
  elsif new.sample_count is not null or new.sample_weight_total_g is not null then
    new.avg_weight := null;
  end if;
  return new;
end
$function$;

-- public.compute_recording_avg_weight()
CREATE OR REPLACE FUNCTION public.compute_recording_avg_weight()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.sample_count is not null and new.sample_count > 0
     and new.sample_weight_total_kg is not null then
    new.avg_weight_kg := round(new.sample_weight_total_kg / new.sample_count, 2);
  elsif new.sample_count is not null or new.sample_weight_total_kg is not null then
    new.avg_weight_kg := null;
  end if;
  return new;
end
$function$;

-- public.compute_recording_feed_kg()
CREATE OR REPLACE FUNCTION public.compute_recording_feed_kg()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  cat text;
  kg_unit numeric;
begin
  if new.feed_item_id is not null and new.feed_bags_out is not null then
    select category,kg_per_unit
      into cat,kg_unit
    from public.items
    where id=new.feed_item_id;

    if cat='PAKAN' then
      new.feed_kg := round(new.feed_bags_out * coalesce(kg_unit,50),2);
    end if;
  end if;
  return new;
end
$function$;

-- public.compute_supply_quantity_kg()
CREATE OR REPLACE FUNCTION public.compute_supply_quantity_kg()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  cat text;
  kg_unit numeric;
begin
  select category,kg_per_unit
    into cat,kg_unit
  from public.items
  where id=new.item_id;

  if cat='PAKAN' then
    new.quantity_kg := round(new.quantity * coalesce(kg_unit,50),2);
  else
    new.quantity_kg := null;
  end if;
  return new;
end
$function$;

-- public.delete_production_abk_harvest_atomic(p_size_id uuid)
CREATE OR REPLACE FUNCTION public.delete_production_abk_harvest_atomic(p_size_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_result_id uuid;
  v_assignment_id uuid;
begin
  select s.result_id,r.contract_assignment_id
    into v_result_id,v_assignment_id
  from public.production_abk_result_sizes s
  join public.production_abk_results r on r.id=s.result_id
  where s.id=p_size_id
  for update of s,r;

  if v_result_id is null then raise exception 'Transaksi Panen ABK tidak ditemukan.'; end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=v_assignment_id and a.active=true
  ) then
    raise exception 'Kontrak kandang sudah Close. Data terkunci.';
  end if;

  delete from public.production_abk_result_sizes where id=p_size_id;

  if exists (select 1 from public.production_abk_result_sizes s where s.result_id=v_result_id) then
    update public.production_abk_results
       set harvest_date=(select max(s.harvest_date) from public.production_abk_result_sizes s where s.result_id=v_result_id),
           updated_at=now()
     where id=v_result_id;
  else
    delete from public.production_abk_results where id=v_result_id;
  end if;

  return v_result_id;
end
$function$;

-- public.fill_external_shipment_quantity_kg()
CREATE OR REPLACE FUNCTION public.fill_external_shipment_quantity_kg()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  kg numeric;
begin
  select kg_per_unit into kg from public.items where id=new.item_id;
  if kg is not null then new.quantity_kg := new.quantity * kg;
  else new.quantity_kg := null;
  end if;
  return new;
end
$function$;

-- public.finance_auto_reference_trigger()
CREATE OR REPLACE FUNCTION public.finance_auto_reference_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_date date;
  v_ref text;
begin
  if coalesce(nullif(trim(to_jsonb(NEW)->>'reference'),''),'')<>'' then
    return NEW;
  end if;

  v_date:=coalesce((to_jsonb(NEW)->>TG_ARGV[1])::date,current_date);
  v_ref:=public.finance_next_reference(TG_ARGV[0],v_date);
  NEW:=jsonb_populate_record(NEW,jsonb_build_object('reference',v_ref));
  return NEW;
end
$function$;

-- public.finance_cashflow_entries_v1()
CREATE OR REPLACE FUNCTION public.finance_cashflow_entries_v1()
 RETURNS TABLE(txn_date date, txn_type text, source text, amount numeric, barn_id uuid, contract_assignment_id uuid, detail text, reference text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  select r.received_on,'MASUK'::text,'RHPP REAL'::text,r.amount,r.barn_id,r.contract_assignment_id,
         'RHPP Real dari perusahaan inti'::text,coalesce(r.reference,'')
  from public.rhpp_real r

  union all
  select b.incurred_on,'KELUAR','BOP KANDANG',b.amount,b.barn_id,b.contract_assignment_id,
         replace(b.category,'_',' '),coalesce(b.reference,'')
  from public.bop b
  where coalesce(b.source_type,'')<>'ABK_SALARY'

  union all
  select b.incurred_on,'KELUAR','BOP UMUM',b.amount,null::uuid,null::uuid,
         replace(b.category,'_',' '),coalesce(b.reference,'')
  from public.bop_outside b

  union all
  select a.advanced_on,'KELUAR','KASBON',a.amount,a.barn_id,a.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name,coalesce(a.reference,'')
  from public.advances a
  join public.employees e on e.id=a.employee_id

  union all
  select p.paid_on,'MASUK','CICILAN KASBON',p.amount,a.barn_id,a.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name||' · '||p.method,coalesce(p.reference,'')
  from public.advance_payments p
  join public.advances a on a.id=p.advance_id
  join public.employees e on e.id=a.employee_id
  where p.method<>'POTONG_GAJI'

  union all
  select s.paid_on,'KELUAR','GAJI ABK',s.net_paid,s.barn_id,s.contract_assignment_id,
         coalesce(e.code||' · ','')||e.name||' · Gaji bersih',coalesce(s.reference,'')
  from public.abk_cycle_salaries s
  join public.employees e on e.id=s.abk_id
  where s.net_paid>0

  union all
  select h.shipment_date,'KELUAR','SAPRONAK LUAR',
         sum(i.quantity*i.purchase_unit_price),h.barn_id,h.contract_assignment_id,
         'Pembelian sapronak luar',coalesce(h.reference_number,'')
  from public.logistics_external_shipments h
  join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
  group by h.id,h.shipment_date,h.barn_id,h.contract_assignment_id,h.reference_number

  union all
  select m.purchase_date,'KELUAR','TAMBAH DAGING',
         m.weight_kg*m.purchase_price_per_kg,m.barn_id,m.contract_assignment_id,
         coalesce(m.product_name,'Tambah Daging'),coalesce(m.reference_number,'')
  from public.marketing_external_meat_purchases m

  union all
  select p.paid_on,'MASUK','PENDAPATAN EXPEDISI',p.amount,null::uuid,null::uuid,
         i.invoice_number||' · '||i.customer_name,coalesce(p.reference,'')
  from public.finance_expedition_payments p
  join public.finance_expedition_invoices i on i.id=p.invoice_id

  union all
  select b.incurred_on,'KELUAR','BOP EXPEDISI',b.amount,null::uuid,null::uuid,
         replace(b.category,'_',' ')||
         case when nullif(b.vehicle,'') is not null then ' · '||b.vehicle else '' end,
         coalesce(b.reference,'')
  from public.finance_expedition_bop b;
end
$function$;

-- public.finance_company_profit_loss_v1()
CREATE OR REPLACE FUNCTION public.finance_company_profit_loss_v1()
 RETURNS TABLE(kandang_profit_loss numeric, expedition_revenue numeric, expedition_bop numeric, expedition_profit_loss numeric, bop_umum numeric, company_profit_loss numeric)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
  with k as (
    select coalesce(sum(laba_rugi_real),0)::numeric amount
    from public.finance_cycle_profit_loss_v1()
  ),
  e as (
    select * from public.finance_expedition_profit_loss_v1()
  ),
  u as (
    select coalesce(sum(amount),0)::numeric amount from public.bop_outside
  )
  select
    k.amount,
    e.expedition_revenue,
    e.expedition_bop,
    e.expedition_profit_loss,
    u.amount,
    k.amount+e.expedition_profit_loss-u.amount
  from k,e,u;
$function$;

-- public.finance_create_expedition_invoice_atomic(p_invoice_number text, p_invoice_date date, p_due_date date, p_customer_name text, p_customer_address text, p_trip_ids uuid[], p_notes text)
CREATE OR REPLACE FUNCTION public.finance_create_expedition_invoice_atomic(p_invoice_number text, p_invoice_date date, p_due_date date, p_customer_name text, p_customer_address text, p_trip_ids uuid[], p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  v_trip uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','LOGISTIK')
  ) then raise exception 'Akses ditolak.'; end if;

  if nullif(trim(p_invoice_number),'') is null then raise exception 'Nomor invoice wajib diisi.'; end if;
  if p_invoice_date is null then raise exception 'Tanggal invoice wajib diisi.'; end if;
  if nullif(trim(p_customer_name),'') is null then raise exception 'Pelanggan wajib diisi.'; end if;
  if p_trip_ids is null or cardinality(p_trip_ids)=0 then raise exception 'Pilih minimal satu trip.'; end if;

  if exists (
    select 1
    from unnest(p_trip_ids) x(id)
    left join public.finance_expedition_trips t on t.id=x.id
    where t.id is null
  ) then raise exception 'Ada trip yang tidak ditemukan.'; end if;

  if exists (
    select 1
    from public.finance_expedition_invoice_items ii
    where ii.trip_id=any(p_trip_ids)
  ) then raise exception 'Ada trip yang sudah masuk invoice lain.'; end if;

  insert into public.finance_expedition_invoices(
    invoice_number,invoice_date,due_date,customer_name,customer_address,status,notes
  ) values (
    trim(p_invoice_number),p_invoice_date,p_due_date,trim(p_customer_name),
    nullif(trim(p_customer_address),''),'ISSUED',nullif(trim(p_notes),'')
  )
  returning id into v_id;

  foreach v_trip in array p_trip_ids loop
    insert into public.finance_expedition_invoice_items(invoice_id,trip_id)
    values(v_id,v_trip);
  end loop;

  return v_id;
end
$function$;

-- public.finance_cycle_profit_loss_v1()
CREATE OR REPLACE FUNCTION public.finance_cycle_profit_loss_v1()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, start_date date, active boolean, rhpp_system numeric, rhpp_real numeric, bop_kandang numeric, gaji_abk numeric, sapronak_luar numeric, tambah_daging numeric, kasbon_abk numeric, saldo_kasbon numeric, laba_rugi_real numeric)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with bopx as (
    select b.contract_assignment_id,
      coalesce(sum(b.amount),0)::numeric bop,
      coalesce(sum(case when b.source_type='ABK_SALARY' then b.amount else 0 end),0)::numeric salary
    from public.bop b
    group by b.contract_assignment_id
  ),
  ext_ship as (
    select h.contract_assignment_id,
      coalesce(sum(i.quantity*i.purchase_unit_price),0)::numeric amount
    from public.logistics_external_shipments h
    join public.logistics_external_shipment_items i on i.external_shipment_id=h.id
    group by h.contract_assignment_id
  ),
  ext_out as (
    select t.source_contract_assignment_id contract_assignment_id,
      coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t
    group by t.source_contract_assignment_id
  ),
  ext_in as (
    select t.target_contract_assignment_id contract_assignment_id,
      coalesce(sum(t.quantity*t.unit_price),0)::numeric amount
    from public.logistics_external_return_transfers t
    group by t.target_contract_assignment_id
  ),
  meat as (
    select m.contract_assignment_id,
      coalesce(sum(m.weight_kg*m.purchase_price_per_kg),0)::numeric amount
    from public.marketing_external_meat_purchases m
    group by m.contract_assignment_id
  ),
  adv as (
    select a.contract_assignment_id,
      coalesce(sum(a.amount),0)::numeric amount,
      coalesce(sum(a.amount-coalesce(p.paid,0)),0)::numeric balance
    from public.advances a
    left join (
      select advance_id,sum(amount) paid
      from public.advance_payments
      group by advance_id
    ) p on p.advance_id=a.id
    where a.contract_assignment_id is not null
    group by a.contract_assignment_id
  )
  select
    a.id,a.barn_id,b.code,b.name,a.start_date,a.active,
    coalesce(sf.system_amount,0)::numeric,
    coalesce(rr.amount,0)::numeric,
    coalesce(bx.bop,0)::numeric,
    coalesce(bx.salary,0)::numeric,
    greatest(0,coalesce(es.amount,0)-coalesce(eo.amount,0)+coalesce(ei.amount,0))::numeric,
    coalesce(m.amount,0)::numeric,
    coalesce(ad.amount,0)::numeric,
    coalesce(ad.balance,0)::numeric,
    (
      coalesce(rr.amount,0)
      - coalesce(bx.bop,0)
      - greatest(0,coalesce(es.amount,0)-coalesce(eo.amount,0)+coalesce(ei.amount,0))
      - coalesce(m.amount,0)
    )::numeric
  from public.logistics_contract_assignments a
  join public.barns b on b.id=a.barn_id
  left join public.rhpp_system_final sf on sf.contract_assignment_id=a.id
  left join public.rhpp_real rr on rr.contract_assignment_id=a.id
  left join bopx bx on bx.contract_assignment_id=a.id
  left join ext_ship es on es.contract_assignment_id=a.id
  left join ext_out eo on eo.contract_assignment_id=a.id
  left join ext_in ei on ei.contract_assignment_id=a.id
  left join meat m on m.contract_assignment_id=a.id
  left join adv ad on ad.contract_assignment_id=a.id
  order by a.start_date desc,b.code;
end
$function$;

-- public.finance_expedition_profit_loss_v1()
CREATE OR REPLACE FUNCTION public.finance_expedition_profit_loss_v1()
 RETURNS TABLE(expedition_revenue numeric, expedition_bop numeric, expedition_profit_loss numeric, expedition_cash_received numeric, expedition_receivable numeric)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
  with revenue as (
    select coalesce(sum(t.trip_price+t.additional-t.deduction),0)::numeric amount
    from public.finance_expedition_invoices i
    join public.finance_expedition_invoice_items ii on ii.invoice_id=i.id
    join public.finance_expedition_trips t on t.id=ii.trip_id
    where i.status in ('ISSUED','PAID')
  ),
  bop as (
    select coalesce(sum(amount),0)::numeric amount
    from public.finance_expedition_bop
  ),
  paid as (
    select coalesce(sum(amount),0)::numeric amount
    from public.finance_expedition_payments
  )
  select
    revenue.amount,
    bop.amount,
    revenue.amount-bop.amount,
    paid.amount,
    greatest(revenue.amount-paid.amount,0::numeric)
  from revenue,bop,paid
  where private.my_bms_role() in ('ADMIN'::public.bms_role,'KEUANGAN'::public.bms_role,'OWNER'::public.bms_role);
$function$;

-- public.finance_expedition_summary_v1()
CREATE OR REPLACE FUNCTION public.finance_expedition_summary_v1()
 RETURNS TABLE(invoice_id uuid, invoice_number text, invoice_date date, due_date date, customer_name text, status text, invoice_total numeric, paid_total numeric, receivable numeric)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select
    i.id,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.customer_name,
    i.status,
    coalesce(sum(t.trip_price+t.additional-t.deduction),0)::numeric as invoice_total,
    coalesce(p.paid_total,0)::numeric as paid_total,
    (coalesce(sum(t.trip_price+t.additional-t.deduction),0)-coalesce(p.paid_total,0))::numeric as receivable
  from public.finance_expedition_invoices i
  left join public.finance_expedition_invoice_items ii on ii.invoice_id=i.id
  left join public.finance_expedition_trips t on t.id=ii.trip_id
  left join (
    select invoice_id,sum(amount) paid_total
    from public.finance_expedition_payments
    group by invoice_id
  ) p on p.invoice_id=i.id
  where private.my_bms_role() in (
    'ADMIN'::public.bms_role,
    'LOGISTIK'::public.bms_role,
    'KEUANGAN'::public.bms_role,
    'OWNER'::public.bms_role
  )
  group by i.id,i.invoice_number,i.invoice_date,i.due_date,i.customer_name,i.status,p.paid_total
  order by i.invoice_date desc,i.created_at desc;
$function$;

-- public.finance_next_reference(p_prefix text, p_date date)
CREATE OR REPLACE FUNCTION public.finance_next_reference(p_prefix text, p_date date)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_no integer;
  v_date date:=coalesce(p_date,current_date);
begin
  insert into public.finance_reference_counters(prefix,ref_date,last_no)
  values(upper(trim(p_prefix)),v_date,1)
  on conflict(prefix,ref_date)
  do update set last_no=public.finance_reference_counters.last_no+1
  returning last_no into v_no;

  return upper(trim(p_prefix))||'-'||to_char(v_date,'YYYYMMDD')||'-'||lpad(v_no::text,4,'0');
end
$function$;

-- public.finance_rhpp_summary()
CREATE OR REPLACE FUNCTION public.finance_rhpp_summary()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, sapronak_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, ready_financial boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1
    from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','KEUANGAN','OWNER')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  return query
  with harvest as (
    select
      h.contract_assignment_id,
      sum(h.birds)::numeric as birds,
      sum(h.net_weight_kg)::numeric as kg,
      sum(h.total_amount)::numeric as value,
      sum(h.birds * ((h.harvested_on-ci.arrived_on)+1))::numeric
        / nullif(sum(h.birds),0) as weighted_age
    from public.marketing_contract_harvests h
    join public.chick_ins ci on ci.contract_assignment_id=h.contract_assignment_id
    group by h.contract_assignment_id
  ),
  feed_ship as (
    select s.contract_assignment_id,coalesce(sum(li.quantity_kg),0)::numeric as kg
    from public.logistics_shipments s
    join public.logistics_shipment_items li on li.shipment_id=s.id
    join public.items i on i.id=li.item_id
    where i.category='PAKAN'
    group by s.contract_assignment_id
  ),
  feed_ret as (
    select r.contract_assignment_id,coalesce(sum(li.quantity_kg),0)::numeric as kg
    from public.logistics_returns r
    join public.logistics_return_items li on li.return_id=r.id
    join public.items i on i.id=li.item_id
    where i.category='PAKAN'
    group by r.contract_assignment_id
  ),
  rec_dep as (
    select r.contract_assignment_id,
           coalesce(sum(r.mortality+r.culling),0)::numeric as birds
    from public.recordings r
    group by r.contract_assignment_id
  ),
  raw as (
    select
      a.id as assignment_id,
      a.barn_id,
      b.code as barn_code,
      b.name as barn_name,
      c.number as contract_number,
      a.active,
      (ci.received-ci.doa)::numeric as chick_in_birds,
      coalesce(h.birds,0)::numeric as total_harvest_birds,
      coalesce(h.kg,0)::numeric as total_harvest_kg,
      case when coalesce(h.birds,0)>0 then h.kg/h.birds else 0 end::numeric as avg_bw_kg,
      coalesce(h.weighted_age,0)::numeric as weighted_age,
      ((ci.received-ci.doa)-coalesce(h.birds,0))::numeric as implied_depletion_birds,
      coalesce(rd.birds,0)::numeric as recorded_depletion_birds,
      (((ci.received-ci.doa)-coalesce(h.birds,0))-coalesce(rd.birds,0))::numeric as depletion_variance_birds,
      case when (ci.received-ci.doa)>0
        then (((ci.received-ci.doa)-coalesce(h.birds,0))::numeric/(ci.received-ci.doa))*100
        else 0 end::numeric as mortality_pct,
      greatest(0,coalesce(fs.kg,0)-coalesce(fr.kg,0))::numeric as net_feed_kg,
      coalesce(h.value,0)::numeric as harvest_value,
      coalesce(cs.net_sapronak_cost,0)::numeric as sapronak_cost,
      a.master_contract_id,
      a.performance_template_name
    from public.logistics_contract_assignments a
    join public.barns b on b.id=a.barn_id
    join public.contracts c on c.id=a.master_contract_id
    join public.chick_ins ci on ci.contract_assignment_id=a.id
    left join harvest h on h.contract_assignment_id=a.id
    left join feed_ship fs on fs.contract_assignment_id=a.id
    left join feed_ret fr on fr.contract_assignment_id=a.id
    left join rec_dep rd on rd.contract_assignment_id=a.id
    left join public.logistics_rhpp_cost_summary cs on cs.contract_assignment_id=a.id
  ),
  metrics as (
    select
      r.*,
      case when r.total_harvest_kg>0 then r.net_feed_kg/r.total_harvest_kg else 0 end::numeric as fcr_actual,
      lo.age_days as lo_age,lo.std_fcr as lo_fcr,
      hi.age_days as hi_age,hi.std_fcr as hi_fcr
    from raw r
    left join lateral (
      select ps.age_days,ps.std_fcr
      from public.performance_standards ps
      where ps.contract_id=r.master_contract_id
        and ps.template_name=r.performance_template_name
        and ps.age_days<=r.weighted_age
      order by ps.age_days desc
      limit 1
    ) lo on true
    left join lateral (
      select ps.age_days,ps.std_fcr
      from public.performance_standards ps
      where ps.contract_id=r.master_contract_id
        and ps.template_name=r.performance_template_name
        and ps.age_days>=r.weighted_age
      order by ps.age_days asc
      limit 1
    ) hi on true
  ),
  scored as (
    select
      m.*,
      case
        when m.lo_fcr is null then m.hi_fcr
        when m.hi_fcr is null then m.lo_fcr
        when m.hi_age=m.lo_age then m.lo_fcr
        else m.lo_fcr + ((m.weighted_age-m.lo_age)/(m.hi_age-m.lo_age))*(m.hi_fcr-m.lo_fcr)
      end::numeric as fcr_standard,
      case
        when m.weighted_age>0 and m.fcr_actual>0 then
          ((100-m.mortality_pct)*m.avg_bw_kg*100)/(m.weighted_age*m.fcr_actual)
        else 0
      end::numeric as ip
    from metrics m
  ),
  bonus_rates as (
    select
      s.*,
      coalesce(ipb.rupiah_per_kg,0)::numeric as bonus_ip_rate,
      coalesce(fcb.rupiah_per_kg,0)::numeric as bonus_fc_rate
    from scored s
    left join lateral (
      select cb.rupiah_per_kg
      from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id
        and cb.metric='IP'
        and (cb.min_value is null or s.ip>=cb.min_value)
        and (cb.max_value is null or s.ip<cb.max_value)
      order by cb.min_value desc nulls last
      limit 1
    ) ipb on true
    left join lateral (
      select cb.rupiah_per_kg
      from public.contract_bonuses cb
      where cb.contract_id=s.master_contract_id
        and cb.metric='FCR_DIFFERENCE'
        and (cb.min_value is null or (s.fcr_standard-s.fcr_actual)>=cb.min_value)
        and (cb.max_value is null or (s.fcr_standard-s.fcr_actual)<cb.max_value)
      order by cb.min_value desc nulls last
      limit 1
    ) fcb on true
  )
  select
    br.assignment_id,
    br.barn_id,
    br.barn_code,
    br.barn_name,
    br.contract_number,
    br.active,
    br.chick_in_birds,
    br.total_harvest_birds,
    br.total_harvest_kg,
    br.avg_bw_kg,
    br.weighted_age,
    br.implied_depletion_birds,
    br.recorded_depletion_birds,
    br.depletion_variance_birds,
    br.mortality_pct,
    br.net_feed_kg,
    br.fcr_actual,
    br.fcr_standard,
    (coalesce(br.fcr_standard,0)-br.fcr_actual)::numeric as diff_fcr,
    br.ip,
    br.harvest_value,
    br.sapronak_cost,
    (br.harvest_value-br.sapronak_cost)::numeric as base_profit,
    br.bonus_ip_rate,
    (br.total_harvest_kg*br.bonus_ip_rate)::numeric as bonus_ip,
    br.bonus_fc_rate,
    (br.total_harvest_kg*br.bonus_fc_rate)::numeric as bonus_fc,
    0::numeric as bonus_mortality,
    (br.harvest_value-br.sapronak_cost
      + br.total_harvest_kg*br.bonus_ip_rate
      + br.total_harvest_kg*br.bonus_fc_rate)::numeric as farmer_profit,
    case when br.chick_in_birds>0 then
      (br.harvest_value-br.sapronak_cost
       + br.total_harvest_kg*br.bonus_ip_rate
       + br.total_harvest_kg*br.bonus_fc_rate)/br.chick_in_birds
      else 0 end::numeric as profit_per_chick_in,
    case when br.total_harvest_birds>0 then
      (br.harvest_value-br.sapronak_cost
       + br.total_harvest_kg*br.bonus_ip_rate
       + br.total_harvest_kg*br.bonus_fc_rate)/br.total_harvest_birds
      else 0 end::numeric as profit_per_harvested_bird,
    (br.chick_in_birds>0 and br.total_harvest_birds>0 and br.total_harvest_kg>0
     and br.net_feed_kg>0 and br.sapronak_cost>0)::boolean as ready_financial
  from bonus_rates br
  order by br.active desc,br.barn_code;
end
$function$;

-- public.finance_rhpp_summary_v2()
CREATE OR REPLACE FUNCTION public.finance_rhpp_summary_v2()
 RETURNS TABLE(contract_assignment_id uuid, barn_id uuid, barn_code text, barn_name text, contract_number text, active boolean, chick_in_birds numeric, total_harvest_birds numeric, total_harvest_kg numeric, avg_bw_kg numeric, weighted_age numeric, implied_depletion_birds numeric, recorded_depletion_birds numeric, depletion_variance_birds numeric, mortality_pct numeric, net_feed_kg numeric, fcr_actual numeric, fcr_standard numeric, diff_fcr numeric, ip numeric, harvest_value numeric, sapronak_cost numeric, external_meat_cost numeric, total_rhpp_cost numeric, base_profit numeric, bonus_ip_rate numeric, bonus_ip numeric, bonus_fc_rate numeric, bonus_fc numeric, bonus_mortality numeric, farmer_profit numeric, profit_per_chick_in numeric, profit_per_harvested_bird numeric, ready_financial boolean)
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  with base as (
    select * from public.finance_rhpp_summary()
  ),
  meat as (
    select
      m.contract_assignment_id,
      coalesce(sum(m.weight_kg * m.purchase_price_per_kg),0)::numeric as external_meat_cost
    from public.marketing_external_meat_purchases m
    group by m.contract_assignment_id
  )
  select
    b.contract_assignment_id,
    b.barn_id,
    b.barn_code,
    b.barn_name,
    b.contract_number,
    b.active,
    b.chick_in_birds,
    b.total_harvest_birds,
    b.total_harvest_kg,
    b.avg_bw_kg,
    b.weighted_age,
    b.implied_depletion_birds,
    b.recorded_depletion_birds,
    b.depletion_variance_birds,
    b.mortality_pct,
    b.net_feed_kg,
    b.fcr_actual,
    b.fcr_standard,
    b.diff_fcr,
    b.ip,
    b.harvest_value,
    b.sapronak_cost,
    coalesce(m.external_meat_cost,0)::numeric as external_meat_cost,
    (b.sapronak_cost + coalesce(m.external_meat_cost,0))::numeric as total_rhpp_cost,
    (b.harvest_value - b.sapronak_cost - coalesce(m.external_meat_cost,0))::numeric as base_profit,
    b.bonus_ip_rate,
    b.bonus_ip,
    b.bonus_fc_rate,
    b.bonus_fc,
    b.bonus_mortality,
    (b.harvest_value - b.sapronak_cost - coalesce(m.external_meat_cost,0)
      + b.bonus_ip + b.bonus_fc + b.bonus_mortality)::numeric as farmer_profit,
    case when b.chick_in_birds>0 then
      (b.harvest_value - b.sapronak_cost - coalesce(m.external_meat_cost,0)
       + b.bonus_ip + b.bonus_fc + b.bonus_mortality)/b.chick_in_birds
      else 0 end::numeric as profit_per_chick_in,
    case when b.total_harvest_birds>0 then
      (b.harvest_value - b.sapronak_cost - coalesce(m.external_meat_cost,0)
       + b.bonus_ip + b.bonus_fc + b.bonus_mortality)/b.total_harvest_birds
      else 0 end::numeric as profit_per_harvested_bird,
    b.ready_financial
  from base b
  left join meat m on m.contract_assignment_id=b.contract_assignment_id
  order by b.active desc,b.barn_code;
$function$;

-- public.finance_rhpp_summary_v3()
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

-- public.finance_rhpp_summary_v4()
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

-- public.finance_rhpp_summary_v5()
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

-- public.finance_save_abk_advance_atomic(p_contract_assignment_id uuid, p_abk_id uuid, p_advanced_on date, p_amount numeric, p_description text, p_reference text)
CREATE OR REPLACE FUNCTION public.finance_save_abk_advance_atomic(p_contract_assignment_id uuid, p_abk_id uuid, p_advanced_on date, p_amount numeric, p_description text DEFAULT NULL::text, p_reference text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_barn_id uuid;
  v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_amount is null or p_amount<=0 then raise exception 'Nominal kasbon harus lebih dari 0.'; end if;
  if p_advanced_on is null then raise exception 'Tanggal kasbon wajib diisi.'; end if;

  select a.barn_id into v_barn_id
  from public.logistics_contract_assignments a
  where a.id=p_contract_assignment_id;

  if v_barn_id is null then raise exception 'Siklus tidak ditemukan.'; end if;

  if not exists (
    select 1 from public.logistics_contract_assignment_abks l
    join public.employees e on e.id=l.abk_id
    where l.contract_assignment_id=p_contract_assignment_id
      and l.abk_id=p_abk_id
      and e.kind='ABK'
  ) then
    raise exception 'ABK tidak terdaftar pada siklus ini.';
  end if;

  insert into public.advances(
    employee_id,advanced_on,amount,description,reference,
    contract_assignment_id,barn_id
  ) values (
    p_abk_id,p_advanced_on,p_amount,
    nullif(trim(p_description),''),
    nullif(trim(p_reference),''),
    p_contract_assignment_id,v_barn_id
  )
  returning id into v_id;

  return v_id;
end
$function$;

-- public.finance_save_abk_salary_atomic(p_contract_assignment_id uuid, p_abk_id uuid, p_gross_salary numeric, p_advance_deduction numeric, p_paid_on date, p_reference text, p_notes text)
CREATE OR REPLACE FUNCTION public.finance_save_abk_salary_atomic(p_contract_assignment_id uuid, p_abk_id uuid, p_gross_salary numeric, p_advance_deduction numeric, p_paid_on date, p_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_barn_id uuid;
  v_salary_id uuid;
  v_remaining numeric;
  v_balance numeric;
  v_take numeric;
  v_adv record;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_gross_salary is null or p_gross_salary<0 then raise exception 'Gaji bruto tidak valid.'; end if;
  if p_advance_deduction is null or p_advance_deduction<0 then raise exception 'Potongan kasbon tidak valid.'; end if;
  if p_advance_deduction>p_gross_salary then raise exception 'Potongan kasbon tidak boleh melebihi gaji bruto.'; end if;
  if p_paid_on is null then raise exception 'Tanggal bayar wajib diisi.'; end if;

  select a.barn_id into v_barn_id
  from public.logistics_contract_assignments a
  where a.id=p_contract_assignment_id;

  if v_barn_id is null then raise exception 'Siklus tidak ditemukan.'; end if;

  if not exists (
    select 1 from public.logistics_contract_assignment_abks l
    join public.employees e on e.id=l.abk_id
    where l.contract_assignment_id=p_contract_assignment_id
      and l.abk_id=p_abk_id
      and e.kind='ABK'
  ) then
    raise exception 'ABK tidak terdaftar pada siklus ini.';
  end if;

  if exists (
    select 1 from public.abk_cycle_salaries s
    where s.contract_assignment_id=p_contract_assignment_id
      and s.abk_id=p_abk_id
  ) then
    raise exception 'Gaji ABK untuk siklus ini sudah tersimpan.';
  end if;

  select coalesce(sum(a.amount-coalesce(p.paid,0)),0)
  into v_balance
  from public.advances a
  left join (
    select advance_id,sum(amount) paid
    from public.advance_payments
    group by advance_id
  ) p on p.advance_id=a.id
  where a.employee_id=p_abk_id
    and a.contract_assignment_id=p_contract_assignment_id;

  if p_advance_deduction>v_balance then
    raise exception 'Potongan kasbon melebihi saldo kasbon siklus. Saldo: %',v_balance;
  end if;

  insert into public.abk_cycle_salaries(
    contract_assignment_id,barn_id,abk_id,
    gross_salary,advance_deduction,net_paid,paid_on,reference,notes
  ) values (
    p_contract_assignment_id,v_barn_id,p_abk_id,
    p_gross_salary,p_advance_deduction,p_gross_salary-p_advance_deduction,
    p_paid_on,null,nullif(trim(p_notes),'')
  )
  returning id into v_salary_id;

  insert into public.bop(
    contract_assignment_id,barn_id,incurred_on,category,amount,reference,notes,
    source_type,source_id
  ) values (
    p_contract_assignment_id,v_barn_id,p_paid_on,'TENAGA_KERJA',p_gross_salary,
    null,'Gaji bruto ABK per siklus','ABK_SALARY',v_salary_id
  );

  v_remaining:=p_advance_deduction;
  for v_adv in
    select a.id,a.amount-coalesce(p.paid,0) as balance
    from public.advances a
    left join (
      select advance_id,sum(amount) paid
      from public.advance_payments
      group by advance_id
    ) p on p.advance_id=a.id
    where a.employee_id=p_abk_id
      and a.contract_assignment_id=p_contract_assignment_id
      and a.amount-coalesce(p.paid,0)>0
    order by a.advanced_on,a.created_at,a.id
  loop
    exit when v_remaining<=0;
    v_take:=least(v_remaining,v_adv.balance);
    insert into public.advance_payments(
      advance_id,paid_on,amount,method,reference,notes
    ) values (
      v_adv.id,p_paid_on,v_take,'POTONG_GAJI',
      null,'Potongan otomatis dari gaji siklus'
    );
    v_remaining:=v_remaining-v_take;
  end loop;

  return v_salary_id;
end
$function$;

-- public.finance_save_employee_advance_atomic(p_employee_id uuid, p_advanced_on date, p_amount numeric, p_contract_assignment_id uuid, p_description text, p_reference text)
CREATE OR REPLACE FUNCTION public.finance_save_employee_advance_atomic(p_employee_id uuid, p_advanced_on date, p_amount numeric, p_contract_assignment_id uuid DEFAULT NULL::uuid, p_description text DEFAULT NULL::text, p_reference text DEFAULT NULL::text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v_kind text;
  v_barn_id uuid;
  v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  if p_amount is null or p_amount<=0 then
    raise exception 'Nominal kasbon harus lebih dari 0.';
  end if;
  if p_advanced_on is null then
    raise exception 'Tanggal kasbon wajib diisi.';
  end if;

  select e.kind into v_kind
  from public.employees e
  where e.id=p_employee_id and e.active=true;

  if v_kind is null then
    raise exception 'Karyawan tidak ditemukan atau tidak aktif.';
  end if;

  if v_kind='ABK' then
    if p_contract_assignment_id is null then
      raise exception 'Kasbon ABK wajib memilih Kandang dan Siklus.';
    end if;

    select a.barn_id into v_barn_id
    from public.logistics_contract_assignments a
    where a.id=p_contract_assignment_id;

    if v_barn_id is null then
      raise exception 'Siklus tidak ditemukan.';
    end if;

    if not exists (
      select 1
      from public.logistics_contract_assignment_abks l
      where l.contract_assignment_id=p_contract_assignment_id
        and l.abk_id=p_employee_id
    ) then
      raise exception 'ABK tidak terdaftar pada siklus ini.';
    end if;
  else
    v_barn_id:=null;
  end if;

  insert into public.advances(
    employee_id,advanced_on,amount,description,reference,
    contract_assignment_id,barn_id
  ) values (
    p_employee_id,p_advanced_on,p_amount,
    nullif(trim(p_description),''),
    nullif(trim(p_reference),''),
    case when v_kind='ABK' then p_contract_assignment_id else null end,
    case when v_kind='ABK' then v_barn_id else null end
  )
  returning id into v_id;

  return v_id;
end
$function$;

-- public.finance_save_rhpp_real_atomic(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text, p_notes text)
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

-- public.guard_barn_update()
CREATE OR REPLACE FUNCTION public.guard_barn_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.capacity <= 0 then
    raise exception 'Kapasitas kandang harus lebih dari 0';
  end if;

  if old.active=true and new.active=false
     and exists(
       select 1 from public.logistics_contract_assignments a
       where a.barn_id=old.id and a.active=true
     ) then
    raise exception 'Kandang tidak dapat dinonaktifkan karena masih memiliki Kontrak Logistik aktif';
  end if;

  return new;
end;
$function$;

-- public.guard_contract_detail()
CREATE OR REPLACE FUNCTION public.guard_contract_detail()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  cid uuid;
  st public.cycle_state;
  rec_id text;
begin
  select k.cycle_id into cid
  from public.contracts k
  where k.id=new.contract_id;

  if not found then
    raise exception 'Kontrak tidak ditemukan';
  end if;

  if cid is not null then
    select state into st
    from public.cycles
    where id=cid
    for update;

    if st is null then
      raise exception 'Siklus tidak ditemukan';
    end if;

    if st <> 'ACTIVE' then
      raise exception 'Kontrak siklus terkunci';
    end if;
  end if;

  if TG_TABLE_NAME = 'contract_live_prices' then
    if exists (
      select 1
      from public.contract_live_prices p
      where p.contract_id=new.contract_id
        and p.id<>new.id
        and numrange(p.min_weight_kg,coalesce(p.max_weight_kg,1000000),'[)')
          && numrange(new.min_weight_kg,coalesce(new.max_weight_kg,1000000),'[)')
    ) then
      raise exception 'Rentang bobot kontrak tumpang tindih';
    end if;
  end if;

  rec_id := new.id::text;

  insert into public.audit_events(actor,action,table_name,record_id,new_data)
  values(auth.uid(),TG_OP,TG_TABLE_NAME,rec_id,to_jsonb(new));

  return new;
end
$function$;

-- public.guard_logistics_contract_close_prices()
CREATE OR REPLACE FUNCTION public.guard_logistics_contract_close_prices()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if old.active=true and new.active=false then
    if exists (
      select 1
      from public.logistics_shipments s
      join public.logistics_shipment_items si on si.shipment_id=s.id
      where s.contract_assignment_id=old.id
        and (si.unit_price is null or si.unit_price<=0)
    ) then
      raise exception 'Tidak bisa Close: masih ada Pengiriman tanpa harga';
    end if;

    if exists (
      select 1
      from public.logistics_returns r
      join public.logistics_return_items ri on ri.return_id=r.id
      where r.contract_assignment_id=old.id
        and (ri.unit_price is null or ri.unit_price<=0)
    ) then
      raise exception 'Tidak bisa Close: masih ada Retur tanpa harga';
    end if;
  end if;
  return new;
end
$function$;

-- public.guard_logistics_return()
CREATE OR REPLACE FUNCTION public.guard_logistics_return()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if tg_op='UPDATE' and exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=old.contract_assignment_id and a.active=false
  ) then
    raise exception 'Retur terkunci karena kontrak Logistik sudah CLOSED';
  end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=new.contract_assignment_id
      and a.barn_id=new.barn_id
      and a.active=true
  ) then
    raise exception 'Kontrak aktif kandang tidak sesuai';
  end if;

  if tg_op='UPDATE' then new.updated_at:=now(); end if;
  return new;
end
$function$;

-- public.guard_logistics_return_item()
CREATE OR REPLACE FUNCTION public.guard_logistics_return_item()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_return uuid;
  v_kg numeric;
begin
  v_return:=coalesce(new.return_id,old.return_id);

  if exists (
    select 1
    from public.logistics_returns r
    join public.logistics_contract_assignments a on a.id=r.contract_assignment_id
    where r.id=v_return and a.active=false
  ) then
    raise exception 'Retur terkunci karena kontrak Logistik sudah CLOSED';
  end if;

  if tg_op<>'DELETE' then
    select case when i.category='PAKAN' then coalesce(i.kg_per_unit,50) * new.quantity else null end
    into v_kg
    from public.items i
    where i.id=new.item_id;
    new.quantity_kg:=v_kg;
  end if;

  return case when tg_op='DELETE' then old else new end;
end
$function$;

-- public.guard_logistics_shipment()
CREATE OR REPLACE FUNCTION public.guard_logistics_shipment()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if tg_op='UPDATE' and exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=old.contract_assignment_id and a.active=false
  ) then
    raise exception 'Pengiriman terkunci karena kontrak Logistik sudah CLOSED';
  end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=new.contract_assignment_id
      and a.barn_id=new.barn_id
      and a.active=true
  ) then
    raise exception 'Kontrak aktif kandang tidak sesuai';
  end if;

  if tg_op='UPDATE' then new.updated_at:=now(); end if;
  return new;
end
$function$;

-- public.guard_logistics_shipment_item()
CREATE OR REPLACE FUNCTION public.guard_logistics_shipment_item()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_shipment uuid;
  v_kg numeric;
begin
  v_shipment:=coalesce(new.shipment_id,old.shipment_id);

  if exists (
    select 1
    from public.logistics_shipments s
    join public.logistics_contract_assignments a on a.id=s.contract_assignment_id
    where s.id=v_shipment and a.active=false
  ) then
    raise exception 'Pengiriman terkunci karena kontrak Logistik sudah CLOSED';
  end if;

  if tg_op<>'DELETE' then
    select case when i.category='PAKAN' then coalesce(i.kg_per_unit,50) * new.quantity else null end
    into v_kg
    from public.items i
    where i.id=new.item_id;
    new.quantity_kg:=v_kg;
  end if;

  return case when tg_op='DELETE' then old else new end;
end
$function$;

-- public.lock_production_abk_basics_atomic(p_link_id uuid, p_initial_birds integer, p_feed_pre_bags numeric, p_feed_starter_bags numeric, p_feed_finisher_bags numeric)
CREATE OR REPLACE FUNCTION public.lock_production_abk_basics_atomic(p_link_id uuid, p_initial_birds integer, p_feed_pre_bags numeric, p_feed_starter_bags numeric, p_feed_finisher_bags numeric)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_assignment_id uuid;
  v_locked timestamptz;
  v_initial integer;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active=true and p.role='ADMIN'
  ) then
    raise exception 'Hanya Administrator yang dapat mengunci Pakan ABK.';
  end if;

  if coalesce(p_feed_pre_bags,0)<0
     or coalesce(p_feed_starter_bags,0)<0
     or coalesce(p_feed_finisher_bags,0)<0 then
    raise exception 'Jumlah zak pakan tidak boleh minus.';
  end if;

  if coalesce(p_feed_pre_bags,0)+coalesce(p_feed_starter_bags,0)+coalesce(p_feed_finisher_bags,0)<=0 then
    raise exception 'Total Penempatan Pakan wajib diisi.';
  end if;

  select l.contract_assignment_id,l.basics_locked_at,l.initial_birds
    into v_assignment_id,v_locked,v_initial
  from public.logistics_contract_assignment_abks l
  where l.id=p_link_id
  for update;

  if v_assignment_id is null then
    raise exception 'Data ABK pada kontrak tidak ditemukan.';
  end if;

  if coalesce(v_initial,0)<=0 then
    raise exception 'Simpan Populasi Awal ABK terlebih dahulu.';
  end if;

  if v_locked is not null then
    raise exception 'Penempatan Pakan ABK sudah dikunci.';
  end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=v_assignment_id and a.active=true
  ) then
    raise exception 'Kontrak kandang tidak aktif atau sudah Close.';
  end if;

  update public.logistics_contract_assignment_abks
     set feed_pre_bags=coalesce(p_feed_pre_bags,0),
         feed_starter_bags=coalesce(p_feed_starter_bags,0),
         feed_finisher_bags=coalesce(p_feed_finisher_bags,0),
         basics_locked_at=now()
   where id=p_link_id;

  return p_link_id;
end
$function$;

-- public.normalize_item_unit()
CREATE OR REPLACE FUNCTION public.normalize_item_unit()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.category='DOC' then
    new.unit := 'EKOR';
    new.kg_per_unit := null;
  elsif new.category='PAKAN' then
    new.unit := 'ZAK';
    new.kg_per_unit := 50.00;
  else
    new.unit := upper(trim(new.unit));
    new.kg_per_unit := null;
    if new.unit is null or new.unit='' then
      raise exception 'Satuan wajib diisi untuk OVK/LAINNYA';
    end if;
  end if;
  return new;
end
$function$;

-- public.prepare_logistics_contract_assignment()
CREATE OR REPLACE FUNCTION public.prepare_logistics_contract_assignment()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1
    from public.contracts c
    where c.id = new.master_contract_id
      and c.cycle_id is null
  ) then
    raise exception 'Kontrak yang dipilih bukan Master Kontrak';
  end if;

  if not exists (
    select 1
    from public.performance_standards p
    where p.contract_id = new.master_contract_id
      and p.template_name = new.performance_template_name
  ) then
    raise exception 'Template Performa tidak tersedia pada kontrak yang dipilih';
  end if;

  update public.logistics_contract_assignments
  set active=false
  where barn_id=new.barn_id
    and active=true
    and id is distinct from new.id;

  return new;
end
$function$;

-- public.prevent_employee_delete()
CREATE OR REPLACE FUNCTION public.prevent_employee_delete()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  raise exception 'Data Karyawan/ABK tidak boleh dihapus. Gunakan status Nonaktif agar riwayat Kasbon/Cicilan tetap aman.';
end
$function$;

-- public.prevent_locked_abk_basics_change()
CREATE OR REPLACE FUNCTION public.prevent_locked_abk_basics_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if old.basics_locked_at is not null and (
       new.feed_pre_bags is distinct from old.feed_pre_bags
    or new.feed_starter_bags is distinct from old.feed_starter_bags
    or new.feed_finisher_bags is distinct from old.feed_finisher_bags
    or new.basics_locked_at is distinct from old.basics_locked_at
  ) then
    raise exception 'Penempatan Pakan ABK sudah dikunci.';
  end if;
  return new;
end
$function$;

-- public.production_feed_stock(p_contract_assignment_id uuid)
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

-- public.protect_frozen_contract()
CREATE OR REPLACE FUNCTION public.protect_frozen_contract()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if old.cycle_id is not null and old.frozen_at is not null then
    raise exception 'Kontrak Siklus sudah terkunci dan tidak dapat diubah';
  end if;
  return case when TG_OP='DELETE' then old else new end;
end
$function$;

-- public.protect_frozen_contract_detail()
CREATE OR REPLACE FUNCTION public.protect_frozen_contract_detail()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  cid uuid;
begin
  if TG_OP='DELETE' then
    cid := old.contract_id;
  else
    cid := new.contract_id;
  end if;

  if exists(
    select 1
    from public.contracts
    where id=cid
      and cycle_id is not null
      and frozen_at is not null
  ) then
    raise exception 'Detail kontrak Siklus sudah terkunci dan tidak dapat diubah';
  end if;

  if TG_OP='DELETE' then
    return old;
  end if;
  return new;
end
$function$;

-- public.protect_master_auto_code()
CREATE OR REPLACE FUNCTION public.protect_master_auto_code()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  if new.code is distinct from old.code then
    raise exception 'Kode dibuat otomatis dan tidak dapat diubah';
  end if;
  return new;
end
$function$;

-- public.reassign_employee_code_on_kind_change()
CREATE OR REPLACE FUNCTION public.reassign_employee_code_on_kind_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  seq regclass;
  prefix text;
begin
  if new.kind is distinct from old.kind then
    if new.kind='ABK' then
      prefix:='ABK-';
      seq:='public.abk_code_seq'::regclass;
    else
      prefix:='KY-';
      seq:='public.employee_code_seq'::regclass;
    end if;

    loop
      new.code:=prefix||lpad(nextval(seq)::text,3,'0');
      exit when not exists (
        select 1 from public.employees e
        where e.code=new.code and e.id<>old.id
      );
    end loop;
  end if;

  return new;
end
$function$;

-- public.reset_bop_complete()
CREATE OR REPLACE FUNCTION public.reset_bop_complete()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  update public.cycles set bop_complete = false where id = new.cycle_id;
  return new;
end $function$;

-- public.save_external_sapronak_atomic(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric)
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

-- public.save_external_sapronak_return_atomic(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric)
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

-- public.save_logistics_return_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb)
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

-- public.save_logistics_shipment_atomic(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb)
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

-- public.save_production_abk_harvest_atomic(p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric)
CREATE OR REPLACE FUNCTION public.save_production_abk_harvest_atomic(p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  v_feed_pre numeric;
  v_feed_starter numeric;
  v_feed_finisher numeric;
begin
  if p_harvest_date is null then raise exception 'Tanggal Panen wajib diisi.'; end if;
  if coalesce(p_birds,0)<=0 then raise exception 'Ekor harus lebih dari 0.'; end if;
  if coalesce(p_weight_kg,0)<=0 then raise exception 'KG harus lebih dari 0.'; end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=p_assignment_id and a.barn_id=p_barn_id and a.active=true
  ) then
    raise exception 'Kontrak kandang tidak aktif atau sudah Close.';
  end if;

  select coalesce(l.feed_pre_bags,0)*50,
         coalesce(l.feed_starter_bags,0)*50,
         coalesce(l.feed_finisher_bags,0)*50
    into v_feed_pre,v_feed_starter,v_feed_finisher
  from public.logistics_contract_assignment_abks l
  where l.contract_assignment_id=p_assignment_id
    and l.abk_id=p_abk_id
    and l.basics_locked_at is not null;

  if not found then
    raise exception 'Pakan ABK belum disimpan dan dikunci.';
  end if;

  select id into v_id
  from public.production_abk_results
  where contract_assignment_id=p_assignment_id and abk_id=p_abk_id
  limit 1;

  if v_id is null then
    insert into public.production_abk_results(
      contract_assignment_id,barn_id,abk_id,harvest_date,
      feed_pre_kg,feed_starter_kg,feed_finisher_kg
    ) values(
      p_assignment_id,p_barn_id,p_abk_id,p_harvest_date,
      v_feed_pre,v_feed_starter,v_feed_finisher
    ) returning id into v_id;
  else
    update public.production_abk_results
       set barn_id=p_barn_id,
           harvest_date=greatest(coalesce(harvest_date,p_harvest_date),p_harvest_date),
           feed_pre_kg=v_feed_pre,
           feed_starter_kg=v_feed_starter,
           feed_finisher_kg=v_feed_finisher,
           updated_at=now()
     where id=v_id;
  end if;

  insert into public.production_abk_result_sizes(result_id,harvest_date,birds,weight_kg)
  values(v_id,p_harvest_date,p_birds,p_weight_kg);

  return v_id;
end
$function$;

-- public.save_production_abk_initial_population_atomic(p_link_id uuid, p_initial_birds integer)
CREATE OR REPLACE FUNCTION public.save_production_abk_initial_population_atomic(p_link_id uuid, p_initial_birds integer)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid() and p.active=true and p.role='ADMIN'
  ) then
    raise exception 'Hanya Administrator yang dapat mengubah Populasi Awal ABK.';
  end if;

  if coalesce(p_initial_birds,0)<=0 then
    raise exception 'Populasi Awal ABK wajib lebih dari 0.';
  end if;

  update public.logistics_contract_assignment_abks
     set initial_birds=p_initial_birds
   where id=p_link_id;

  if not found then
    raise exception 'Data ABK pada kontrak tidak ditemukan.';
  end if;

  return p_link_id;
end
$function$;

-- public.save_production_abk_result_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric, p_sizes jsonb)
CREATE OR REPLACE FUNCTION public.save_production_abk_result_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric, p_sizes jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  x jsonb;
begin
  if coalesce(jsonb_array_length(p_sizes),0)=0 then
    raise exception 'Minimal satu ukuran panen ABK wajib diisi.';
  end if;

  if exists (
    select 1 from jsonb_array_elements(p_sizes) x
    where coalesce((x->>'birds')::integer,0)<=0
       or coalesce((x->>'weight_kg')::numeric,0)<=0
  ) then
    raise exception 'Ekor dan berat panen setiap ukuran harus lebih dari 0.';
  end if;

  if p_id is null then
    insert into public.production_abk_results(
      contract_assignment_id,barn_id,abk_id,harvest_date,
      feed_pre_kg,feed_starter_kg,feed_finisher_kg
    ) values(
      p_assignment_id,p_barn_id,p_abk_id,p_harvest_date,
      p_feed_pre_kg,p_feed_starter_kg,p_feed_finisher_kg
    ) returning id into v_id;
  else
    v_id:=p_id;
    update public.production_abk_results
       set contract_assignment_id=p_assignment_id,
           barn_id=p_barn_id,
           abk_id=p_abk_id,
           harvest_date=p_harvest_date,
           feed_pre_kg=p_feed_pre_kg,
           feed_starter_kg=p_feed_starter_kg,
           feed_finisher_kg=p_feed_finisher_kg,
           updated_at=now()
     where id=v_id;
    if not found then raise exception 'Hasil ABK tidak ditemukan.'; end if;
    delete from public.production_abk_result_sizes where result_id=v_id;
  end if;

  for x in select * from jsonb_array_elements(p_sizes)
  loop
    insert into public.production_abk_result_sizes(result_id,birds,weight_kg)
    values(v_id,(x->>'birds')::integer,(x->>'weight_kg')::numeric);
  end loop;

  return v_id;
end $function$;

-- public.save_production_estimate_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_estimated_on date, p_remaining_birds integer, p_feed_used_kg numeric, p_notes text, p_estimated_revenue numeric, p_estimated_cost numeric, p_estimated_profit numeric, p_profit_per_chick_in numeric, p_sizes jsonb)
CREATE OR REPLACE FUNCTION public.save_production_estimate_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_estimated_on date, p_remaining_birds integer, p_feed_used_kg numeric, p_notes text, p_estimated_revenue numeric, p_estimated_cost numeric, p_estimated_profit numeric, p_profit_per_chick_in numeric, p_sizes jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_id uuid;
  x jsonb;
  v_sum integer := 0;
  v_arrived_on date;
begin
  if p_estimated_on is null then
    raise exception 'Tanggal estimasi wajib diisi.';
  end if;

  if p_remaining_birds < 0 then
    raise exception 'Sisa ayam tidak boleh negatif.';
  end if;

  if coalesce(p_feed_used_kg,0) < 0 then
    raise exception 'Pakan terpakai tidak boleh negatif.';
  end if;

  if not exists (
    select 1
    from public.logistics_contract_assignments a
    where a.id=p_assignment_id
      and a.barn_id=p_barn_id
      and a.active=true
  ) then
    raise exception 'Kontrak kandang tidak aktif atau kandang tidak sesuai.';
  end if;

  select ci.arrived_on into v_arrived_on
  from public.chick_ins ci
  where ci.contract_assignment_id=p_assignment_id
  limit 1;

  if v_arrived_on is null then
    raise exception 'Chick-In belum tersedia.';
  end if;

  if ((p_estimated_on-v_arrived_on)+1) < 23 then
    raise exception 'Estimasi dimulai umur 23 hari.';
  end if;

  if exists (
    select 1
    from public.production_estimates e
    where e.contract_assignment_id=p_assignment_id
      and e.estimated_on=p_estimated_on
      and (p_id is null or e.id<>p_id)
  ) then
    raise exception 'Estimasi tanggal ini sudah tersimpan. Gunakan Edit.';
  end if;

  if coalesce(jsonb_array_length(p_sizes),0)=0 then
    raise exception 'Minimal satu ukuran estimasi wajib diisi.';
  end if;

  select coalesce(sum((x->>'birds')::integer),0)
    into v_sum
  from jsonb_array_elements(p_sizes) x;

  if v_sum<>p_remaining_birds then
    raise exception 'Total ayam per ukuran harus sama dengan Sisa Ayam Real.';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_sizes) y
    where coalesce((y->>'birds')::integer,0)<=0
       or coalesce((y->>'bw_kg')::numeric,0)<=0
  ) then
    raise exception 'Jumlah ayam dan BW semua ukuran harus lebih dari 0.';
  end if;

  if p_id is null then
    insert into public.production_estimates(
      contract_assignment_id,barn_id,estimated_on,remaining_birds,feed_used_kg,notes,
      estimated_revenue,estimated_cost,estimated_profit,profit_per_chick_in
    ) values(
      p_assignment_id,p_barn_id,p_estimated_on,p_remaining_birds,p_feed_used_kg,p_notes,
      p_estimated_revenue,p_estimated_cost,p_estimated_profit,p_profit_per_chick_in
    ) returning id into v_id;
  else
    v_id:=p_id;
    update public.production_estimates
       set contract_assignment_id=p_assignment_id,
           barn_id=p_barn_id,
           estimated_on=p_estimated_on,
           remaining_birds=p_remaining_birds,
           feed_used_kg=p_feed_used_kg,
           notes=p_notes,
           estimated_revenue=p_estimated_revenue,
           estimated_cost=p_estimated_cost,
           estimated_profit=p_estimated_profit,
           profit_per_chick_in=p_profit_per_chick_in,
           updated_at=now()
     where id=v_id;
    if not found then raise exception 'Estimasi tidak ditemukan.'; end if;
    delete from public.production_estimate_sizes where estimate_id=v_id;
  end if;

  for x in select * from jsonb_array_elements(p_sizes)
  loop
    insert into public.production_estimate_sizes(estimate_id,birds,bw_kg)
    values(v_id,(x->>'birds')::integer,(x->>'bw_kg')::numeric);
  end loop;
  return v_id;
end
$function$;

-- public.save_recording_atomic(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb)
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

-- public.save_rhpp_final_atomic(p_contract_assignment_id uuid)
CREATE OR REPLACE FUNCTION public.save_rhpp_final_atomic(p_contract_assignment_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare
  v record;
  v_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.user_id=auth.uid()
      and p.active
      and p.role in ('ADMIN','KEUANGAN')
  ) then
    raise exception 'Akses ditolak.';
  end if;

  select * into v
  from public.finance_rhpp_summary_v4()
  where contract_assignment_id=p_contract_assignment_id;

  if v.contract_assignment_id is null then
    raise exception 'Data RHPP tidak ditemukan.';
  end if;

  if not v.ready_financial then
    raise exception 'RHPP belum siap Final. Pastikan kontrak sudah Close serta data panen, pakan, dan biaya lengkap.';
  end if;

  if exists(
    select 1 from public.rhpp_real r
    where r.contract_assignment_id=p_contract_assignment_id
  ) then
    raise exception 'RHPP Final untuk kontrak ini sudah tersimpan.';
  end if;

  insert into public.rhpp_real(
    contract_assignment_id,barn_id,amount,received_on,reference,notes
  ) values (
    v.contract_assignment_id,
    v.barn_id,
    v.farmer_profit,
    (now() at time zone 'Asia/Jakarta')::date,
    'AUTO-RHPP',
    'RHPP otomatis tervalidasi. Nilai panen '||round(v.harvest_value,0)||
    '; Sapronak '||round(v.sapronak_cost,0)||
    '; Tambah Daging '||round(v.external_meat_cost,0)||
    '; Total Biaya RHPP '||round(v.total_rhpp_cost,0)||
    '; Bonus IP '||round(v.bonus_ip,0)||
    '; Bonus FC '||round(v.bonus_fc,0)||
    '; Bonus Deplesi '||round(v.bonus_mortality,0)||
    '; Deplesi PPL '||round(v.recorded_depletion_birds,0)||
    '; Pembanding Chick-In - Panen '||round(v.implied_depletion_birds,0)||
    '; Selisih pembanding '||round(v.depletion_variance_birds,0)||'.'
  ) returning id into v_id;

  return v_id;
end
$function$;

-- public.set_cycle_state(p_cycle uuid, p_action text, p_reason text)
CREATE OR REPLACE FUNCTION public.set_cycle_state(p_cycle uuid, p_action text, p_reason text DEFAULT NULL::text)
 RETURNS cycles
 LANGUAGE sql
 SET search_path TO ''
AS $function$
  select private.set_cycle_state_impl(p_cycle,p_action,p_reason)
$function$;

-- public.transfer_external_sapronak_return_atomic(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text)
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

-- public.update_production_abk_harvest_atomic(p_size_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric)
CREATE OR REPLACE FUNCTION public.update_production_abk_harvest_atomic(p_size_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  v_result_id uuid;
  v_assignment_id uuid;
  v_abk_id uuid;
  v_feed_pre numeric;
  v_feed_starter numeric;
  v_feed_finisher numeric;
begin
  if p_harvest_date is null then raise exception 'Tanggal Panen wajib diisi.'; end if;
  if coalesce(p_birds,0)<=0 then raise exception 'Ekor harus lebih dari 0.'; end if;
  if coalesce(p_weight_kg,0)<=0 then raise exception 'KG harus lebih dari 0.'; end if;

  select s.result_id,r.contract_assignment_id,r.abk_id
    into v_result_id,v_assignment_id,v_abk_id
  from public.production_abk_result_sizes s
  join public.production_abk_results r on r.id=s.result_id
  where s.id=p_size_id
  for update of s,r;

  if v_result_id is null then raise exception 'Transaksi Panen ABK tidak ditemukan.'; end if;

  if not exists (
    select 1 from public.logistics_contract_assignments a
    where a.id=v_assignment_id and a.active=true
  ) then
    raise exception 'Kontrak kandang sudah Close. Data terkunci.';
  end if;

  select coalesce(l.feed_pre_bags,0)*50,
         coalesce(l.feed_starter_bags,0)*50,
         coalesce(l.feed_finisher_bags,0)*50
    into v_feed_pre,v_feed_starter,v_feed_finisher
  from public.logistics_contract_assignment_abks l
  where l.contract_assignment_id=v_assignment_id
    and l.abk_id=v_abk_id
    and l.basics_locked_at is not null;

  if not found then
    raise exception 'Pakan ABK belum disimpan dan dikunci.';
  end if;

  update public.production_abk_result_sizes
     set harvest_date=p_harvest_date,
         birds=p_birds,
         weight_kg=p_weight_kg
   where id=p_size_id;

  update public.production_abk_results
     set harvest_date=(select max(s.harvest_date) from public.production_abk_result_sizes s where s.result_id=v_result_id),
         feed_pre_kg=v_feed_pre,
         feed_starter_kg=v_feed_starter,
         feed_finisher_kg=v_feed_finisher,
         updated_at=now()
   where id=v_result_id;

  return v_result_id;
end
$function$;

-- public.validate_chick_in()
CREATE OR REPLACE FUNCTION public.validate_chick_in()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare cap integer; planned integer;
begin
  select b.capacity,c.initial_population into cap,planned
  from public.cycles c join public.barns b on b.id=c.barn_id
  where c.id=new.cycle_id;
  if new.received > cap then raise exception 'Jumlah diterima melebihi kapasitas kandang'; end if;
  if planned is not null and new.received <> planned then
    raise exception 'Populasi Chick-In harus sama dengan populasi awal siklus';
  end if;
  return new;
end $function$;

-- public.validate_cycle_population()
CREATE OR REPLACE FUNCTION public.validate_cycle_population()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare qty_received integer; dead integer; harvested integer;
begin
  select ci.received into qty_received from public.chick_ins ci where cycle_id=new.cycle_id;
  if qty_received is null then raise exception 'Chick-In wajib tersedia'; end if;
  select coalesce(sum(mortality+culling),0) into dead
    from public.recordings where cycle_id=new.cycle_id and id is distinct from new.id;
  select coalesce(sum(birds),0) into harvested
    from public.harvests where cycle_id=new.cycle_id and id is distinct from new.id;
  if TG_TABLE_NAME='recordings' then dead:=dead+new.mortality+new.culling; end if;
  if TG_TABLE_NAME='harvests' then harvested:=harvested+new.birds; end if;
  if dead+harvested>qty_received then
    raise exception 'Mortalitas, afkir, dan panen melebihi populasi diterima';
  end if;
  return new;
end $function$;

set check_function_bodies = on;

-- ROW LEVEL SECURITY
alter table public."abk_cycle_salaries" enable row level security;
alter table public."abk_league_settings" enable row level security;
alter table public."advance_payments" enable row level security;
alter table public."advances" enable row level security;
alter table public."audit_events" enable row level security;
alter table public."barns" enable row level security;
alter table public."bop" enable row level security;
alter table public."bop_outside" enable row level security;
alter table public."chick_ins" enable row level security;
alter table public."company_profile" enable row level security;
alter table public."contract_bonuses" enable row level security;
alter table public."contract_live_prices" enable row level security;
alter table public."contracts" enable row level security;
alter table public."cycles" enable row level security;
alter table public."employees" enable row level security;
alter table public."expeditions" enable row level security;
alter table public."finance_expedition_bop" enable row level security;
alter table public."finance_expedition_invoice_items" enable row level security;
alter table public."finance_expedition_invoices" enable row level security;
alter table public."finance_expedition_payments" enable row level security;
alter table public."finance_expedition_trips" enable row level security;
alter table public."finance_reference_counters" enable row level security;
alter table public."harvests" enable row level security;
alter table public."items" enable row level security;
alter table public."logistics_contract_assignment_abks" enable row level security;
alter table public."logistics_contract_assignments" enable row level security;
alter table public."logistics_external_return_items" enable row level security;
alter table public."logistics_external_return_transfers" enable row level security;
alter table public."logistics_external_returns" enable row level security;
alter table public."logistics_external_shipment_items" enable row level security;
alter table public."logistics_external_shipments" enable row level security;
alter table public."logistics_return_items" enable row level security;
alter table public."logistics_returns" enable row level security;
alter table public."logistics_shipment_items" enable row level security;
alter table public."logistics_shipments" enable row level security;
alter table public."marketing_contract_harvests" enable row level security;
alter table public."marketing_external_meat_purchases" enable row level security;
alter table public."performance_standards" enable row level security;
alter table public."production_abk_result_sizes" enable row level security;
alter table public."production_abk_results" enable row level security;
alter table public."production_estimate_sizes" enable row level security;
alter table public."production_estimates" enable row level security;
alter table public."profiles" enable row level security;
alter table public."recording_weight_samples" enable row level security;
alter table public."recordings" enable row level security;
alter table public."rhpp_estimates" enable row level security;
alter table public."rhpp_real" enable row level security;
alter table public."rhpp_system_final" enable row level security;
alter table public."suppliers" enable row level security;
alter table public."supplies" enable row level security;
alter table public."visits" enable row level security;

-- POLICIES
drop policy if exists "abk_cycle_salaries_admin_all" on public."abk_cycle_salaries";
create policy "abk_cycle_salaries_admin_all" on public."abk_cycle_salaries" as permissive for all to "public" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "abk_cycle_salaries_insert" on public."abk_cycle_salaries";
create policy "abk_cycle_salaries_insert" on public."abk_cycle_salaries" as permissive for insert to "public" with check (((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignment_abks l
  WHERE ((l.contract_assignment_id = abk_cycle_salaries.contract_assignment_id) AND (l.abk_id = abk_cycle_salaries.abk_id))))));
drop policy if exists "abk_cycle_salaries_read" on public."abk_cycle_salaries";
create policy "abk_cycle_salaries_read" on public."abk_cycle_salaries" as permissive for select to "public" using (((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])) AND private.can_read_assignment(contract_assignment_id)));
drop policy if exists "abk_league_settings_admin_delete" on public."abk_league_settings";
create policy "abk_league_settings_admin_delete" on public."abk_league_settings" as permissive for delete to "public" using ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "abk_league_settings_admin_insert" on public."abk_league_settings";
create policy "abk_league_settings_admin_insert" on public."abk_league_settings" as permissive for insert to "public" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "abk_league_settings_admin_update" on public."abk_league_settings";
create policy "abk_league_settings_admin_update" on public."abk_league_settings" as permissive for update to "public" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "abk_league_settings_read" on public."abk_league_settings";
create policy "abk_league_settings_read" on public."abk_league_settings" as permissive for select to "public" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "admin_full_access" on public."abk_league_settings";
create policy "admin_full_access" on public."abk_league_settings" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."advance_payments";
create policy "admin_full_access" on public."advance_payments" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "payments_insert" on public."advance_payments";
create policy "payments_insert" on public."advance_payments" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "payments_read" on public."advance_payments";
create policy "payments_read" on public."advance_payments" as permissive for select to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "admin_full_access" on public."advances";
create policy "admin_full_access" on public."advances" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "advances_insert" on public."advances";
create policy "advances_insert" on public."advances" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "advances_read" on public."advances";
create policy "advances_read" on public."advances" as permissive for select to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "admin_full_access" on public."audit_events";
create policy "admin_full_access" on public."audit_events" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "audit_read" on public."audit_events";
create policy "audit_read" on public."audit_events" as permissive for select to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_barns_insert" on public."barns";
create policy "admin_barns_insert" on public."barns" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_barns_update" on public."barns";
create policy "admin_barns_update" on public."barns" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."barns";
create policy "admin_full_access" on public."barns" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "barns_read" on public."barns";
create policy "barns_read" on public."barns" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "admin_full_access" on public."bop";
create policy "admin_full_access" on public."bop" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "bop_assignment_delete" on public."bop";
create policy "bop_assignment_delete" on public."bop" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE (a.id = bop.contract_assignment_id)))));
drop policy if exists "bop_assignment_insert" on public."bop";
create policy "bop_assignment_insert" on public."bop" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE (a.id = bop.contract_assignment_id)))));
drop policy if exists "bop_assignment_read" on public."bop";
create policy "bop_assignment_read" on public."bop" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'OWNER'::bms_role, 'KEUANGAN'::bms_role]))));
drop policy if exists "bop_assignment_update" on public."bop";
create policy "bop_assignment_update" on public."bop" as permissive for update to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE (a.id = bop.contract_assignment_id))))) with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE (a.id = bop.contract_assignment_id)))));
drop policy if exists "admin_full_access" on public."bop_outside";
create policy "admin_full_access" on public."bop_outside" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "bop_outside_delete" on public."bop_outside";
create policy "bop_outside_delete" on public."bop_outside" as permissive for delete to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "bop_outside_insert" on public."bop_outside";
create policy "bop_outside_insert" on public."bop_outside" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "bop_outside_read" on public."bop_outside";
create policy "bop_outside_read" on public."bop_outside" as permissive for select to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "bop_outside_update" on public."bop_outside";
create policy "bop_outside_update" on public."bop_outside" as permissive for update to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "admin_full_access" on public."chick_ins";
create policy "admin_full_access" on public."chick_ins" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "chick_delete" on public."chick_ins";
create policy "chick_delete" on public."chick_ins" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "chick_insert" on public."chick_ins";
create policy "chick_insert" on public."chick_ins" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "chick_read" on public."chick_ins";
create policy "chick_read" on public."chick_ins" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))));
drop policy if exists "chick_update" on public."chick_ins";
create policy "chick_update" on public."chick_ins" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "admin_full_access" on public."company_profile";
create policy "admin_full_access" on public."company_profile" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "company_insert" on public."company_profile";
create policy "company_insert" on public."company_profile" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "company_read" on public."company_profile";
create policy "company_read" on public."company_profile" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "company_update" on public."company_profile";
create policy "company_update" on public."company_profile" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."contract_bonuses";
create policy "admin_full_access" on public."contract_bonuses" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "bonuses_insert" on public."contract_bonuses";
create policy "bonuses_insert" on public."contract_bonuses" as permissive for insert to "authenticated" with check (((private.my_bms_role() = 'ADMIN'::bms_role) AND (EXISTS ( SELECT 1
   FROM contracts k
  WHERE (k.id = contract_bonuses.contract_id)))));
drop policy if exists "bonuses_read" on public."contract_bonuses";
create policy "bonuses_read" on public."contract_bonuses" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "bonuses_update" on public."contract_bonuses";
create policy "bonuses_update" on public."contract_bonuses" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."contract_live_prices";
create policy "admin_full_access" on public."contract_live_prices" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "live_prices_insert" on public."contract_live_prices";
create policy "live_prices_insert" on public."contract_live_prices" as permissive for insert to "authenticated" with check (((private.my_bms_role() = 'ADMIN'::bms_role) AND (EXISTS ( SELECT 1
   FROM contracts k
  WHERE (k.id = contract_live_prices.contract_id)))));
drop policy if exists "live_prices_read" on public."contract_live_prices";
create policy "live_prices_read" on public."contract_live_prices" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "live_prices_update" on public."contract_live_prices";
create policy "live_prices_update" on public."contract_live_prices" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."contracts";
create policy "admin_full_access" on public."contracts" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "contract_insert" on public."contracts";
create policy "contract_insert" on public."contracts" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "contract_read" on public."contracts";
create policy "contract_read" on public."contracts" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "contract_update" on public."contracts";
create policy "contract_update" on public."contracts" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_cycles_insert" on public."cycles";
create policy "admin_cycles_insert" on public."cycles" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."cycles";
create policy "admin_full_access" on public."cycles" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "cycles_read" on public."cycles";
create policy "cycles_read" on public."cycles" as permissive for select to "authenticated" using (((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'OWNER'::bms_role, 'KEUANGAN'::bms_role, 'LOGISTIK'::bms_role, 'MARKETING'::bms_role])) OR ((private.my_bms_role() = 'PPL'::bms_role) AND (ppl_id = ( SELECT auth.uid() AS uid)))));
drop policy if exists "admin_full_access" on public."employees";
create policy "admin_full_access" on public."employees" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "employees_insert" on public."employees";
create policy "employees_insert" on public."employees" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "employees_read" on public."employees";
create policy "employees_read" on public."employees" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "employees_update" on public."employees";
create policy "employees_update" on public."employees" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."expeditions";
create policy "admin_full_access" on public."expeditions" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "expeditions_assignment_insert" on public."expeditions";
create policy "expeditions_assignment_insert" on public."expeditions" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'MARKETING'::bms_role]));
drop policy if exists "expeditions_assignment_read" on public."expeditions";
create policy "expeditions_assignment_read" on public."expeditions" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'MARKETING'::bms_role]))));
drop policy if exists "finance_expedition_bop_read" on public."finance_expedition_bop";
create policy "finance_expedition_bop_read" on public."finance_expedition_bop" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "finance_expedition_bop_write" on public."finance_expedition_bop";
create policy "finance_expedition_bop_write" on public."finance_expedition_bop" as permissive for all to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "finance_expedition_invoice_items_read" on public."finance_expedition_invoice_items";
create policy "finance_expedition_invoice_items_read" on public."finance_expedition_invoice_items" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "finance_expedition_invoice_items_write" on public."finance_expedition_invoice_items";
create policy "finance_expedition_invoice_items_write" on public."finance_expedition_invoice_items" as permissive for all to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "finance_expedition_invoices_read" on public."finance_expedition_invoices";
create policy "finance_expedition_invoices_read" on public."finance_expedition_invoices" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "finance_expedition_invoices_write" on public."finance_expedition_invoices";
create policy "finance_expedition_invoices_write" on public."finance_expedition_invoices" as permissive for all to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "finance_expedition_payments_read" on public."finance_expedition_payments";
create policy "finance_expedition_payments_read" on public."finance_expedition_payments" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "finance_expedition_payments_write" on public."finance_expedition_payments";
create policy "finance_expedition_payments_write" on public."finance_expedition_payments" as permissive for all to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "finance_expedition_trips_read" on public."finance_expedition_trips";
create policy "finance_expedition_trips_read" on public."finance_expedition_trips" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "finance_expedition_trips_write" on public."finance_expedition_trips";
create policy "finance_expedition_trips_write" on public."finance_expedition_trips" as permissive for all to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."harvests";
create policy "admin_full_access" on public."harvests" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "harvest_assignment_insert" on public."harvests";
create policy "harvest_assignment_insert" on public."harvests" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role]));
drop policy if exists "harvest_assignment_read" on public."harvests";
create policy "harvest_assignment_read" on public."harvests" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role]))));
drop policy if exists "admin_full_access" on public."items";
create policy "admin_full_access" on public."items" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "admin_items_insert" on public."items";
create policy "admin_items_insert" on public."items" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "items_read" on public."items";
create policy "items_read" on public."items" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "admin_full_access" on public."logistics_contract_assignment_abks";
create policy "admin_full_access" on public."logistics_contract_assignment_abks" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "lcaa_delete" on public."logistics_contract_assignment_abks";
create policy "lcaa_delete" on public."logistics_contract_assignment_abks" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.active = true) AND (p.role = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "lcaa_insert" on public."logistics_contract_assignment_abks";
create policy "lcaa_insert" on public."logistics_contract_assignment_abks" as permissive for insert to "authenticated" with check (((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.active = true) AND (p.role = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))) AND (EXISTS ( SELECT 1
   FROM employees e
  WHERE ((e.id = logistics_contract_assignment_abks.abk_id) AND (e.kind = 'ABK'::text) AND (e.active = true))))));
drop policy if exists "lcaa_select" on public."logistics_contract_assignment_abks";
create policy "lcaa_select" on public."logistics_contract_assignment_abks" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE ((a.id = logistics_contract_assignment_abks.contract_assignment_id) AND private.can_read_assignment(a.id)))));
drop policy if exists "lcaa_update" on public."logistics_contract_assignment_abks";
create policy "lcaa_update" on public."logistics_contract_assignment_abks" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.active = true) AND (p.role = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])))))) with check ((EXISTS ( SELECT 1
   FROM employees e
  WHERE ((e.id = logistics_contract_assignment_abks.abk_id) AND (e.kind = 'ABK'::text) AND (e.active = true)))));
drop policy if exists "admin_full_access" on public."logistics_contract_assignments";
create policy "admin_full_access" on public."logistics_contract_assignments" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "logistics_contract_assignments_insert" on public."logistics_contract_assignments";
create policy "logistics_contract_assignments_insert" on public."logistics_contract_assignments" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (created_by = ( SELECT auth.uid() AS uid))));
drop policy if exists "logistics_contract_assignments_read" on public."logistics_contract_assignments";
create policy "logistics_contract_assignments_read" on public."logistics_contract_assignments" as permissive for select to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'MARKETING'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])) OR ((( SELECT private.my_bms_role() AS my_bms_role) = 'PPL'::bms_role) AND (ppl_id = ( SELECT auth.uid() AS uid)))));
drop policy if exists "logistics_contract_assignments_update" on public."logistics_contract_assignments";
create policy "logistics_contract_assignments_update" on public."logistics_contract_assignments" as permissive for update to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role) OR ((( SELECT private.my_bms_role() AS my_bms_role) = 'LOGISTIK'::bms_role) AND (active = true)))) with check (((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role) OR ((( SELECT private.my_bms_role() AS my_bms_role) = 'LOGISTIK'::bms_role) AND (active = true))));
drop policy if exists "admin_full_access" on public."logistics_external_return_items";
create policy "admin_full_access" on public."logistics_external_return_items" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "external_return_items_delete" on public."logistics_external_return_items";
create policy "external_return_items_delete" on public."logistics_external_return_items" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_returns r
  WHERE ((r.id = logistics_external_return_items.external_return_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "external_return_items_insert" on public."logistics_external_return_items";
create policy "external_return_items_insert" on public."logistics_external_return_items" as permissive for insert to "authenticated" with check ((EXISTS ( SELECT 1
   FROM logistics_external_returns r
  WHERE ((r.id = logistics_external_return_items.external_return_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "external_return_items_read" on public."logistics_external_return_items";
create policy "external_return_items_read" on public."logistics_external_return_items" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_returns r
  WHERE ((r.id = logistics_external_return_items.external_return_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "external_return_items_update" on public."logistics_external_return_items";
create policy "external_return_items_update" on public."logistics_external_return_items" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_returns r
  WHERE ((r.id = logistics_external_return_items.external_return_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])))))) with check ((EXISTS ( SELECT 1
   FROM logistics_external_returns r
  WHERE ((r.id = logistics_external_return_items.external_return_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "admin_full_access" on public."logistics_external_return_transfers";
create policy "admin_full_access" on public."logistics_external_return_transfers" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "external_return_transfer_delete" on public."logistics_external_return_transfers";
create policy "external_return_transfer_delete" on public."logistics_external_return_transfers" as permissive for delete to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "external_return_transfer_insert" on public."logistics_external_return_transfers";
create policy "external_return_transfer_insert" on public."logistics_external_return_transfers" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (created_by = ( SELECT auth.uid() AS uid))));
drop policy if exists "external_return_transfer_read" on public."logistics_external_return_transfers";
create policy "external_return_transfer_read" on public."logistics_external_return_transfers" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_external_returns";
create policy "admin_full_access" on public."logistics_external_returns" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "external_returns_delete" on public."logistics_external_returns";
create policy "external_returns_delete" on public."logistics_external_returns" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (status = 'DRAFT'::text) AND (NOT (EXISTS ( SELECT 1
   FROM (logistics_external_return_items ri
     JOIN logistics_external_return_transfers t ON ((t.external_return_item_id = ri.id)))
  WHERE (ri.external_return_id = logistics_external_returns.id))))));
drop policy if exists "external_returns_insert" on public."logistics_external_returns";
create policy "external_returns_insert" on public."logistics_external_returns" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (created_by = ( SELECT auth.uid() AS uid))));
drop policy if exists "external_returns_read" on public."logistics_external_returns";
create policy "external_returns_read" on public."logistics_external_returns" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "external_returns_update" on public."logistics_external_returns";
create policy "external_returns_update" on public."logistics_external_returns" as permissive for update to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_external_shipment_items";
create policy "admin_full_access" on public."logistics_external_shipment_items" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "external_items_delete" on public."logistics_external_shipment_items";
create policy "external_items_delete" on public."logistics_external_shipment_items" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_shipments h
  WHERE ((h.id = logistics_external_shipment_items.external_shipment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "external_items_insert" on public."logistics_external_shipment_items";
create policy "external_items_insert" on public."logistics_external_shipment_items" as permissive for insert to "authenticated" with check ((EXISTS ( SELECT 1
   FROM logistics_external_shipments h
  WHERE ((h.id = logistics_external_shipment_items.external_shipment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "external_items_read" on public."logistics_external_shipment_items";
create policy "external_items_read" on public."logistics_external_shipment_items" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_shipments h
  WHERE ((h.id = logistics_external_shipment_items.external_shipment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "external_items_update" on public."logistics_external_shipment_items";
create policy "external_items_update" on public."logistics_external_shipment_items" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM logistics_external_shipments h
  WHERE ((h.id = logistics_external_shipment_items.external_shipment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])))))) with check ((EXISTS ( SELECT 1
   FROM logistics_external_shipments h
  WHERE ((h.id = logistics_external_shipment_items.external_shipment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))))));
drop policy if exists "admin_full_access" on public."logistics_external_shipments";
create policy "admin_full_access" on public."logistics_external_shipments" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "external_shipments_delete" on public."logistics_external_shipments";
create policy "external_shipments_delete" on public."logistics_external_shipments" as permissive for delete to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "external_shipments_insert" on public."logistics_external_shipments";
create policy "external_shipments_insert" on public."logistics_external_shipments" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "external_shipments_read" on public."logistics_external_shipments";
create policy "external_shipments_read" on public."logistics_external_shipments" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "external_shipments_update" on public."logistics_external_shipments";
create policy "external_shipments_update" on public."logistics_external_shipments" as permissive for update to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_return_items";
create policy "admin_full_access" on public."logistics_return_items" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "logistics_return_items_delete" on public."logistics_return_items";
create policy "logistics_return_items_delete" on public."logistics_return_items" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_returns r
     JOIN logistics_contract_assignments a ON ((a.id = r.contract_assignment_id)))
  WHERE ((r.id = logistics_return_items.return_id) AND (a.active = true))))));
drop policy if exists "logistics_return_items_insert" on public."logistics_return_items";
create policy "logistics_return_items_insert" on public."logistics_return_items" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_returns r
     JOIN logistics_contract_assignments a ON ((a.id = r.contract_assignment_id)))
  WHERE ((r.id = logistics_return_items.return_id) AND (a.active = true))))));
drop policy if exists "logistics_return_items_read" on public."logistics_return_items";
create policy "logistics_return_items_read" on public."logistics_return_items" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "logistics_return_items_update" on public."logistics_return_items";
create policy "logistics_return_items_update" on public."logistics_return_items" as permissive for update to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_returns r
     JOIN logistics_contract_assignments a ON ((a.id = r.contract_assignment_id)))
  WHERE ((r.id = logistics_return_items.return_id) AND (a.active = true)))))) with check ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_returns";
create policy "admin_full_access" on public."logistics_returns" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "logistics_returns_delete" on public."logistics_returns";
create policy "logistics_returns_delete" on public."logistics_returns" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE ((a.id = logistics_returns.contract_assignment_id) AND (a.active = true))))));
drop policy if exists "logistics_returns_insert" on public."logistics_returns";
create policy "logistics_returns_insert" on public."logistics_returns" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (created_by = ( SELECT auth.uid() AS uid))));
drop policy if exists "logistics_returns_read" on public."logistics_returns";
create policy "logistics_returns_read" on public."logistics_returns" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "logistics_returns_update" on public."logistics_returns";
create policy "logistics_returns_update" on public."logistics_returns" as permissive for update to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_shipment_items";
create policy "admin_full_access" on public."logistics_shipment_items" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "logistics_shipment_items_delete" on public."logistics_shipment_items";
create policy "logistics_shipment_items_delete" on public."logistics_shipment_items" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_shipments s
     JOIN logistics_contract_assignments a ON ((a.id = s.contract_assignment_id)))
  WHERE ((s.id = logistics_shipment_items.shipment_id) AND (a.active = true))))));
drop policy if exists "logistics_shipment_items_insert" on public."logistics_shipment_items";
create policy "logistics_shipment_items_insert" on public."logistics_shipment_items" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_shipments s
     JOIN logistics_contract_assignments a ON ((a.id = s.contract_assignment_id)))
  WHERE ((s.id = logistics_shipment_items.shipment_id) AND (a.active = true))))));
drop policy if exists "logistics_shipment_items_read" on public."logistics_shipment_items";
create policy "logistics_shipment_items_read" on public."logistics_shipment_items" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "logistics_shipment_items_update" on public."logistics_shipment_items";
create policy "logistics_shipment_items_update" on public."logistics_shipment_items" as permissive for update to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM (logistics_shipments s
     JOIN logistics_contract_assignments a ON ((a.id = s.contract_assignment_id)))
  WHERE ((s.id = logistics_shipment_items.shipment_id) AND (a.active = true)))))) with check ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."logistics_shipments";
create policy "admin_full_access" on public."logistics_shipments" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "logistics_shipments_delete" on public."logistics_shipments";
create policy "logistics_shipments_delete" on public."logistics_shipments" as permissive for delete to "authenticated" using (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (EXISTS ( SELECT 1
   FROM logistics_contract_assignments a
  WHERE ((a.id = logistics_shipments.contract_assignment_id) AND (a.active = true))))));
drop policy if exists "logistics_shipments_insert" on public."logistics_shipments";
create policy "logistics_shipments_insert" on public."logistics_shipments" as permissive for insert to "authenticated" with check (((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])) AND (created_by = ( SELECT auth.uid() AS uid))));
drop policy if exists "logistics_shipments_read" on public."logistics_shipments";
create policy "logistics_shipments_read" on public."logistics_shipments" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "logistics_shipments_update" on public."logistics_shipments";
create policy "logistics_shipments_update" on public."logistics_shipments" as permissive for update to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))) with check ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role])));
drop policy if exists "admin_full_access" on public."marketing_contract_harvests";
create policy "admin_full_access" on public."marketing_contract_harvests" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "marketing_contract_harvest_delete" on public."marketing_contract_harvests";
create policy "marketing_contract_harvest_delete" on public."marketing_contract_harvests" as permissive for delete to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "marketing_contract_harvest_insert" on public."marketing_contract_harvests";
create policy "marketing_contract_harvest_insert" on public."marketing_contract_harvests" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "marketing_contract_harvest_read" on public."marketing_contract_harvests";
create policy "marketing_contract_harvest_read" on public."marketing_contract_harvests" as permissive for select to "public" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role, 'KEUANGAN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "marketing_contract_harvest_update" on public."marketing_contract_harvests";
create policy "marketing_contract_harvest_update" on public."marketing_contract_harvests" as permissive for update to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "admin_full_access" on public."marketing_external_meat_purchases";
create policy "admin_full_access" on public."marketing_external_meat_purchases" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "marketing_external_meat_delete" on public."marketing_external_meat_purchases";
create policy "marketing_external_meat_delete" on public."marketing_external_meat_purchases" as permissive for delete to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "marketing_external_meat_insert" on public."marketing_external_meat_purchases";
create policy "marketing_external_meat_insert" on public."marketing_external_meat_purchases" as permissive for insert to "authenticated" with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "marketing_external_meat_read" on public."marketing_external_meat_purchases";
create policy "marketing_external_meat_read" on public."marketing_external_meat_purchases" as permissive for select to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role])));
drop policy if exists "marketing_external_meat_update" on public."marketing_external_meat_purchases";
create policy "marketing_external_meat_update" on public."marketing_external_meat_purchases" as permissive for update to "authenticated" using ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role]))) with check ((private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'MARKETING'::bms_role])));
drop policy if exists "admin_full_access" on public."performance_standards";
create policy "admin_full_access" on public."performance_standards" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "standards_insert" on public."performance_standards";
create policy "standards_insert" on public."performance_standards" as permissive for insert to "authenticated" with check (((private.my_bms_role() = 'ADMIN'::bms_role) AND (EXISTS ( SELECT 1
   FROM contracts k
  WHERE (k.id = performance_standards.contract_id)))));
drop policy if exists "standards_read" on public."performance_standards";
create policy "standards_read" on public."performance_standards" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "standards_update" on public."performance_standards";
create policy "standards_update" on public."performance_standards" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_full_access" on public."production_abk_result_sizes";
create policy "admin_full_access" on public."production_abk_result_sizes" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "prod_abk_size_delete" on public."production_abk_result_sizes";
create policy "prod_abk_size_delete" on public."production_abk_result_sizes" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_abk_results r
  WHERE ((r.id = production_abk_result_sizes.result_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "prod_abk_size_insert" on public."production_abk_result_sizes";
create policy "prod_abk_size_insert" on public."production_abk_result_sizes" as permissive for insert to "authenticated" with check ((EXISTS ( SELECT 1
   FROM production_abk_results r
  WHERE ((r.id = production_abk_result_sizes.result_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "prod_abk_size_select" on public."production_abk_result_sizes";
create policy "prod_abk_size_select" on public."production_abk_result_sizes" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_abk_results r
  WHERE ((r.id = production_abk_result_sizes.result_id) AND private.can_read_assignment(r.contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "prod_abk_size_update" on public."production_abk_result_sizes";
create policy "prod_abk_size_update" on public."production_abk_result_sizes" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_abk_results r
  WHERE ((r.id = production_abk_result_sizes.result_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]))))) with check ((EXISTS ( SELECT 1
   FROM production_abk_results r
  WHERE ((r.id = production_abk_result_sizes.result_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "admin_full_access" on public."production_abk_results";
create policy "admin_full_access" on public."production_abk_results" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "prod_abk_delete" on public."production_abk_results";
create policy "prod_abk_delete" on public."production_abk_results" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "prod_abk_insert" on public."production_abk_results";
create policy "prod_abk_insert" on public."production_abk_results" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "prod_abk_select" on public."production_abk_results";
create policy "prod_abk_select" on public."production_abk_results" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))));
drop policy if exists "prod_abk_update" on public."production_abk_results";
create policy "prod_abk_update" on public."production_abk_results" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "admin_full_access" on public."production_estimate_sizes";
create policy "admin_full_access" on public."production_estimate_sizes" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "prod_est_size_delete" on public."production_estimate_sizes";
create policy "prod_est_size_delete" on public."production_estimate_sizes" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_estimates e
  WHERE ((e.id = production_estimate_sizes.estimate_id) AND private.can_edit_assignment(e.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "prod_est_size_insert" on public."production_estimate_sizes";
create policy "prod_est_size_insert" on public."production_estimate_sizes" as permissive for insert to "authenticated" with check ((EXISTS ( SELECT 1
   FROM production_estimates e
  WHERE ((e.id = production_estimate_sizes.estimate_id) AND private.can_edit_assignment(e.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "prod_est_size_select" on public."production_estimate_sizes";
create policy "prod_est_size_select" on public."production_estimate_sizes" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_estimates e
  WHERE ((e.id = production_estimate_sizes.estimate_id) AND private.can_read_assignment(e.contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'MARKETING'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "prod_est_size_update" on public."production_estimate_sizes";
create policy "prod_est_size_update" on public."production_estimate_sizes" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM production_estimates e
  WHERE ((e.id = production_estimate_sizes.estimate_id) AND private.can_edit_assignment(e.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]))))) with check ((EXISTS ( SELECT 1
   FROM production_estimates e
  WHERE ((e.id = production_estimate_sizes.estimate_id) AND private.can_edit_assignment(e.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "admin_full_access" on public."production_estimates";
create policy "admin_full_access" on public."production_estimates" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "prod_est_delete" on public."production_estimates";
create policy "prod_est_delete" on public."production_estimates" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "prod_est_insert" on public."production_estimates";
create policy "prod_est_insert" on public."production_estimates" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "prod_est_select" on public."production_estimates";
create policy "prod_est_select" on public."production_estimates" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'MARKETING'::bms_role, 'OWNER'::bms_role]))));
drop policy if exists "prod_est_update" on public."production_estimates";
create policy "prod_est_update" on public."production_estimates" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "admin_full_access" on public."profiles";
create policy "admin_full_access" on public."profiles" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "profiles_read" on public."profiles";
create policy "profiles_read" on public."profiles" as permissive for select to "authenticated" using (((user_id = ( SELECT auth.uid() AS uid)) OR (private.my_bms_role() = 'ADMIN'::bms_role)));
drop policy if exists "admin_full_access" on public."recording_weight_samples";
create policy "admin_full_access" on public."recording_weight_samples" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "recording_samples_delete" on public."recording_weight_samples";
create policy "recording_samples_delete" on public."recording_weight_samples" as permissive for delete to "authenticated" using ((EXISTS ( SELECT 1
   FROM recordings r
  WHERE ((r.id = recording_weight_samples.recording_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "recording_samples_insert" on public."recording_weight_samples";
create policy "recording_samples_insert" on public."recording_weight_samples" as permissive for insert to "authenticated" with check ((EXISTS ( SELECT 1
   FROM recordings r
  WHERE ((r.id = recording_weight_samples.recording_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "recording_samples_select" on public."recording_weight_samples";
create policy "recording_samples_select" on public."recording_weight_samples" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM recordings r
  WHERE ((r.id = recording_weight_samples.recording_id) AND private.can_read_assignment(r.contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "recording_samples_update" on public."recording_weight_samples";
create policy "recording_samples_update" on public."recording_weight_samples" as permissive for update to "authenticated" using ((EXISTS ( SELECT 1
   FROM recordings r
  WHERE ((r.id = recording_weight_samples.recording_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]))))) with check ((EXISTS ( SELECT 1
   FROM recordings r
  WHERE ((r.id = recording_weight_samples.recording_id) AND private.can_edit_assignment(r.contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])))));
drop policy if exists "admin_full_access" on public."recordings";
create policy "admin_full_access" on public."recordings" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "recording_delete" on public."recordings";
create policy "recording_delete" on public."recordings" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "recording_insert" on public."recordings";
create policy "recording_insert" on public."recordings" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "recording_read" on public."recordings";
create policy "recording_read" on public."recordings" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))));
drop policy if exists "recording_update" on public."recordings";
create policy "recording_update" on public."recordings" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "admin_full_access" on public."rhpp_estimates";
create policy "admin_full_access" on public."rhpp_estimates" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "rhpp_est_assignment_delete" on public."rhpp_estimates";
create policy "rhpp_est_assignment_delete" on public."rhpp_estimates" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "rhpp_est_assignment_insert" on public."rhpp_estimates";
create policy "rhpp_est_assignment_insert" on public."rhpp_estimates" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "rhpp_est_assignment_read" on public."rhpp_estimates";
create policy "rhpp_est_assignment_read" on public."rhpp_estimates" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]))));
drop policy if exists "rhpp_est_assignment_update" on public."rhpp_estimates";
create policy "rhpp_est_assignment_update" on public."rhpp_estimates" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "admin_full_access" on public."rhpp_real";
create policy "admin_full_access" on public."rhpp_real" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "rhpp_assignment_delete" on public."rhpp_real";
create policy "rhpp_assignment_delete" on public."rhpp_real" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role]));
drop policy if exists "rhpp_assignment_insert" on public."rhpp_real";
create policy "rhpp_assignment_insert" on public."rhpp_real" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role]));
drop policy if exists "rhpp_assignment_read" on public."rhpp_real";
create policy "rhpp_assignment_read" on public."rhpp_real" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'OWNER'::bms_role, 'KEUANGAN'::bms_role]))));
drop policy if exists "rhpp_assignment_update" on public."rhpp_real";
create policy "rhpp_assignment_update" on public."rhpp_real" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role]));
drop policy if exists "admin_full_access" on public."rhpp_system_final";
create policy "admin_full_access" on public."rhpp_system_final" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "rhpp_system_final_read" on public."rhpp_system_final";
create policy "rhpp_system_final_read" on public."rhpp_system_final" as permissive for select to "authenticated" using ((EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND p.active AND (p.role = ANY (ARRAY['ADMIN'::bms_role, 'KEUANGAN'::bms_role, 'OWNER'::bms_role]))))));
drop policy if exists "admin_full_access" on public."suppliers";
create policy "admin_full_access" on public."suppliers" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "admin_suppliers_insert" on public."suppliers";
create policy "admin_suppliers_insert" on public."suppliers" as permissive for insert to "authenticated" with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "admin_suppliers_update" on public."suppliers";
create policy "admin_suppliers_update" on public."suppliers" as permissive for update to "authenticated" using ((private.my_bms_role() = 'ADMIN'::bms_role)) with check ((private.my_bms_role() = 'ADMIN'::bms_role));
drop policy if exists "suppliers_read" on public."suppliers";
create policy "suppliers_read" on public."suppliers" as permissive for select to "authenticated" using ((private.my_bms_role() IS NOT NULL));
drop policy if exists "admin_full_access" on public."supplies";
create policy "admin_full_access" on public."supplies" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "supplies_assignment_insert" on public."supplies";
create policy "supplies_assignment_insert" on public."supplies" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]));
drop policy if exists "supplies_assignment_read" on public."supplies";
create policy "supplies_assignment_read" on public."supplies" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (private.my_bms_role() = ANY (ARRAY['ADMIN'::bms_role, 'LOGISTIK'::bms_role]))));
drop policy if exists "admin_full_access" on public."visits";
create policy "admin_full_access" on public."visits" as permissive for all to "authenticated" using ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role)) with check ((( SELECT private.my_bms_role() AS my_bms_role) = 'ADMIN'::bms_role));
drop policy if exists "visit_delete" on public."visits";
create policy "visit_delete" on public."visits" as permissive for delete to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "visit_insert" on public."visits";
create policy "visit_insert" on public."visits" as permissive for insert to "authenticated" with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));
drop policy if exists "visit_read" on public."visits";
create policy "visit_read" on public."visits" as permissive for select to "authenticated" using ((private.can_read_assignment(contract_assignment_id) AND (( SELECT private.my_bms_role() AS my_bms_role) = ANY (ARRAY['ADMIN'::bms_role, 'PPL'::bms_role, 'OWNER'::bms_role]))));
drop policy if exists "visit_update" on public."visits";
create policy "visit_update" on public."visits" as permissive for update to "authenticated" using (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role])) with check (private.can_edit_assignment(contract_assignment_id, ARRAY['ADMIN'::bms_role, 'PPL'::bms_role]));

-- TRIGGERS
drop trigger if exists "trg_abk_salary_auto_reference" on public."abk_cycle_salaries";
CREATE TRIGGER trg_abk_salary_auto_reference BEFORE INSERT ON abk_cycle_salaries FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('GAJI-ABK', 'paid_on');
drop trigger if exists "guard_advance_payment" on public."advance_payments";
CREATE TRIGGER guard_advance_payment BEFORE INSERT ON advance_payments FOR EACH ROW EXECUTE FUNCTION check_advance_payment();
drop trigger if exists "trg_advance_payments_auto_reference" on public."advance_payments";
CREATE TRIGGER trg_advance_payments_auto_reference BEFORE INSERT ON advance_payments FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('CICILAN', 'paid_on');
drop trigger if exists "audit_advances" on public."advances";
CREATE TRIGGER audit_advances AFTER INSERT OR DELETE OR UPDATE ON advances FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "trg_advances_auto_reference" on public."advances";
CREATE TRIGGER trg_advances_auto_reference BEFORE INSERT ON advances FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('KASBON', 'advanced_on');
drop trigger if exists "assign_master_auto_code" on public."barns";
CREATE TRIGGER assign_master_auto_code BEFORE INSERT ON barns FOR EACH ROW EXECUTE FUNCTION assign_master_auto_code();
drop trigger if exists "audit_barns" on public."barns";
CREATE TRIGGER audit_barns AFTER INSERT OR UPDATE ON barns FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "guard_barn_update" on public."barns";
CREATE TRIGGER guard_barn_update BEFORE UPDATE ON barns FOR EACH ROW EXECUTE FUNCTION guard_barn_update();
drop trigger if exists "protect_master_auto_code" on public."barns";
CREATE TRIGGER protect_master_auto_code BEFORE UPDATE OF code ON barns FOR EACH ROW EXECUTE FUNCTION protect_master_auto_code();
drop trigger if exists "trg_assignment_bop" on public."bop";
CREATE TRIGGER trg_assignment_bop BEFORE INSERT OR DELETE OR UPDATE ON bop FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_operation();
drop trigger if exists "trg_bop_auto_reference" on public."bop";
CREATE TRIGGER trg_bop_auto_reference BEFORE INSERT ON bop FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('BOP-KDG', 'incurred_on');
drop trigger if exists "trg_sync_bop_assignment_barn" on public."bop";
CREATE TRIGGER trg_sync_bop_assignment_barn BEFORE INSERT OR UPDATE OF contract_assignment_id ON bop FOR EACH ROW EXECUTE FUNCTION private.sync_bop_assignment_barn();
drop trigger if exists "trg_bop_outside_auto_reference" on public."bop_outside";
CREATE TRIGGER trg_bop_outside_auto_reference BEFORE INSERT ON bop_outside FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('BOP-UMUM', 'incurred_on');
drop trigger if exists "bms_lock_closed_assignment" on public."chick_ins";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON chick_ins FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "compute_chickin_avg_weight" on public."chick_ins";
CREATE TRIGGER compute_chickin_avg_weight BEFORE INSERT OR UPDATE OF sample_count, sample_weight_total_g ON chick_ins FOR EACH ROW EXECUTE FUNCTION compute_chickin_avg_weight();
drop trigger if exists "trg_guard_chick_in_contract" on public."chick_ins";
CREATE TRIGGER trg_guard_chick_in_contract BEFORE INSERT OR DELETE OR UPDATE ON chick_ins FOR EACH ROW EXECUTE FUNCTION private.guard_chick_in_contract();
drop trigger if exists "audit_company_profile" on public."company_profile";
CREATE TRIGGER audit_company_profile AFTER INSERT OR DELETE OR UPDATE ON company_profile FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "guard_bonuses" on public."contract_bonuses";
CREATE TRIGGER guard_bonuses BEFORE INSERT ON contract_bonuses FOR EACH ROW EXECUTE FUNCTION guard_contract_detail();
drop trigger if exists "protect_frozen_bonuses" on public."contract_bonuses";
CREATE TRIGGER protect_frozen_bonuses BEFORE DELETE OR UPDATE ON contract_bonuses FOR EACH ROW EXECUTE FUNCTION protect_frozen_contract_detail();
drop trigger if exists "guard_live_prices" on public."contract_live_prices";
CREATE TRIGGER guard_live_prices BEFORE INSERT ON contract_live_prices FOR EACH ROW EXECUTE FUNCTION guard_contract_detail();
drop trigger if exists "protect_frozen_live_prices" on public."contract_live_prices";
CREATE TRIGGER protect_frozen_live_prices BEFORE DELETE OR UPDATE ON contract_live_prices FOR EACH ROW EXECUTE FUNCTION protect_frozen_contract_detail();
drop trigger if exists "guard_contracts" on public."contracts";
CREATE TRIGGER guard_contracts BEFORE INSERT OR DELETE OR UPDATE ON contracts FOR EACH ROW EXECUTE FUNCTION audit_and_guard();
drop trigger if exists "protect_frozen_contract" on public."contracts";
CREATE TRIGGER protect_frozen_contract BEFORE DELETE OR UPDATE ON contracts FOR EACH ROW WHEN (old.cycle_id IS NOT NULL AND old.frozen_at IS NOT NULL) EXECUTE FUNCTION protect_frozen_contract();
drop trigger if exists "assign_master_auto_code" on public."cycles";
CREATE TRIGGER assign_master_auto_code BEFORE INSERT ON cycles FOR EACH ROW EXECUTE FUNCTION assign_master_auto_code();
drop trigger if exists "audit_cycles" on public."cycles";
CREATE TRIGGER audit_cycles AFTER INSERT OR DELETE OR UPDATE ON cycles FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "protect_master_auto_code" on public."cycles";
CREATE TRIGGER protect_master_auto_code BEFORE UPDATE OF code ON cycles FOR EACH ROW EXECUTE FUNCTION protect_master_auto_code();
drop trigger if exists "assign_master_auto_code" on public."employees";
CREATE TRIGGER assign_master_auto_code BEFORE INSERT ON employees FOR EACH ROW EXECUTE FUNCTION assign_master_auto_code();
drop trigger if exists "audit_employees" on public."employees";
CREATE TRIGGER audit_employees AFTER INSERT OR DELETE OR UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "prevent_employee_delete" on public."employees";
CREATE TRIGGER prevent_employee_delete BEFORE DELETE ON employees FOR EACH ROW EXECUTE FUNCTION prevent_employee_delete();
drop trigger if exists "protect_master_auto_code" on public."employees";
CREATE TRIGGER protect_master_auto_code BEFORE UPDATE OF code ON employees FOR EACH ROW EXECUTE FUNCTION protect_master_auto_code();
drop trigger if exists "reassign_employee_code_on_kind_change" on public."employees";
CREATE TRIGGER reassign_employee_code_on_kind_change BEFORE UPDATE OF kind ON employees FOR EACH ROW WHEN (old.kind IS DISTINCT FROM new.kind) EXECUTE FUNCTION reassign_employee_code_on_kind_change();
drop trigger if exists "bms_lock_closed_assignment" on public."expeditions";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON expeditions FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_assignment_expeditions" on public."expeditions";
CREATE TRIGGER trg_assignment_expeditions BEFORE INSERT OR DELETE OR UPDATE ON expeditions FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_operation();
drop trigger if exists "trg_fx_bop_auto_reference" on public."finance_expedition_bop";
CREATE TRIGGER trg_fx_bop_auto_reference BEFORE INSERT ON finance_expedition_bop FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('BOP-EXP', 'incurred_on');
drop trigger if exists "trg_fx_payment_auto_reference" on public."finance_expedition_payments";
CREATE TRIGGER trg_fx_payment_auto_reference BEFORE INSERT ON finance_expedition_payments FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('PAY-EXP', 'paid_on');
drop trigger if exists "trg_fx_trip_auto_reference" on public."finance_expedition_trips";
CREATE TRIGGER trg_fx_trip_auto_reference BEFORE INSERT ON finance_expedition_trips FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('TRIP-EXP', 'trip_date');
drop trigger if exists "bms_lock_closed_assignment" on public."harvests";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON harvests FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_assignment_harvests" on public."harvests";
CREATE TRIGGER trg_assignment_harvests BEFORE INSERT OR DELETE OR UPDATE ON harvests FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_operation();
drop trigger if exists "assign_master_auto_code" on public."items";
CREATE TRIGGER assign_master_auto_code BEFORE INSERT ON items FOR EACH ROW EXECUTE FUNCTION assign_master_auto_code();
drop trigger if exists "audit_items" on public."items";
CREATE TRIGGER audit_items AFTER INSERT OR DELETE OR UPDATE ON items FOR EACH ROW EXECUTE FUNCTION audit_master_change();
drop trigger if exists "normalize_item_unit" on public."items";
CREATE TRIGGER normalize_item_unit BEFORE INSERT OR UPDATE OF category, unit ON items FOR EACH ROW EXECUTE FUNCTION normalize_item_unit();
drop trigger if exists "protect_master_auto_code" on public."items";
CREATE TRIGGER protect_master_auto_code BEFORE UPDATE OF code ON items FOR EACH ROW EXECUTE FUNCTION protect_master_auto_code();
drop trigger if exists "trg_guard_item_supplier_type" on public."items";
CREATE TRIGGER trg_guard_item_supplier_type BEFORE INSERT OR UPDATE OF supplier_id ON items FOR EACH ROW EXECUTE FUNCTION private.guard_item_supplier_type();
drop trigger if exists "bms_lock_closed_assignment" on public."logistics_contract_assignment_abks";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON logistics_contract_assignment_abks FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_prevent_locked_abk_basics_change" on public."logistics_contract_assignment_abks";
CREATE TRIGGER trg_prevent_locked_abk_basics_change BEFORE UPDATE ON logistics_contract_assignment_abks FOR EACH ROW EXECUTE FUNCTION prevent_locked_abk_basics_change();
drop trigger if exists "bms_guard_contract_assignment_state" on public."logistics_contract_assignments";
CREATE TRIGGER bms_guard_contract_assignment_state BEFORE UPDATE ON logistics_contract_assignments FOR EACH ROW EXECUTE FUNCTION private.guard_contract_assignment_state();
drop trigger if exists "guard_logistics_contract_close_prices" on public."logistics_contract_assignments";
CREATE TRIGGER guard_logistics_contract_close_prices BEFORE UPDATE OF active ON logistics_contract_assignments FOR EACH ROW EXECUTE FUNCTION guard_logistics_contract_close_prices();
drop trigger if exists "prepare_logistics_contract_assignment" on public."logistics_contract_assignments";
CREATE TRIGGER prepare_logistics_contract_assignment BEFORE INSERT ON logistics_contract_assignments FOR EACH ROW EXECUTE FUNCTION prepare_logistics_contract_assignment();
drop trigger if exists "trg_guard_logistics_assignment_close" on public."logistics_contract_assignments";
CREATE TRIGGER trg_guard_logistics_assignment_close BEFORE UPDATE OF active ON logistics_contract_assignments FOR EACH ROW EXECUTE FUNCTION private.guard_logistics_assignment_close();
drop trigger if exists "trg_validate_assignment_ppl" on public."logistics_contract_assignments";
CREATE TRIGGER trg_validate_assignment_ppl BEFORE INSERT OR UPDATE OF ppl_id ON logistics_contract_assignments FOR EACH ROW EXECUTE FUNCTION private.validate_assignment_ppl();
drop trigger if exists "bms_lock_closed_assignment_child" on public."logistics_external_return_items";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_return_items FOR EACH ROW EXECUTE FUNCTION private.reject_closed_logistics_child_write();
drop trigger if exists "bms_lock_closed_transfer" on public."logistics_external_return_transfers";
CREATE TRIGGER bms_lock_closed_transfer BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_return_transfers FOR EACH ROW EXECUTE FUNCTION private.reject_closed_transfer_write();
drop trigger if exists "bms_lock_closed_assignment" on public."logistics_external_returns";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_returns FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "bms_lock_closed_assignment_child" on public."logistics_external_shipment_items";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_shipment_items FOR EACH ROW EXECUTE FUNCTION private.reject_closed_logistics_child_write();
drop trigger if exists "trg_fill_external_shipment_quantity_kg" on public."logistics_external_shipment_items";
CREATE TRIGGER trg_fill_external_shipment_quantity_kg BEFORE INSERT OR UPDATE OF item_id, quantity ON logistics_external_shipment_items FOR EACH ROW EXECUTE FUNCTION fill_external_shipment_quantity_kg();
drop trigger if exists "trg_guard_logistics_external_item" on public."logistics_external_shipment_items";
CREATE TRIGGER trg_guard_logistics_external_item BEFORE INSERT OR UPDATE ON logistics_external_shipment_items FOR EACH ROW EXECUTE FUNCTION private.guard_logistics_external_item();
drop trigger if exists "bms_lock_closed_assignment" on public."logistics_external_shipments";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_shipments FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_logistics_external_header" on public."logistics_external_shipments";
CREATE TRIGGER trg_guard_logistics_external_header BEFORE INSERT OR DELETE OR UPDATE ON logistics_external_shipments FOR EACH ROW EXECUTE FUNCTION private.guard_logistics_external_header();
drop trigger if exists "autofill_logistics_return_price" on public."logistics_return_items";
CREATE TRIGGER autofill_logistics_return_price BEFORE INSERT OR UPDATE OF return_id, item_id, unit_price ON logistics_return_items FOR EACH ROW EXECUTE FUNCTION autofill_logistics_return_price();
drop trigger if exists "bms_lock_closed_assignment_child" on public."logistics_return_items";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON logistics_return_items FOR EACH ROW EXECUTE FUNCTION private.reject_closed_logistics_child_write();
drop trigger if exists "guard_logistics_return_item" on public."logistics_return_items";
CREATE TRIGGER guard_logistics_return_item BEFORE INSERT OR DELETE OR UPDATE ON logistics_return_items FOR EACH ROW EXECUTE FUNCTION guard_logistics_return_item();
drop trigger if exists "bms_lock_closed_assignment" on public."logistics_returns";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON logistics_returns FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "guard_logistics_return" on public."logistics_returns";
CREATE TRIGGER guard_logistics_return BEFORE INSERT OR UPDATE ON logistics_returns FOR EACH ROW EXECUTE FUNCTION guard_logistics_return();
drop trigger if exists "autofill_logistics_shipment_price" on public."logistics_shipment_items";
CREATE TRIGGER autofill_logistics_shipment_price BEFORE INSERT OR UPDATE OF shipment_id, item_id, unit_price ON logistics_shipment_items FOR EACH ROW EXECUTE FUNCTION autofill_logistics_shipment_price();
drop trigger if exists "bms_lock_closed_assignment_child" on public."logistics_shipment_items";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON logistics_shipment_items FOR EACH ROW EXECUTE FUNCTION private.reject_closed_logistics_child_write();
drop trigger if exists "guard_logistics_shipment_item" on public."logistics_shipment_items";
CREATE TRIGGER guard_logistics_shipment_item BEFORE INSERT OR DELETE OR UPDATE ON logistics_shipment_items FOR EACH ROW EXECUTE FUNCTION guard_logistics_shipment_item();
drop trigger if exists "bms_lock_closed_assignment" on public."logistics_shipments";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON logistics_shipments FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "guard_logistics_shipment" on public."logistics_shipments";
CREATE TRIGGER guard_logistics_shipment BEFORE INSERT OR UPDATE ON logistics_shipments FOR EACH ROW EXECUTE FUNCTION guard_logistics_shipment();
drop trigger if exists "bms_lock_closed_assignment" on public."marketing_contract_harvests";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON marketing_contract_harvests FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_marketing_harvest" on public."marketing_contract_harvests";
CREATE TRIGGER trg_guard_marketing_harvest BEFORE INSERT OR DELETE OR UPDATE ON marketing_contract_harvests FOR EACH ROW EXECUTE FUNCTION private.guard_marketing_harvest();
drop trigger if exists "bms_lock_closed_assignment" on public."marketing_external_meat_purchases";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON marketing_external_meat_purchases FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_marketing_meat" on public."marketing_external_meat_purchases";
CREATE TRIGGER trg_guard_marketing_meat BEFORE INSERT OR DELETE OR UPDATE ON marketing_external_meat_purchases FOR EACH ROW EXECUTE FUNCTION private.guard_marketing_meat();
drop trigger if exists "guard_standards" on public."performance_standards";
CREATE TRIGGER guard_standards BEFORE INSERT ON performance_standards FOR EACH ROW EXECUTE FUNCTION guard_contract_detail();
drop trigger if exists "protect_frozen_standards" on public."performance_standards";
CREATE TRIGGER protect_frozen_standards BEFORE DELETE OR UPDATE ON performance_standards FOR EACH ROW EXECUTE FUNCTION protect_frozen_contract_detail();
drop trigger if exists "bms_lock_closed_assignment_child" on public."production_abk_result_sizes";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON production_abk_result_sizes FOR EACH ROW EXECUTE FUNCTION private.reject_closed_production_child_write();
drop trigger if exists "bms_lock_closed_assignment" on public."production_abk_results";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON production_abk_results FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_production_abk_result" on public."production_abk_results";
CREATE TRIGGER trg_guard_production_abk_result BEFORE INSERT OR DELETE OR UPDATE ON production_abk_results FOR EACH ROW EXECUTE FUNCTION private.guard_production_abk_result();
drop trigger if exists "bms_lock_closed_assignment_child" on public."production_estimate_sizes";
CREATE TRIGGER bms_lock_closed_assignment_child BEFORE INSERT OR DELETE OR UPDATE ON production_estimate_sizes FOR EACH ROW EXECUTE FUNCTION private.reject_closed_production_child_write();
drop trigger if exists "bms_lock_closed_assignment" on public."production_estimates";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON production_estimates FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_production_estimate" on public."production_estimates";
CREATE TRIGGER trg_guard_production_estimate BEFORE INSERT OR DELETE OR UPDATE ON production_estimates FOR EACH ROW EXECUTE FUNCTION private.guard_production_estimate();
drop trigger if exists "bms_lock_closed_assignment" on public."recordings";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON recordings FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "compute_recording_avg_weight" on public."recordings";
CREATE TRIGGER compute_recording_avg_weight BEFORE INSERT OR UPDATE OF sample_count, sample_weight_total_kg ON recordings FOR EACH ROW EXECUTE FUNCTION compute_recording_avg_weight();
drop trigger if exists "compute_recording_feed_kg" on public."recordings";
CREATE TRIGGER compute_recording_feed_kg BEFORE INSERT OR UPDATE OF feed_item_id, feed_bags_out ON recordings FOR EACH ROW EXECUTE FUNCTION compute_recording_feed_kg();
drop trigger if exists "trg_guard_production_recording" on public."recordings";
CREATE TRIGGER trg_guard_production_recording BEFORE INSERT OR DELETE OR UPDATE ON recordings FOR EACH ROW EXECUTE FUNCTION private.guard_production_recording();
drop trigger if exists "bms_lock_closed_assignment" on public."rhpp_estimates";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON rhpp_estimates FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_assignment_rhpp_estimates" on public."rhpp_estimates";
CREATE TRIGGER trg_assignment_rhpp_estimates BEFORE INSERT OR DELETE OR UPDATE ON rhpp_estimates FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_operation();
drop trigger if exists "trg_assignment_rhpp_real" on public."rhpp_real";
CREATE TRIGGER trg_assignment_rhpp_real BEFORE INSERT OR DELETE OR UPDATE ON rhpp_real FOR EACH ROW EXECUTE FUNCTION private.guard_rhpp_real_operation();
drop trigger if exists "trg_rhpp_real_auto_reference" on public."rhpp_real";
CREATE TRIGGER trg_rhpp_real_auto_reference BEFORE INSERT ON rhpp_real FOR EACH ROW EXECUTE FUNCTION finance_auto_reference_trigger('RHPP-REAL', 'received_on');
drop trigger if exists "trg_assign_supplier_code" on public."suppliers";
CREATE TRIGGER trg_assign_supplier_code BEFORE INSERT ON suppliers FOR EACH ROW EXECUTE FUNCTION assign_supplier_code();
drop trigger if exists "bms_lock_closed_assignment" on public."supplies";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON supplies FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "compute_supply_quantity_kg" on public."supplies";
CREATE TRIGGER compute_supply_quantity_kg BEFORE INSERT OR UPDATE OF item_id, quantity ON supplies FOR EACH ROW EXECUTE FUNCTION compute_supply_quantity_kg();
drop trigger if exists "trg_assignment_supplies" on public."supplies";
CREATE TRIGGER trg_assignment_supplies BEFORE INSERT OR DELETE OR UPDATE ON supplies FOR EACH ROW EXECUTE FUNCTION private.guard_assignment_operation();
drop trigger if exists "bms_lock_closed_assignment" on public."visits";
CREATE TRIGGER bms_lock_closed_assignment BEFORE INSERT OR DELETE OR UPDATE ON visits FOR EACH ROW EXECUTE FUNCTION private.reject_closed_assignment_write();
drop trigger if exists "trg_guard_production_visit" on public."visits";
CREATE TRIGGER trg_guard_production_visit BEFORE INSERT OR DELETE OR UPDATE ON visits FOR EACH ROW EXECUTE FUNCTION private.guard_production_visit();

-- TABLE/VIEW GRANTS
grant delete on table "public"."abk_cycle_salaries" to "anon";
grant insert on table "public"."abk_cycle_salaries" to "anon";
grant references on table "public"."abk_cycle_salaries" to "anon";
grant select on table "public"."abk_cycle_salaries" to "anon";
grant trigger on table "public"."abk_cycle_salaries" to "anon";
grant truncate on table "public"."abk_cycle_salaries" to "anon";
grant update on table "public"."abk_cycle_salaries" to "anon";
grant delete on table "public"."abk_cycle_salaries" to "authenticated";
grant insert on table "public"."abk_cycle_salaries" to "authenticated";
grant references on table "public"."abk_cycle_salaries" to "authenticated";
grant select on table "public"."abk_cycle_salaries" to "authenticated";
grant trigger on table "public"."abk_cycle_salaries" to "authenticated";
grant truncate on table "public"."abk_cycle_salaries" to "authenticated";
grant update on table "public"."abk_cycle_salaries" to "authenticated";
grant delete on table "public"."abk_cycle_salaries" to "service_role";
grant insert on table "public"."abk_cycle_salaries" to "service_role";
grant references on table "public"."abk_cycle_salaries" to "service_role";
grant select on table "public"."abk_cycle_salaries" to "service_role";
grant trigger on table "public"."abk_cycle_salaries" to "service_role";
grant truncate on table "public"."abk_cycle_salaries" to "service_role";
grant update on table "public"."abk_cycle_salaries" to "service_role";
grant delete on table "public"."abk_league" to "anon";
grant insert on table "public"."abk_league" to "anon";
grant references on table "public"."abk_league" to "anon";
grant select on table "public"."abk_league" to "anon";
grant trigger on table "public"."abk_league" to "anon";
grant truncate on table "public"."abk_league" to "anon";
grant update on table "public"."abk_league" to "anon";
grant delete on table "public"."abk_league" to "authenticated";
grant insert on table "public"."abk_league" to "authenticated";
grant references on table "public"."abk_league" to "authenticated";
grant select on table "public"."abk_league" to "authenticated";
grant trigger on table "public"."abk_league" to "authenticated";
grant truncate on table "public"."abk_league" to "authenticated";
grant update on table "public"."abk_league" to "authenticated";
grant delete on table "public"."abk_league" to "service_role";
grant insert on table "public"."abk_league" to "service_role";
grant references on table "public"."abk_league" to "service_role";
grant select on table "public"."abk_league" to "service_role";
grant trigger on table "public"."abk_league" to "service_role";
grant truncate on table "public"."abk_league" to "service_role";
grant update on table "public"."abk_league" to "service_role";
grant delete on table "public"."abk_league_settings" to "anon";
grant insert on table "public"."abk_league_settings" to "anon";
grant references on table "public"."abk_league_settings" to "anon";
grant select on table "public"."abk_league_settings" to "anon";
grant trigger on table "public"."abk_league_settings" to "anon";
grant truncate on table "public"."abk_league_settings" to "anon";
grant update on table "public"."abk_league_settings" to "anon";
grant delete on table "public"."abk_league_settings" to "authenticated";
grant insert on table "public"."abk_league_settings" to "authenticated";
grant references on table "public"."abk_league_settings" to "authenticated";
grant select on table "public"."abk_league_settings" to "authenticated";
grant trigger on table "public"."abk_league_settings" to "authenticated";
grant truncate on table "public"."abk_league_settings" to "authenticated";
grant update on table "public"."abk_league_settings" to "authenticated";
grant delete on table "public"."abk_league_settings" to "service_role";
grant insert on table "public"."abk_league_settings" to "service_role";
grant references on table "public"."abk_league_settings" to "service_role";
grant select on table "public"."abk_league_settings" to "service_role";
grant trigger on table "public"."abk_league_settings" to "service_role";
grant truncate on table "public"."abk_league_settings" to "service_role";
grant update on table "public"."abk_league_settings" to "service_role";
grant delete on table "public"."advance_balances" to "authenticated";
grant insert on table "public"."advance_balances" to "authenticated";
grant select on table "public"."advance_balances" to "authenticated";
grant update on table "public"."advance_balances" to "authenticated";
grant delete on table "public"."advance_balances" to "service_role";
grant insert on table "public"."advance_balances" to "service_role";
grant references on table "public"."advance_balances" to "service_role";
grant select on table "public"."advance_balances" to "service_role";
grant trigger on table "public"."advance_balances" to "service_role";
grant truncate on table "public"."advance_balances" to "service_role";
grant update on table "public"."advance_balances" to "service_role";
grant delete on table "public"."advance_payments" to "authenticated";
grant insert on table "public"."advance_payments" to "authenticated";
grant select on table "public"."advance_payments" to "authenticated";
grant update on table "public"."advance_payments" to "authenticated";
grant delete on table "public"."advance_payments" to "service_role";
grant insert on table "public"."advance_payments" to "service_role";
grant references on table "public"."advance_payments" to "service_role";
grant select on table "public"."advance_payments" to "service_role";
grant trigger on table "public"."advance_payments" to "service_role";
grant truncate on table "public"."advance_payments" to "service_role";
grant update on table "public"."advance_payments" to "service_role";
grant delete on table "public"."advances" to "authenticated";
grant insert on table "public"."advances" to "authenticated";
grant select on table "public"."advances" to "authenticated";
grant update on table "public"."advances" to "authenticated";
grant delete on table "public"."advances" to "service_role";
grant insert on table "public"."advances" to "service_role";
grant references on table "public"."advances" to "service_role";
grant select on table "public"."advances" to "service_role";
grant trigger on table "public"."advances" to "service_role";
grant truncate on table "public"."advances" to "service_role";
grant update on table "public"."advances" to "service_role";
grant delete on table "public"."audit_events" to "authenticated";
grant insert on table "public"."audit_events" to "authenticated";
grant select on table "public"."audit_events" to "authenticated";
grant update on table "public"."audit_events" to "authenticated";
grant delete on table "public"."audit_events" to "service_role";
grant insert on table "public"."audit_events" to "service_role";
grant references on table "public"."audit_events" to "service_role";
grant select on table "public"."audit_events" to "service_role";
grant trigger on table "public"."audit_events" to "service_role";
grant truncate on table "public"."audit_events" to "service_role";
grant update on table "public"."audit_events" to "service_role";
grant delete on table "public"."barns" to "authenticated";
grant insert on table "public"."barns" to "authenticated";
grant select on table "public"."barns" to "authenticated";
grant update on table "public"."barns" to "authenticated";
grant delete on table "public"."barns" to "service_role";
grant insert on table "public"."barns" to "service_role";
grant references on table "public"."barns" to "service_role";
grant select on table "public"."barns" to "service_role";
grant trigger on table "public"."barns" to "service_role";
grant truncate on table "public"."barns" to "service_role";
grant update on table "public"."barns" to "service_role";
grant delete on table "public"."bop" to "authenticated";
grant insert on table "public"."bop" to "authenticated";
grant select on table "public"."bop" to "authenticated";
grant update on table "public"."bop" to "authenticated";
grant delete on table "public"."bop" to "service_role";
grant insert on table "public"."bop" to "service_role";
grant references on table "public"."bop" to "service_role";
grant select on table "public"."bop" to "service_role";
grant trigger on table "public"."bop" to "service_role";
grant truncate on table "public"."bop" to "service_role";
grant update on table "public"."bop" to "service_role";
grant delete on table "public"."bop_outside" to "anon";
grant insert on table "public"."bop_outside" to "anon";
grant references on table "public"."bop_outside" to "anon";
grant select on table "public"."bop_outside" to "anon";
grant trigger on table "public"."bop_outside" to "anon";
grant truncate on table "public"."bop_outside" to "anon";
grant update on table "public"."bop_outside" to "anon";
grant delete on table "public"."bop_outside" to "authenticated";
grant insert on table "public"."bop_outside" to "authenticated";
grant references on table "public"."bop_outside" to "authenticated";
grant select on table "public"."bop_outside" to "authenticated";
grant trigger on table "public"."bop_outside" to "authenticated";
grant truncate on table "public"."bop_outside" to "authenticated";
grant update on table "public"."bop_outside" to "authenticated";
grant delete on table "public"."bop_outside" to "service_role";
grant insert on table "public"."bop_outside" to "service_role";
grant references on table "public"."bop_outside" to "service_role";
grant select on table "public"."bop_outside" to "service_role";
grant trigger on table "public"."bop_outside" to "service_role";
grant truncate on table "public"."bop_outside" to "service_role";
grant update on table "public"."bop_outside" to "service_role";
grant delete on table "public"."chick_ins" to "authenticated";
grant insert on table "public"."chick_ins" to "authenticated";
grant select on table "public"."chick_ins" to "authenticated";
grant update on table "public"."chick_ins" to "authenticated";
grant delete on table "public"."chick_ins" to "service_role";
grant insert on table "public"."chick_ins" to "service_role";
grant references on table "public"."chick_ins" to "service_role";
grant select on table "public"."chick_ins" to "service_role";
grant trigger on table "public"."chick_ins" to "service_role";
grant truncate on table "public"."chick_ins" to "service_role";
grant update on table "public"."chick_ins" to "service_role";
grant delete on table "public"."company_profile" to "authenticated";
grant insert on table "public"."company_profile" to "authenticated";
grant select on table "public"."company_profile" to "authenticated";
grant update on table "public"."company_profile" to "authenticated";
grant delete on table "public"."company_profile" to "service_role";
grant insert on table "public"."company_profile" to "service_role";
grant references on table "public"."company_profile" to "service_role";
grant select on table "public"."company_profile" to "service_role";
grant trigger on table "public"."company_profile" to "service_role";
grant truncate on table "public"."company_profile" to "service_role";
grant update on table "public"."company_profile" to "service_role";
grant delete on table "public"."contract_bonuses" to "authenticated";
grant insert on table "public"."contract_bonuses" to "authenticated";
grant select on table "public"."contract_bonuses" to "authenticated";
grant update on table "public"."contract_bonuses" to "authenticated";
grant delete on table "public"."contract_bonuses" to "service_role";
grant insert on table "public"."contract_bonuses" to "service_role";
grant references on table "public"."contract_bonuses" to "service_role";
grant select on table "public"."contract_bonuses" to "service_role";
grant trigger on table "public"."contract_bonuses" to "service_role";
grant truncate on table "public"."contract_bonuses" to "service_role";
grant update on table "public"."contract_bonuses" to "service_role";
grant delete on table "public"."contract_live_prices" to "authenticated";
grant insert on table "public"."contract_live_prices" to "authenticated";
grant select on table "public"."contract_live_prices" to "authenticated";
grant update on table "public"."contract_live_prices" to "authenticated";
grant delete on table "public"."contract_live_prices" to "service_role";
grant insert on table "public"."contract_live_prices" to "service_role";
grant references on table "public"."contract_live_prices" to "service_role";
grant select on table "public"."contract_live_prices" to "service_role";
grant trigger on table "public"."contract_live_prices" to "service_role";
grant truncate on table "public"."contract_live_prices" to "service_role";
grant update on table "public"."contract_live_prices" to "service_role";
grant delete on table "public"."contract_readiness" to "anon";
grant insert on table "public"."contract_readiness" to "anon";
grant references on table "public"."contract_readiness" to "anon";
grant select on table "public"."contract_readiness" to "anon";
grant trigger on table "public"."contract_readiness" to "anon";
grant truncate on table "public"."contract_readiness" to "anon";
grant update on table "public"."contract_readiness" to "anon";
grant delete on table "public"."contract_readiness" to "authenticated";
grant insert on table "public"."contract_readiness" to "authenticated";
grant references on table "public"."contract_readiness" to "authenticated";
grant select on table "public"."contract_readiness" to "authenticated";
grant trigger on table "public"."contract_readiness" to "authenticated";
grant truncate on table "public"."contract_readiness" to "authenticated";
grant update on table "public"."contract_readiness" to "authenticated";
grant delete on table "public"."contract_readiness" to "service_role";
grant insert on table "public"."contract_readiness" to "service_role";
grant references on table "public"."contract_readiness" to "service_role";
grant select on table "public"."contract_readiness" to "service_role";
grant trigger on table "public"."contract_readiness" to "service_role";
grant truncate on table "public"."contract_readiness" to "service_role";
grant update on table "public"."contract_readiness" to "service_role";
grant delete on table "public"."contracts" to "authenticated";
grant insert on table "public"."contracts" to "authenticated";
grant select on table "public"."contracts" to "authenticated";
grant update on table "public"."contracts" to "authenticated";
grant delete on table "public"."contracts" to "service_role";
grant insert on table "public"."contracts" to "service_role";
grant references on table "public"."contracts" to "service_role";
grant select on table "public"."contracts" to "service_role";
grant trigger on table "public"."contracts" to "service_role";
grant truncate on table "public"."contracts" to "service_role";
grant update on table "public"."contracts" to "service_role";
grant delete on table "public"."cycle_financials" to "authenticated";
grant insert on table "public"."cycle_financials" to "authenticated";
grant select on table "public"."cycle_financials" to "authenticated";
grant update on table "public"."cycle_financials" to "authenticated";
grant delete on table "public"."cycle_financials" to "service_role";
grant insert on table "public"."cycle_financials" to "service_role";
grant references on table "public"."cycle_financials" to "service_role";
grant select on table "public"."cycle_financials" to "service_role";
grant trigger on table "public"."cycle_financials" to "service_role";
grant truncate on table "public"."cycle_financials" to "service_role";
grant update on table "public"."cycle_financials" to "service_role";
grant delete on table "public"."cycle_performance" to "anon";
grant insert on table "public"."cycle_performance" to "anon";
grant references on table "public"."cycle_performance" to "anon";
grant select on table "public"."cycle_performance" to "anon";
grant trigger on table "public"."cycle_performance" to "anon";
grant truncate on table "public"."cycle_performance" to "anon";
grant update on table "public"."cycle_performance" to "anon";
grant delete on table "public"."cycle_performance" to "authenticated";
grant insert on table "public"."cycle_performance" to "authenticated";
grant references on table "public"."cycle_performance" to "authenticated";
grant select on table "public"."cycle_performance" to "authenticated";
grant trigger on table "public"."cycle_performance" to "authenticated";
grant truncate on table "public"."cycle_performance" to "authenticated";
grant update on table "public"."cycle_performance" to "authenticated";
grant delete on table "public"."cycle_performance" to "service_role";
grant insert on table "public"."cycle_performance" to "service_role";
grant references on table "public"."cycle_performance" to "service_role";
grant select on table "public"."cycle_performance" to "service_role";
grant trigger on table "public"."cycle_performance" to "service_role";
grant truncate on table "public"."cycle_performance" to "service_role";
grant update on table "public"."cycle_performance" to "service_role";
grant delete on table "public"."cycles" to "authenticated";
grant insert on table "public"."cycles" to "authenticated";
grant select on table "public"."cycles" to "authenticated";
grant update on table "public"."cycles" to "authenticated";
grant delete on table "public"."cycles" to "service_role";
grant insert on table "public"."cycles" to "service_role";
grant references on table "public"."cycles" to "service_role";
grant select on table "public"."cycles" to "service_role";
grant trigger on table "public"."cycles" to "service_role";
grant truncate on table "public"."cycles" to "service_role";
grant update on table "public"."cycles" to "service_role";
grant delete on table "public"."daily_performance" to "anon";
grant insert on table "public"."daily_performance" to "anon";
grant references on table "public"."daily_performance" to "anon";
grant select on table "public"."daily_performance" to "anon";
grant trigger on table "public"."daily_performance" to "anon";
grant truncate on table "public"."daily_performance" to "anon";
grant update on table "public"."daily_performance" to "anon";
grant delete on table "public"."daily_performance" to "authenticated";
grant insert on table "public"."daily_performance" to "authenticated";
grant references on table "public"."daily_performance" to "authenticated";
grant select on table "public"."daily_performance" to "authenticated";
grant trigger on table "public"."daily_performance" to "authenticated";
grant truncate on table "public"."daily_performance" to "authenticated";
grant update on table "public"."daily_performance" to "authenticated";
grant delete on table "public"."daily_performance" to "service_role";
grant insert on table "public"."daily_performance" to "service_role";
grant references on table "public"."daily_performance" to "service_role";
grant select on table "public"."daily_performance" to "service_role";
grant trigger on table "public"."daily_performance" to "service_role";
grant truncate on table "public"."daily_performance" to "service_role";
grant update on table "public"."daily_performance" to "service_role";
grant delete on table "public"."employees" to "authenticated";
grant insert on table "public"."employees" to "authenticated";
grant select on table "public"."employees" to "authenticated";
grant update on table "public"."employees" to "authenticated";
grant delete on table "public"."employees" to "service_role";
grant insert on table "public"."employees" to "service_role";
grant references on table "public"."employees" to "service_role";
grant select on table "public"."employees" to "service_role";
grant trigger on table "public"."employees" to "service_role";
grant truncate on table "public"."employees" to "service_role";
grant update on table "public"."employees" to "service_role";
grant delete on table "public"."expeditions" to "authenticated";
grant insert on table "public"."expeditions" to "authenticated";
grant select on table "public"."expeditions" to "authenticated";
grant update on table "public"."expeditions" to "authenticated";
grant delete on table "public"."expeditions" to "service_role";
grant insert on table "public"."expeditions" to "service_role";
grant references on table "public"."expeditions" to "service_role";
grant select on table "public"."expeditions" to "service_role";
grant trigger on table "public"."expeditions" to "service_role";
grant truncate on table "public"."expeditions" to "service_role";
grant update on table "public"."expeditions" to "service_role";
grant delete on table "public"."finance_expedition_bop" to "anon";
grant insert on table "public"."finance_expedition_bop" to "anon";
grant references on table "public"."finance_expedition_bop" to "anon";
grant select on table "public"."finance_expedition_bop" to "anon";
grant trigger on table "public"."finance_expedition_bop" to "anon";
grant truncate on table "public"."finance_expedition_bop" to "anon";
grant update on table "public"."finance_expedition_bop" to "anon";
grant delete on table "public"."finance_expedition_bop" to "authenticated";
grant insert on table "public"."finance_expedition_bop" to "authenticated";
grant references on table "public"."finance_expedition_bop" to "authenticated";
grant select on table "public"."finance_expedition_bop" to "authenticated";
grant trigger on table "public"."finance_expedition_bop" to "authenticated";
grant truncate on table "public"."finance_expedition_bop" to "authenticated";
grant update on table "public"."finance_expedition_bop" to "authenticated";
grant delete on table "public"."finance_expedition_bop" to "service_role";
grant insert on table "public"."finance_expedition_bop" to "service_role";
grant references on table "public"."finance_expedition_bop" to "service_role";
grant select on table "public"."finance_expedition_bop" to "service_role";
grant trigger on table "public"."finance_expedition_bop" to "service_role";
grant truncate on table "public"."finance_expedition_bop" to "service_role";
grant update on table "public"."finance_expedition_bop" to "service_role";
grant delete on table "public"."finance_expedition_invoice_items" to "anon";
grant insert on table "public"."finance_expedition_invoice_items" to "anon";
grant references on table "public"."finance_expedition_invoice_items" to "anon";
grant select on table "public"."finance_expedition_invoice_items" to "anon";
grant trigger on table "public"."finance_expedition_invoice_items" to "anon";
grant truncate on table "public"."finance_expedition_invoice_items" to "anon";
grant update on table "public"."finance_expedition_invoice_items" to "anon";
grant delete on table "public"."finance_expedition_invoice_items" to "authenticated";
grant insert on table "public"."finance_expedition_invoice_items" to "authenticated";
grant references on table "public"."finance_expedition_invoice_items" to "authenticated";
grant select on table "public"."finance_expedition_invoice_items" to "authenticated";
grant trigger on table "public"."finance_expedition_invoice_items" to "authenticated";
grant truncate on table "public"."finance_expedition_invoice_items" to "authenticated";
grant update on table "public"."finance_expedition_invoice_items" to "authenticated";
grant delete on table "public"."finance_expedition_invoice_items" to "service_role";
grant insert on table "public"."finance_expedition_invoice_items" to "service_role";
grant references on table "public"."finance_expedition_invoice_items" to "service_role";
grant select on table "public"."finance_expedition_invoice_items" to "service_role";
grant trigger on table "public"."finance_expedition_invoice_items" to "service_role";
grant truncate on table "public"."finance_expedition_invoice_items" to "service_role";
grant update on table "public"."finance_expedition_invoice_items" to "service_role";
grant delete on table "public"."finance_expedition_invoices" to "anon";
grant insert on table "public"."finance_expedition_invoices" to "anon";
grant references on table "public"."finance_expedition_invoices" to "anon";
grant select on table "public"."finance_expedition_invoices" to "anon";
grant trigger on table "public"."finance_expedition_invoices" to "anon";
grant truncate on table "public"."finance_expedition_invoices" to "anon";
grant update on table "public"."finance_expedition_invoices" to "anon";
grant delete on table "public"."finance_expedition_invoices" to "authenticated";
grant insert on table "public"."finance_expedition_invoices" to "authenticated";
grant references on table "public"."finance_expedition_invoices" to "authenticated";
grant select on table "public"."finance_expedition_invoices" to "authenticated";
grant trigger on table "public"."finance_expedition_invoices" to "authenticated";
grant truncate on table "public"."finance_expedition_invoices" to "authenticated";
grant update on table "public"."finance_expedition_invoices" to "authenticated";
grant delete on table "public"."finance_expedition_invoices" to "service_role";
grant insert on table "public"."finance_expedition_invoices" to "service_role";
grant references on table "public"."finance_expedition_invoices" to "service_role";
grant select on table "public"."finance_expedition_invoices" to "service_role";
grant trigger on table "public"."finance_expedition_invoices" to "service_role";
grant truncate on table "public"."finance_expedition_invoices" to "service_role";
grant update on table "public"."finance_expedition_invoices" to "service_role";
grant delete on table "public"."finance_expedition_payments" to "anon";
grant insert on table "public"."finance_expedition_payments" to "anon";
grant references on table "public"."finance_expedition_payments" to "anon";
grant select on table "public"."finance_expedition_payments" to "anon";
grant trigger on table "public"."finance_expedition_payments" to "anon";
grant truncate on table "public"."finance_expedition_payments" to "anon";
grant update on table "public"."finance_expedition_payments" to "anon";
grant delete on table "public"."finance_expedition_payments" to "authenticated";
grant insert on table "public"."finance_expedition_payments" to "authenticated";
grant references on table "public"."finance_expedition_payments" to "authenticated";
grant select on table "public"."finance_expedition_payments" to "authenticated";
grant trigger on table "public"."finance_expedition_payments" to "authenticated";
grant truncate on table "public"."finance_expedition_payments" to "authenticated";
grant update on table "public"."finance_expedition_payments" to "authenticated";
grant delete on table "public"."finance_expedition_payments" to "service_role";
grant insert on table "public"."finance_expedition_payments" to "service_role";
grant references on table "public"."finance_expedition_payments" to "service_role";
grant select on table "public"."finance_expedition_payments" to "service_role";
grant trigger on table "public"."finance_expedition_payments" to "service_role";
grant truncate on table "public"."finance_expedition_payments" to "service_role";
grant update on table "public"."finance_expedition_payments" to "service_role";
grant delete on table "public"."finance_expedition_trips" to "anon";
grant insert on table "public"."finance_expedition_trips" to "anon";
grant references on table "public"."finance_expedition_trips" to "anon";
grant select on table "public"."finance_expedition_trips" to "anon";
grant trigger on table "public"."finance_expedition_trips" to "anon";
grant truncate on table "public"."finance_expedition_trips" to "anon";
grant update on table "public"."finance_expedition_trips" to "anon";
grant delete on table "public"."finance_expedition_trips" to "authenticated";
grant insert on table "public"."finance_expedition_trips" to "authenticated";
grant references on table "public"."finance_expedition_trips" to "authenticated";
grant select on table "public"."finance_expedition_trips" to "authenticated";
grant trigger on table "public"."finance_expedition_trips" to "authenticated";
grant truncate on table "public"."finance_expedition_trips" to "authenticated";
grant update on table "public"."finance_expedition_trips" to "authenticated";
grant delete on table "public"."finance_expedition_trips" to "service_role";
grant insert on table "public"."finance_expedition_trips" to "service_role";
grant references on table "public"."finance_expedition_trips" to "service_role";
grant select on table "public"."finance_expedition_trips" to "service_role";
grant trigger on table "public"."finance_expedition_trips" to "service_role";
grant truncate on table "public"."finance_expedition_trips" to "service_role";
grant update on table "public"."finance_expedition_trips" to "service_role";
grant delete on table "public"."finance_reference_counters" to "anon";
grant insert on table "public"."finance_reference_counters" to "anon";
grant references on table "public"."finance_reference_counters" to "anon";
grant select on table "public"."finance_reference_counters" to "anon";
grant trigger on table "public"."finance_reference_counters" to "anon";
grant truncate on table "public"."finance_reference_counters" to "anon";
grant update on table "public"."finance_reference_counters" to "anon";
grant delete on table "public"."finance_reference_counters" to "authenticated";
grant insert on table "public"."finance_reference_counters" to "authenticated";
grant references on table "public"."finance_reference_counters" to "authenticated";
grant select on table "public"."finance_reference_counters" to "authenticated";
grant trigger on table "public"."finance_reference_counters" to "authenticated";
grant truncate on table "public"."finance_reference_counters" to "authenticated";
grant update on table "public"."finance_reference_counters" to "authenticated";
grant delete on table "public"."finance_reference_counters" to "service_role";
grant insert on table "public"."finance_reference_counters" to "service_role";
grant references on table "public"."finance_reference_counters" to "service_role";
grant select on table "public"."finance_reference_counters" to "service_role";
grant trigger on table "public"."finance_reference_counters" to "service_role";
grant truncate on table "public"."finance_reference_counters" to "service_role";
grant update on table "public"."finance_reference_counters" to "service_role";
grant delete on table "public"."harvest_contract_preview" to "anon";
grant insert on table "public"."harvest_contract_preview" to "anon";
grant references on table "public"."harvest_contract_preview" to "anon";
grant select on table "public"."harvest_contract_preview" to "anon";
grant trigger on table "public"."harvest_contract_preview" to "anon";
grant truncate on table "public"."harvest_contract_preview" to "anon";
grant update on table "public"."harvest_contract_preview" to "anon";
grant delete on table "public"."harvest_contract_preview" to "authenticated";
grant insert on table "public"."harvest_contract_preview" to "authenticated";
grant references on table "public"."harvest_contract_preview" to "authenticated";
grant select on table "public"."harvest_contract_preview" to "authenticated";
grant trigger on table "public"."harvest_contract_preview" to "authenticated";
grant truncate on table "public"."harvest_contract_preview" to "authenticated";
grant update on table "public"."harvest_contract_preview" to "authenticated";
grant delete on table "public"."harvest_contract_preview" to "service_role";
grant insert on table "public"."harvest_contract_preview" to "service_role";
grant references on table "public"."harvest_contract_preview" to "service_role";
grant select on table "public"."harvest_contract_preview" to "service_role";
grant trigger on table "public"."harvest_contract_preview" to "service_role";
grant truncate on table "public"."harvest_contract_preview" to "service_role";
grant update on table "public"."harvest_contract_preview" to "service_role";
grant delete on table "public"."harvests" to "authenticated";
grant insert on table "public"."harvests" to "authenticated";
grant select on table "public"."harvests" to "authenticated";
grant update on table "public"."harvests" to "authenticated";
grant delete on table "public"."harvests" to "service_role";
grant insert on table "public"."harvests" to "service_role";
grant references on table "public"."harvests" to "service_role";
grant select on table "public"."harvests" to "service_role";
grant trigger on table "public"."harvests" to "service_role";
grant truncate on table "public"."harvests" to "service_role";
grant update on table "public"."harvests" to "service_role";
grant delete on table "public"."items" to "authenticated";
grant insert on table "public"."items" to "authenticated";
grant select on table "public"."items" to "authenticated";
grant update on table "public"."items" to "authenticated";
grant delete on table "public"."items" to "service_role";
grant insert on table "public"."items" to "service_role";
grant references on table "public"."items" to "service_role";
grant select on table "public"."items" to "service_role";
grant trigger on table "public"."items" to "service_role";
grant truncate on table "public"."items" to "service_role";
grant update on table "public"."items" to "service_role";
grant delete on table "public"."logistics_company_adjustment_summary" to "anon";
grant insert on table "public"."logistics_company_adjustment_summary" to "anon";
grant references on table "public"."logistics_company_adjustment_summary" to "anon";
grant select on table "public"."logistics_company_adjustment_summary" to "anon";
grant trigger on table "public"."logistics_company_adjustment_summary" to "anon";
grant truncate on table "public"."logistics_company_adjustment_summary" to "anon";
grant update on table "public"."logistics_company_adjustment_summary" to "anon";
grant delete on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant insert on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant references on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant select on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant trigger on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant truncate on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant update on table "public"."logistics_company_adjustment_summary" to "authenticated";
grant delete on table "public"."logistics_company_adjustment_summary" to "service_role";
grant insert on table "public"."logistics_company_adjustment_summary" to "service_role";
grant references on table "public"."logistics_company_adjustment_summary" to "service_role";
grant select on table "public"."logistics_company_adjustment_summary" to "service_role";
grant trigger on table "public"."logistics_company_adjustment_summary" to "service_role";
grant truncate on table "public"."logistics_company_adjustment_summary" to "service_role";
grant update on table "public"."logistics_company_adjustment_summary" to "service_role";
grant delete on table "public"."logistics_contract_assignment_abks" to "anon";
grant insert on table "public"."logistics_contract_assignment_abks" to "anon";
grant references on table "public"."logistics_contract_assignment_abks" to "anon";
grant select on table "public"."logistics_contract_assignment_abks" to "anon";
grant trigger on table "public"."logistics_contract_assignment_abks" to "anon";
grant truncate on table "public"."logistics_contract_assignment_abks" to "anon";
grant update on table "public"."logistics_contract_assignment_abks" to "anon";
grant delete on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant insert on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant references on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant select on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant trigger on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant truncate on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant update on table "public"."logistics_contract_assignment_abks" to "authenticated";
grant delete on table "public"."logistics_contract_assignment_abks" to "service_role";
grant insert on table "public"."logistics_contract_assignment_abks" to "service_role";
grant references on table "public"."logistics_contract_assignment_abks" to "service_role";
grant select on table "public"."logistics_contract_assignment_abks" to "service_role";
grant trigger on table "public"."logistics_contract_assignment_abks" to "service_role";
grant truncate on table "public"."logistics_contract_assignment_abks" to "service_role";
grant update on table "public"."logistics_contract_assignment_abks" to "service_role";
grant insert on table "public"."logistics_contract_assignments" to "anon";
grant references on table "public"."logistics_contract_assignments" to "anon";
grant select on table "public"."logistics_contract_assignments" to "anon";
grant trigger on table "public"."logistics_contract_assignments" to "anon";
grant truncate on table "public"."logistics_contract_assignments" to "anon";
grant update on table "public"."logistics_contract_assignments" to "anon";
grant delete on table "public"."logistics_contract_assignments" to "authenticated";
grant insert on table "public"."logistics_contract_assignments" to "authenticated";
grant references on table "public"."logistics_contract_assignments" to "authenticated";
grant select on table "public"."logistics_contract_assignments" to "authenticated";
grant trigger on table "public"."logistics_contract_assignments" to "authenticated";
grant truncate on table "public"."logistics_contract_assignments" to "authenticated";
grant update on table "public"."logistics_contract_assignments" to "authenticated";
grant delete on table "public"."logistics_contract_assignments" to "service_role";
grant insert on table "public"."logistics_contract_assignments" to "service_role";
grant references on table "public"."logistics_contract_assignments" to "service_role";
grant select on table "public"."logistics_contract_assignments" to "service_role";
grant trigger on table "public"."logistics_contract_assignments" to "service_role";
grant truncate on table "public"."logistics_contract_assignments" to "service_role";
grant update on table "public"."logistics_contract_assignments" to "service_role";
grant delete on table "public"."logistics_external_return_items" to "anon";
grant insert on table "public"."logistics_external_return_items" to "anon";
grant references on table "public"."logistics_external_return_items" to "anon";
grant select on table "public"."logistics_external_return_items" to "anon";
grant trigger on table "public"."logistics_external_return_items" to "anon";
grant truncate on table "public"."logistics_external_return_items" to "anon";
grant update on table "public"."logistics_external_return_items" to "anon";
grant delete on table "public"."logistics_external_return_items" to "authenticated";
grant insert on table "public"."logistics_external_return_items" to "authenticated";
grant references on table "public"."logistics_external_return_items" to "authenticated";
grant select on table "public"."logistics_external_return_items" to "authenticated";
grant trigger on table "public"."logistics_external_return_items" to "authenticated";
grant truncate on table "public"."logistics_external_return_items" to "authenticated";
grant update on table "public"."logistics_external_return_items" to "authenticated";
grant delete on table "public"."logistics_external_return_items" to "service_role";
grant insert on table "public"."logistics_external_return_items" to "service_role";
grant references on table "public"."logistics_external_return_items" to "service_role";
grant select on table "public"."logistics_external_return_items" to "service_role";
grant trigger on table "public"."logistics_external_return_items" to "service_role";
grant truncate on table "public"."logistics_external_return_items" to "service_role";
grant update on table "public"."logistics_external_return_items" to "service_role";
grant delete on table "public"."logistics_external_return_transfers" to "anon";
grant insert on table "public"."logistics_external_return_transfers" to "anon";
grant references on table "public"."logistics_external_return_transfers" to "anon";
grant select on table "public"."logistics_external_return_transfers" to "anon";
grant trigger on table "public"."logistics_external_return_transfers" to "anon";
grant truncate on table "public"."logistics_external_return_transfers" to "anon";
grant update on table "public"."logistics_external_return_transfers" to "anon";
grant delete on table "public"."logistics_external_return_transfers" to "authenticated";
grant insert on table "public"."logistics_external_return_transfers" to "authenticated";
grant references on table "public"."logistics_external_return_transfers" to "authenticated";
grant select on table "public"."logistics_external_return_transfers" to "authenticated";
grant trigger on table "public"."logistics_external_return_transfers" to "authenticated";
grant truncate on table "public"."logistics_external_return_transfers" to "authenticated";
grant update on table "public"."logistics_external_return_transfers" to "authenticated";
grant delete on table "public"."logistics_external_return_transfers" to "service_role";
grant insert on table "public"."logistics_external_return_transfers" to "service_role";
grant references on table "public"."logistics_external_return_transfers" to "service_role";
grant select on table "public"."logistics_external_return_transfers" to "service_role";
grant trigger on table "public"."logistics_external_return_transfers" to "service_role";
grant truncate on table "public"."logistics_external_return_transfers" to "service_role";
grant update on table "public"."logistics_external_return_transfers" to "service_role";
grant delete on table "public"."logistics_external_returns" to "anon";
grant insert on table "public"."logistics_external_returns" to "anon";
grant references on table "public"."logistics_external_returns" to "anon";
grant select on table "public"."logistics_external_returns" to "anon";
grant trigger on table "public"."logistics_external_returns" to "anon";
grant truncate on table "public"."logistics_external_returns" to "anon";
grant update on table "public"."logistics_external_returns" to "anon";
grant delete on table "public"."logistics_external_returns" to "authenticated";
grant insert on table "public"."logistics_external_returns" to "authenticated";
grant references on table "public"."logistics_external_returns" to "authenticated";
grant select on table "public"."logistics_external_returns" to "authenticated";
grant trigger on table "public"."logistics_external_returns" to "authenticated";
grant truncate on table "public"."logistics_external_returns" to "authenticated";
grant update on table "public"."logistics_external_returns" to "authenticated";
grant delete on table "public"."logistics_external_returns" to "service_role";
grant insert on table "public"."logistics_external_returns" to "service_role";
grant references on table "public"."logistics_external_returns" to "service_role";
grant select on table "public"."logistics_external_returns" to "service_role";
grant trigger on table "public"."logistics_external_returns" to "service_role";
grant truncate on table "public"."logistics_external_returns" to "service_role";
grant update on table "public"."logistics_external_returns" to "service_role";
grant delete on table "public"."logistics_external_shipment_items" to "anon";
grant insert on table "public"."logistics_external_shipment_items" to "anon";
grant references on table "public"."logistics_external_shipment_items" to "anon";
grant select on table "public"."logistics_external_shipment_items" to "anon";
grant trigger on table "public"."logistics_external_shipment_items" to "anon";
grant truncate on table "public"."logistics_external_shipment_items" to "anon";
grant update on table "public"."logistics_external_shipment_items" to "anon";
grant delete on table "public"."logistics_external_shipment_items" to "authenticated";
grant insert on table "public"."logistics_external_shipment_items" to "authenticated";
grant references on table "public"."logistics_external_shipment_items" to "authenticated";
grant select on table "public"."logistics_external_shipment_items" to "authenticated";
grant trigger on table "public"."logistics_external_shipment_items" to "authenticated";
grant truncate on table "public"."logistics_external_shipment_items" to "authenticated";
grant update on table "public"."logistics_external_shipment_items" to "authenticated";
grant delete on table "public"."logistics_external_shipment_items" to "service_role";
grant insert on table "public"."logistics_external_shipment_items" to "service_role";
grant references on table "public"."logistics_external_shipment_items" to "service_role";
grant select on table "public"."logistics_external_shipment_items" to "service_role";
grant trigger on table "public"."logistics_external_shipment_items" to "service_role";
grant truncate on table "public"."logistics_external_shipment_items" to "service_role";
grant update on table "public"."logistics_external_shipment_items" to "service_role";
grant delete on table "public"."logistics_external_shipments" to "anon";
grant insert on table "public"."logistics_external_shipments" to "anon";
grant references on table "public"."logistics_external_shipments" to "anon";
grant select on table "public"."logistics_external_shipments" to "anon";
grant trigger on table "public"."logistics_external_shipments" to "anon";
grant truncate on table "public"."logistics_external_shipments" to "anon";
grant update on table "public"."logistics_external_shipments" to "anon";
grant delete on table "public"."logistics_external_shipments" to "authenticated";
grant insert on table "public"."logistics_external_shipments" to "authenticated";
grant references on table "public"."logistics_external_shipments" to "authenticated";
grant select on table "public"."logistics_external_shipments" to "authenticated";
grant trigger on table "public"."logistics_external_shipments" to "authenticated";
grant truncate on table "public"."logistics_external_shipments" to "authenticated";
grant update on table "public"."logistics_external_shipments" to "authenticated";
grant delete on table "public"."logistics_external_shipments" to "service_role";
grant insert on table "public"."logistics_external_shipments" to "service_role";
grant references on table "public"."logistics_external_shipments" to "service_role";
grant select on table "public"."logistics_external_shipments" to "service_role";
grant trigger on table "public"."logistics_external_shipments" to "service_role";
grant truncate on table "public"."logistics_external_shipments" to "service_role";
grant update on table "public"."logistics_external_shipments" to "service_role";
grant delete on table "public"."logistics_return_items" to "anon";
grant insert on table "public"."logistics_return_items" to "anon";
grant references on table "public"."logistics_return_items" to "anon";
grant select on table "public"."logistics_return_items" to "anon";
grant trigger on table "public"."logistics_return_items" to "anon";
grant truncate on table "public"."logistics_return_items" to "anon";
grant update on table "public"."logistics_return_items" to "anon";
grant delete on table "public"."logistics_return_items" to "authenticated";
grant insert on table "public"."logistics_return_items" to "authenticated";
grant references on table "public"."logistics_return_items" to "authenticated";
grant select on table "public"."logistics_return_items" to "authenticated";
grant trigger on table "public"."logistics_return_items" to "authenticated";
grant truncate on table "public"."logistics_return_items" to "authenticated";
grant update on table "public"."logistics_return_items" to "authenticated";
grant delete on table "public"."logistics_return_items" to "service_role";
grant insert on table "public"."logistics_return_items" to "service_role";
grant references on table "public"."logistics_return_items" to "service_role";
grant select on table "public"."logistics_return_items" to "service_role";
grant trigger on table "public"."logistics_return_items" to "service_role";
grant truncate on table "public"."logistics_return_items" to "service_role";
grant update on table "public"."logistics_return_items" to "service_role";
grant insert on table "public"."logistics_returns" to "anon";
grant references on table "public"."logistics_returns" to "anon";
grant select on table "public"."logistics_returns" to "anon";
grant trigger on table "public"."logistics_returns" to "anon";
grant truncate on table "public"."logistics_returns" to "anon";
grant update on table "public"."logistics_returns" to "anon";
grant delete on table "public"."logistics_returns" to "authenticated";
grant insert on table "public"."logistics_returns" to "authenticated";
grant references on table "public"."logistics_returns" to "authenticated";
grant select on table "public"."logistics_returns" to "authenticated";
grant trigger on table "public"."logistics_returns" to "authenticated";
grant truncate on table "public"."logistics_returns" to "authenticated";
grant update on table "public"."logistics_returns" to "authenticated";
grant delete on table "public"."logistics_returns" to "service_role";
grant insert on table "public"."logistics_returns" to "service_role";
grant references on table "public"."logistics_returns" to "service_role";
grant select on table "public"."logistics_returns" to "service_role";
grant trigger on table "public"."logistics_returns" to "service_role";
grant truncate on table "public"."logistics_returns" to "service_role";
grant update on table "public"."logistics_returns" to "service_role";
grant delete on table "public"."logistics_rhpp_cost_summary" to "anon";
grant insert on table "public"."logistics_rhpp_cost_summary" to "anon";
grant references on table "public"."logistics_rhpp_cost_summary" to "anon";
grant select on table "public"."logistics_rhpp_cost_summary" to "anon";
grant trigger on table "public"."logistics_rhpp_cost_summary" to "anon";
grant truncate on table "public"."logistics_rhpp_cost_summary" to "anon";
grant update on table "public"."logistics_rhpp_cost_summary" to "anon";
grant delete on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant insert on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant references on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant select on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant trigger on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant truncate on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant update on table "public"."logistics_rhpp_cost_summary" to "authenticated";
grant delete on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant insert on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant references on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant select on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant trigger on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant truncate on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant update on table "public"."logistics_rhpp_cost_summary" to "service_role";
grant delete on table "public"."logistics_shipment_items" to "anon";
grant insert on table "public"."logistics_shipment_items" to "anon";
grant references on table "public"."logistics_shipment_items" to "anon";
grant select on table "public"."logistics_shipment_items" to "anon";
grant trigger on table "public"."logistics_shipment_items" to "anon";
grant truncate on table "public"."logistics_shipment_items" to "anon";
grant update on table "public"."logistics_shipment_items" to "anon";
grant delete on table "public"."logistics_shipment_items" to "authenticated";
grant insert on table "public"."logistics_shipment_items" to "authenticated";
grant references on table "public"."logistics_shipment_items" to "authenticated";
grant select on table "public"."logistics_shipment_items" to "authenticated";
grant trigger on table "public"."logistics_shipment_items" to "authenticated";
grant truncate on table "public"."logistics_shipment_items" to "authenticated";
grant update on table "public"."logistics_shipment_items" to "authenticated";
grant delete on table "public"."logistics_shipment_items" to "service_role";
grant insert on table "public"."logistics_shipment_items" to "service_role";
grant references on table "public"."logistics_shipment_items" to "service_role";
grant select on table "public"."logistics_shipment_items" to "service_role";
grant trigger on table "public"."logistics_shipment_items" to "service_role";
grant truncate on table "public"."logistics_shipment_items" to "service_role";
grant update on table "public"."logistics_shipment_items" to "service_role";
grant insert on table "public"."logistics_shipments" to "anon";
grant references on table "public"."logistics_shipments" to "anon";
grant select on table "public"."logistics_shipments" to "anon";
grant trigger on table "public"."logistics_shipments" to "anon";
grant truncate on table "public"."logistics_shipments" to "anon";
grant update on table "public"."logistics_shipments" to "anon";
grant delete on table "public"."logistics_shipments" to "authenticated";
grant insert on table "public"."logistics_shipments" to "authenticated";
grant references on table "public"."logistics_shipments" to "authenticated";
grant select on table "public"."logistics_shipments" to "authenticated";
grant trigger on table "public"."logistics_shipments" to "authenticated";
grant truncate on table "public"."logistics_shipments" to "authenticated";
grant update on table "public"."logistics_shipments" to "authenticated";
grant delete on table "public"."logistics_shipments" to "service_role";
grant insert on table "public"."logistics_shipments" to "service_role";
grant references on table "public"."logistics_shipments" to "service_role";
grant select on table "public"."logistics_shipments" to "service_role";
grant trigger on table "public"."logistics_shipments" to "service_role";
grant truncate on table "public"."logistics_shipments" to "service_role";
grant update on table "public"."logistics_shipments" to "service_role";
grant delete on table "public"."marketing_contract_harvests" to "anon";
grant insert on table "public"."marketing_contract_harvests" to "anon";
grant references on table "public"."marketing_contract_harvests" to "anon";
grant select on table "public"."marketing_contract_harvests" to "anon";
grant trigger on table "public"."marketing_contract_harvests" to "anon";
grant truncate on table "public"."marketing_contract_harvests" to "anon";
grant update on table "public"."marketing_contract_harvests" to "anon";
grant delete on table "public"."marketing_contract_harvests" to "authenticated";
grant insert on table "public"."marketing_contract_harvests" to "authenticated";
grant references on table "public"."marketing_contract_harvests" to "authenticated";
grant select on table "public"."marketing_contract_harvests" to "authenticated";
grant trigger on table "public"."marketing_contract_harvests" to "authenticated";
grant truncate on table "public"."marketing_contract_harvests" to "authenticated";
grant update on table "public"."marketing_contract_harvests" to "authenticated";
grant delete on table "public"."marketing_contract_harvests" to "service_role";
grant insert on table "public"."marketing_contract_harvests" to "service_role";
grant references on table "public"."marketing_contract_harvests" to "service_role";
grant select on table "public"."marketing_contract_harvests" to "service_role";
grant trigger on table "public"."marketing_contract_harvests" to "service_role";
grant truncate on table "public"."marketing_contract_harvests" to "service_role";
grant update on table "public"."marketing_contract_harvests" to "service_role";
grant delete on table "public"."marketing_external_meat_purchases" to "anon";
grant insert on table "public"."marketing_external_meat_purchases" to "anon";
grant references on table "public"."marketing_external_meat_purchases" to "anon";
grant select on table "public"."marketing_external_meat_purchases" to "anon";
grant trigger on table "public"."marketing_external_meat_purchases" to "anon";
grant truncate on table "public"."marketing_external_meat_purchases" to "anon";
grant update on table "public"."marketing_external_meat_purchases" to "anon";
grant delete on table "public"."marketing_external_meat_purchases" to "authenticated";
grant insert on table "public"."marketing_external_meat_purchases" to "authenticated";
grant references on table "public"."marketing_external_meat_purchases" to "authenticated";
grant select on table "public"."marketing_external_meat_purchases" to "authenticated";
grant trigger on table "public"."marketing_external_meat_purchases" to "authenticated";
grant truncate on table "public"."marketing_external_meat_purchases" to "authenticated";
grant update on table "public"."marketing_external_meat_purchases" to "authenticated";
grant delete on table "public"."marketing_external_meat_purchases" to "service_role";
grant insert on table "public"."marketing_external_meat_purchases" to "service_role";
grant references on table "public"."marketing_external_meat_purchases" to "service_role";
grant select on table "public"."marketing_external_meat_purchases" to "service_role";
grant trigger on table "public"."marketing_external_meat_purchases" to "service_role";
grant truncate on table "public"."marketing_external_meat_purchases" to "service_role";
grant update on table "public"."marketing_external_meat_purchases" to "service_role";
grant delete on table "public"."performance_standards" to "authenticated";
grant insert on table "public"."performance_standards" to "authenticated";
grant select on table "public"."performance_standards" to "authenticated";
grant update on table "public"."performance_standards" to "authenticated";
grant delete on table "public"."performance_standards" to "service_role";
grant insert on table "public"."performance_standards" to "service_role";
grant references on table "public"."performance_standards" to "service_role";
grant select on table "public"."performance_standards" to "service_role";
grant trigger on table "public"."performance_standards" to "service_role";
grant truncate on table "public"."performance_standards" to "service_role";
grant update on table "public"."performance_standards" to "service_role";
grant delete on table "public"."ppl_league" to "anon";
grant insert on table "public"."ppl_league" to "anon";
grant references on table "public"."ppl_league" to "anon";
grant select on table "public"."ppl_league" to "anon";
grant trigger on table "public"."ppl_league" to "anon";
grant truncate on table "public"."ppl_league" to "anon";
grant update on table "public"."ppl_league" to "anon";
grant delete on table "public"."ppl_league" to "authenticated";
grant insert on table "public"."ppl_league" to "authenticated";
grant references on table "public"."ppl_league" to "authenticated";
grant select on table "public"."ppl_league" to "authenticated";
grant trigger on table "public"."ppl_league" to "authenticated";
grant truncate on table "public"."ppl_league" to "authenticated";
grant update on table "public"."ppl_league" to "authenticated";
grant delete on table "public"."ppl_league" to "service_role";
grant insert on table "public"."ppl_league" to "service_role";
grant references on table "public"."ppl_league" to "service_role";
grant select on table "public"."ppl_league" to "service_role";
grant trigger on table "public"."ppl_league" to "service_role";
grant truncate on table "public"."ppl_league" to "service_role";
grant update on table "public"."ppl_league" to "service_role";
grant delete on table "public"."production_abk_result_sizes" to "anon";
grant insert on table "public"."production_abk_result_sizes" to "anon";
grant references on table "public"."production_abk_result_sizes" to "anon";
grant select on table "public"."production_abk_result_sizes" to "anon";
grant trigger on table "public"."production_abk_result_sizes" to "anon";
grant truncate on table "public"."production_abk_result_sizes" to "anon";
grant update on table "public"."production_abk_result_sizes" to "anon";
grant delete on table "public"."production_abk_result_sizes" to "authenticated";
grant insert on table "public"."production_abk_result_sizes" to "authenticated";
grant references on table "public"."production_abk_result_sizes" to "authenticated";
grant select on table "public"."production_abk_result_sizes" to "authenticated";
grant trigger on table "public"."production_abk_result_sizes" to "authenticated";
grant truncate on table "public"."production_abk_result_sizes" to "authenticated";
grant update on table "public"."production_abk_result_sizes" to "authenticated";
grant delete on table "public"."production_abk_result_sizes" to "service_role";
grant insert on table "public"."production_abk_result_sizes" to "service_role";
grant references on table "public"."production_abk_result_sizes" to "service_role";
grant select on table "public"."production_abk_result_sizes" to "service_role";
grant trigger on table "public"."production_abk_result_sizes" to "service_role";
grant truncate on table "public"."production_abk_result_sizes" to "service_role";
grant update on table "public"."production_abk_result_sizes" to "service_role";
grant delete on table "public"."production_abk_results" to "anon";
grant insert on table "public"."production_abk_results" to "anon";
grant references on table "public"."production_abk_results" to "anon";
grant select on table "public"."production_abk_results" to "anon";
grant trigger on table "public"."production_abk_results" to "anon";
grant truncate on table "public"."production_abk_results" to "anon";
grant update on table "public"."production_abk_results" to "anon";
grant delete on table "public"."production_abk_results" to "authenticated";
grant insert on table "public"."production_abk_results" to "authenticated";
grant references on table "public"."production_abk_results" to "authenticated";
grant select on table "public"."production_abk_results" to "authenticated";
grant trigger on table "public"."production_abk_results" to "authenticated";
grant truncate on table "public"."production_abk_results" to "authenticated";
grant update on table "public"."production_abk_results" to "authenticated";
grant delete on table "public"."production_abk_results" to "service_role";
grant insert on table "public"."production_abk_results" to "service_role";
grant references on table "public"."production_abk_results" to "service_role";
grant select on table "public"."production_abk_results" to "service_role";
grant trigger on table "public"."production_abk_results" to "service_role";
grant truncate on table "public"."production_abk_results" to "service_role";
grant update on table "public"."production_abk_results" to "service_role";
grant delete on table "public"."production_estimate_sizes" to "anon";
grant insert on table "public"."production_estimate_sizes" to "anon";
grant references on table "public"."production_estimate_sizes" to "anon";
grant select on table "public"."production_estimate_sizes" to "anon";
grant trigger on table "public"."production_estimate_sizes" to "anon";
grant truncate on table "public"."production_estimate_sizes" to "anon";
grant update on table "public"."production_estimate_sizes" to "anon";
grant delete on table "public"."production_estimate_sizes" to "authenticated";
grant insert on table "public"."production_estimate_sizes" to "authenticated";
grant references on table "public"."production_estimate_sizes" to "authenticated";
grant select on table "public"."production_estimate_sizes" to "authenticated";
grant trigger on table "public"."production_estimate_sizes" to "authenticated";
grant truncate on table "public"."production_estimate_sizes" to "authenticated";
grant update on table "public"."production_estimate_sizes" to "authenticated";
grant delete on table "public"."production_estimate_sizes" to "service_role";
grant insert on table "public"."production_estimate_sizes" to "service_role";
grant references on table "public"."production_estimate_sizes" to "service_role";
grant select on table "public"."production_estimate_sizes" to "service_role";
grant trigger on table "public"."production_estimate_sizes" to "service_role";
grant truncate on table "public"."production_estimate_sizes" to "service_role";
grant update on table "public"."production_estimate_sizes" to "service_role";
grant delete on table "public"."production_estimates" to "anon";
grant insert on table "public"."production_estimates" to "anon";
grant references on table "public"."production_estimates" to "anon";
grant select on table "public"."production_estimates" to "anon";
grant trigger on table "public"."production_estimates" to "anon";
grant truncate on table "public"."production_estimates" to "anon";
grant update on table "public"."production_estimates" to "anon";
grant delete on table "public"."production_estimates" to "authenticated";
grant insert on table "public"."production_estimates" to "authenticated";
grant references on table "public"."production_estimates" to "authenticated";
grant select on table "public"."production_estimates" to "authenticated";
grant trigger on table "public"."production_estimates" to "authenticated";
grant truncate on table "public"."production_estimates" to "authenticated";
grant update on table "public"."production_estimates" to "authenticated";
grant delete on table "public"."production_estimates" to "service_role";
grant insert on table "public"."production_estimates" to "service_role";
grant references on table "public"."production_estimates" to "service_role";
grant select on table "public"."production_estimates" to "service_role";
grant trigger on table "public"."production_estimates" to "service_role";
grant truncate on table "public"."production_estimates" to "service_role";
grant update on table "public"."production_estimates" to "service_role";
grant delete on table "public"."profiles" to "authenticated";
grant insert on table "public"."profiles" to "authenticated";
grant select on table "public"."profiles" to "authenticated";
grant update on table "public"."profiles" to "authenticated";
grant delete on table "public"."profiles" to "service_role";
grant insert on table "public"."profiles" to "service_role";
grant references on table "public"."profiles" to "service_role";
grant select on table "public"."profiles" to "service_role";
grant trigger on table "public"."profiles" to "service_role";
grant truncate on table "public"."profiles" to "service_role";
grant update on table "public"."profiles" to "service_role";
grant delete on table "public"."recording_weight_samples" to "anon";
grant insert on table "public"."recording_weight_samples" to "anon";
grant references on table "public"."recording_weight_samples" to "anon";
grant select on table "public"."recording_weight_samples" to "anon";
grant trigger on table "public"."recording_weight_samples" to "anon";
grant truncate on table "public"."recording_weight_samples" to "anon";
grant update on table "public"."recording_weight_samples" to "anon";
grant delete on table "public"."recording_weight_samples" to "authenticated";
grant insert on table "public"."recording_weight_samples" to "authenticated";
grant references on table "public"."recording_weight_samples" to "authenticated";
grant select on table "public"."recording_weight_samples" to "authenticated";
grant trigger on table "public"."recording_weight_samples" to "authenticated";
grant truncate on table "public"."recording_weight_samples" to "authenticated";
grant update on table "public"."recording_weight_samples" to "authenticated";
grant delete on table "public"."recording_weight_samples" to "service_role";
grant insert on table "public"."recording_weight_samples" to "service_role";
grant references on table "public"."recording_weight_samples" to "service_role";
grant select on table "public"."recording_weight_samples" to "service_role";
grant trigger on table "public"."recording_weight_samples" to "service_role";
grant truncate on table "public"."recording_weight_samples" to "service_role";
grant update on table "public"."recording_weight_samples" to "service_role";
grant delete on table "public"."recordings" to "authenticated";
grant insert on table "public"."recordings" to "authenticated";
grant select on table "public"."recordings" to "authenticated";
grant update on table "public"."recordings" to "authenticated";
grant delete on table "public"."recordings" to "service_role";
grant insert on table "public"."recordings" to "service_role";
grant references on table "public"."recordings" to "service_role";
grant select on table "public"."recordings" to "service_role";
grant trigger on table "public"."recordings" to "service_role";
grant truncate on table "public"."recordings" to "service_role";
grant update on table "public"."recordings" to "service_role";
grant delete on table "public"."rhpp_estimates" to "authenticated";
grant insert on table "public"."rhpp_estimates" to "authenticated";
grant select on table "public"."rhpp_estimates" to "authenticated";
grant update on table "public"."rhpp_estimates" to "authenticated";
grant delete on table "public"."rhpp_estimates" to "service_role";
grant insert on table "public"."rhpp_estimates" to "service_role";
grant references on table "public"."rhpp_estimates" to "service_role";
grant select on table "public"."rhpp_estimates" to "service_role";
grant trigger on table "public"."rhpp_estimates" to "service_role";
grant truncate on table "public"."rhpp_estimates" to "service_role";
grant update on table "public"."rhpp_estimates" to "service_role";
grant delete on table "public"."rhpp_real" to "authenticated";
grant insert on table "public"."rhpp_real" to "authenticated";
grant select on table "public"."rhpp_real" to "authenticated";
grant update on table "public"."rhpp_real" to "authenticated";
grant delete on table "public"."rhpp_real" to "service_role";
grant insert on table "public"."rhpp_real" to "service_role";
grant references on table "public"."rhpp_real" to "service_role";
grant select on table "public"."rhpp_real" to "service_role";
grant trigger on table "public"."rhpp_real" to "service_role";
grant truncate on table "public"."rhpp_real" to "service_role";
grant update on table "public"."rhpp_real" to "service_role";
grant delete on table "public"."rhpp_system_final" to "authenticated";
grant insert on table "public"."rhpp_system_final" to "authenticated";
grant references on table "public"."rhpp_system_final" to "authenticated";
grant select on table "public"."rhpp_system_final" to "authenticated";
grant trigger on table "public"."rhpp_system_final" to "authenticated";
grant truncate on table "public"."rhpp_system_final" to "authenticated";
grant update on table "public"."rhpp_system_final" to "authenticated";
grant delete on table "public"."rhpp_system_final" to "service_role";
grant insert on table "public"."rhpp_system_final" to "service_role";
grant references on table "public"."rhpp_system_final" to "service_role";
grant select on table "public"."rhpp_system_final" to "service_role";
grant trigger on table "public"."rhpp_system_final" to "service_role";
grant truncate on table "public"."rhpp_system_final" to "service_role";
grant update on table "public"."rhpp_system_final" to "service_role";
grant delete on table "public"."suppliers" to "anon";
grant insert on table "public"."suppliers" to "anon";
grant references on table "public"."suppliers" to "anon";
grant select on table "public"."suppliers" to "anon";
grant trigger on table "public"."suppliers" to "anon";
grant truncate on table "public"."suppliers" to "anon";
grant update on table "public"."suppliers" to "anon";
grant delete on table "public"."suppliers" to "authenticated";
grant insert on table "public"."suppliers" to "authenticated";
grant references on table "public"."suppliers" to "authenticated";
grant select on table "public"."suppliers" to "authenticated";
grant trigger on table "public"."suppliers" to "authenticated";
grant truncate on table "public"."suppliers" to "authenticated";
grant update on table "public"."suppliers" to "authenticated";
grant delete on table "public"."suppliers" to "service_role";
grant insert on table "public"."suppliers" to "service_role";
grant references on table "public"."suppliers" to "service_role";
grant select on table "public"."suppliers" to "service_role";
grant trigger on table "public"."suppliers" to "service_role";
grant truncate on table "public"."suppliers" to "service_role";
grant update on table "public"."suppliers" to "service_role";
grant delete on table "public"."supplies" to "authenticated";
grant insert on table "public"."supplies" to "authenticated";
grant select on table "public"."supplies" to "authenticated";
grant update on table "public"."supplies" to "authenticated";
grant delete on table "public"."supplies" to "service_role";
grant insert on table "public"."supplies" to "service_role";
grant references on table "public"."supplies" to "service_role";
grant select on table "public"."supplies" to "service_role";
grant trigger on table "public"."supplies" to "service_role";
grant truncate on table "public"."supplies" to "service_role";
grant update on table "public"."supplies" to "service_role";
grant delete on table "public"."visits" to "authenticated";
grant insert on table "public"."visits" to "authenticated";
grant select on table "public"."visits" to "authenticated";
grant update on table "public"."visits" to "authenticated";
grant delete on table "public"."visits" to "service_role";
grant insert on table "public"."visits" to "service_role";
grant references on table "public"."visits" to "service_role";
grant select on table "public"."visits" to "service_role";
grant trigger on table "public"."visits" to "service_role";
grant truncate on table "public"."visits" to "service_role";
grant update on table "public"."visits" to "service_role";

-- FUNCTION GRANTS
grant execute on function "private"."admin_list_bms_users_impl"() to "authenticated";
grant execute on function "private"."admin_update_bms_user_impl"(p_user_id uuid, p_name text, p_role bms_role, p_active boolean) to "authenticated";
grant execute on function "private"."assign_bms_role_impl"(p_email text, p_role bms_role, p_name text) to "authenticated";
grant execute on function "private"."bind_master_contract_to_cycle_core"(p_master_contract_id uuid, p_cycle_id uuid) to "authenticated";
grant execute on function "private"."can_edit_cycle"(cid uuid, allowed bms_role[]) to "authenticated";
grant execute on function "private"."can_edit_cycle"(cid uuid, allowed bms_role[]) to "service_role";
grant execute on function "private"."can_read_cycle"(cid uuid) to "authenticated";
grant execute on function "private"."can_read_cycle"(cid uuid) to "service_role";
grant execute on function "private"."my_bms_role"() to "authenticated";
grant execute on function "private"."my_bms_role"() to "service_role";
grant execute on function "private"."set_cycle_state_impl"(p_cycle uuid, p_action text, p_reason text) to "authenticated";
grant execute on function "public"."admin_close_production_atomic"(p_contract_assignment_id uuid) to "authenticated";
grant execute on function "public"."admin_close_production_atomic"(p_contract_assignment_id uuid) to "service_role";
grant execute on function "public"."admin_list_bms_users"() to "authenticated";
grant execute on function "public"."admin_list_bms_users"() to "service_role";
grant execute on function "public"."admin_reopen_production_atomic"(p_contract_assignment_id uuid) to "authenticated";
grant execute on function "public"."admin_reopen_production_atomic"(p_contract_assignment_id uuid) to "service_role";
grant execute on function "public"."admin_update_bms_user"(p_user_id uuid, p_name text, p_role bms_role, p_active boolean) to "authenticated";
grant execute on function "public"."admin_update_bms_user"(p_user_id uuid, p_name text, p_role bms_role, p_active boolean) to "service_role";
grant execute on function "public"."assign_barn_code"() to "service_role";
grant execute on function "public"."assign_bms_role"(p_email text, p_role bms_role, p_name text) to "authenticated";
grant execute on function "public"."assign_bms_role"(p_email text, p_role bms_role, p_name text) to "service_role";
grant execute on function "public"."assign_master_auto_code"() to "service_role";
grant execute on function "public"."assign_supplier_code"() to "service_role";
grant execute on function "public"."audit_and_guard"() to "service_role";
grant execute on function "public"."audit_master_change"() to "service_role";
grant execute on function "public"."autofill_logistics_return_price"() to "service_role";
grant execute on function "public"."autofill_logistics_shipment_price"() to "service_role";
grant execute on function "public"."bind_master_contract_to_cycle"(p_master_contract_id uuid, p_cycle_id uuid) to "authenticated";
grant execute on function "public"."bind_master_contract_to_cycle"(p_master_contract_id uuid, p_cycle_id uuid) to "service_role";
grant execute on function "public"."bms_backup_download_payload"(p_token text) to "service_role";
grant execute on function "public"."check_advance_payment"() to "service_role";
grant execute on function "public"."compute_chickin_avg_weight"() to "service_role";
grant execute on function "public"."compute_recording_avg_weight"() to "service_role";
grant execute on function "public"."compute_recording_feed_kg"() to "service_role";
grant execute on function "public"."compute_supply_quantity_kg"() to "service_role";
grant execute on function "public"."delete_production_abk_harvest_atomic"(p_size_id uuid) to "authenticated";
grant execute on function "public"."delete_production_abk_harvest_atomic"(p_size_id uuid) to "service_role";
grant execute on function "public"."fill_external_shipment_quantity_kg"() to "anon";
grant execute on function "public"."fill_external_shipment_quantity_kg"() to "authenticated";
grant execute on function "public"."fill_external_shipment_quantity_kg"() to "service_role";
grant execute on function "public"."finance_auto_reference_trigger"() to "anon";
grant execute on function "public"."finance_auto_reference_trigger"() to "authenticated";
grant execute on function "public"."finance_auto_reference_trigger"() to "service_role";
grant execute on function "public"."finance_cashflow_entries_v1"() to "anon";
grant execute on function "public"."finance_cashflow_entries_v1"() to "authenticated";
grant execute on function "public"."finance_cashflow_entries_v1"() to "service_role";
grant execute on function "public"."finance_company_profit_loss_v1"() to "anon";
grant execute on function "public"."finance_company_profit_loss_v1"() to "authenticated";
grant execute on function "public"."finance_company_profit_loss_v1"() to "service_role";
grant execute on function "public"."finance_create_expedition_invoice_atomic"(p_invoice_number text, p_invoice_date date, p_due_date date, p_customer_name text, p_customer_address text, p_trip_ids uuid[], p_notes text) to "anon";
grant execute on function "public"."finance_create_expedition_invoice_atomic"(p_invoice_number text, p_invoice_date date, p_due_date date, p_customer_name text, p_customer_address text, p_trip_ids uuid[], p_notes text) to "authenticated";
grant execute on function "public"."finance_create_expedition_invoice_atomic"(p_invoice_number text, p_invoice_date date, p_due_date date, p_customer_name text, p_customer_address text, p_trip_ids uuid[], p_notes text) to "service_role";
grant execute on function "public"."finance_cycle_profit_loss_v1"() to "anon";
grant execute on function "public"."finance_cycle_profit_loss_v1"() to "authenticated";
grant execute on function "public"."finance_cycle_profit_loss_v1"() to "service_role";
grant execute on function "public"."finance_expedition_profit_loss_v1"() to "anon";
grant execute on function "public"."finance_expedition_profit_loss_v1"() to "authenticated";
grant execute on function "public"."finance_expedition_profit_loss_v1"() to "service_role";
grant execute on function "public"."finance_expedition_summary_v1"() to "anon";
grant execute on function "public"."finance_expedition_summary_v1"() to "authenticated";
grant execute on function "public"."finance_expedition_summary_v1"() to "service_role";
grant execute on function "public"."finance_next_reference"(p_prefix text, p_date date) to "anon";
grant execute on function "public"."finance_next_reference"(p_prefix text, p_date date) to "authenticated";
grant execute on function "public"."finance_next_reference"(p_prefix text, p_date date) to "service_role";
grant execute on function "public"."finance_rhpp_summary"() to "service_role";
grant execute on function "public"."finance_rhpp_summary_v2"() to "authenticated";
grant execute on function "public"."finance_rhpp_summary_v2"() to "service_role";
grant execute on function "public"."finance_rhpp_summary_v3"() to "service_role";
grant execute on function "public"."finance_rhpp_summary_v4"() to "authenticated";
grant execute on function "public"."finance_rhpp_summary_v4"() to "service_role";
grant execute on function "public"."finance_rhpp_summary_v5"() to "anon";
grant execute on function "public"."finance_rhpp_summary_v5"() to "authenticated";
grant execute on function "public"."finance_rhpp_summary_v5"() to "service_role";
grant execute on function "public"."finance_save_abk_advance_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_advanced_on date, p_amount numeric, p_description text, p_reference text) to "anon";
grant execute on function "public"."finance_save_abk_advance_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_advanced_on date, p_amount numeric, p_description text, p_reference text) to "authenticated";
grant execute on function "public"."finance_save_abk_advance_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_advanced_on date, p_amount numeric, p_description text, p_reference text) to "service_role";
grant execute on function "public"."finance_save_abk_salary_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_gross_salary numeric, p_advance_deduction numeric, p_paid_on date, p_reference text, p_notes text) to "anon";
grant execute on function "public"."finance_save_abk_salary_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_gross_salary numeric, p_advance_deduction numeric, p_paid_on date, p_reference text, p_notes text) to "authenticated";
grant execute on function "public"."finance_save_abk_salary_atomic"(p_contract_assignment_id uuid, p_abk_id uuid, p_gross_salary numeric, p_advance_deduction numeric, p_paid_on date, p_reference text, p_notes text) to "service_role";
grant execute on function "public"."finance_save_employee_advance_atomic"(p_employee_id uuid, p_advanced_on date, p_amount numeric, p_contract_assignment_id uuid, p_description text, p_reference text) to "anon";
grant execute on function "public"."finance_save_employee_advance_atomic"(p_employee_id uuid, p_advanced_on date, p_amount numeric, p_contract_assignment_id uuid, p_description text, p_reference text) to "authenticated";
grant execute on function "public"."finance_save_employee_advance_atomic"(p_employee_id uuid, p_advanced_on date, p_amount numeric, p_contract_assignment_id uuid, p_description text, p_reference text) to "service_role";
grant execute on function "public"."finance_save_rhpp_real_atomic"(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text, p_notes text) to "authenticated";
grant execute on function "public"."finance_save_rhpp_real_atomic"(p_contract_assignment_id uuid, p_amount numeric, p_received_on date, p_reference text, p_notes text) to "service_role";
grant execute on function "public"."guard_barn_update"() to "service_role";
grant execute on function "public"."guard_contract_detail"() to "service_role";
grant execute on function "public"."guard_logistics_contract_close_prices"() to "service_role";
grant execute on function "public"."guard_logistics_return"() to "service_role";
grant execute on function "public"."guard_logistics_return_item"() to "service_role";
grant execute on function "public"."guard_logistics_shipment"() to "service_role";
grant execute on function "public"."guard_logistics_shipment_item"() to "service_role";
grant execute on function "public"."lock_production_abk_basics_atomic"(p_link_id uuid, p_initial_birds integer, p_feed_pre_bags numeric, p_feed_starter_bags numeric, p_feed_finisher_bags numeric) to "authenticated";
grant execute on function "public"."lock_production_abk_basics_atomic"(p_link_id uuid, p_initial_birds integer, p_feed_pre_bags numeric, p_feed_starter_bags numeric, p_feed_finisher_bags numeric) to "service_role";
grant execute on function "public"."normalize_item_unit"() to "service_role";
grant execute on function "public"."prepare_logistics_contract_assignment"() to "service_role";
grant execute on function "public"."prevent_employee_delete"() to "service_role";
grant execute on function "public"."prevent_locked_abk_basics_change"() to "anon";
grant execute on function "public"."prevent_locked_abk_basics_change"() to "authenticated";
grant execute on function "public"."prevent_locked_abk_basics_change"() to "service_role";
grant execute on function "public"."production_feed_stock"(p_contract_assignment_id uuid) to "authenticated";
grant execute on function "public"."production_feed_stock"(p_contract_assignment_id uuid) to "service_role";
grant execute on function "public"."protect_frozen_contract"() to "service_role";
grant execute on function "public"."protect_frozen_contract_detail"() to "service_role";
grant execute on function "public"."protect_master_auto_code"() to "service_role";
grant execute on function "public"."reassign_employee_code_on_kind_change"() to "service_role";
grant execute on function "public"."reset_bop_complete"() to "service_role";
grant execute on function "public"."save_external_sapronak_atomic"(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric) to "anon";
grant execute on function "public"."save_external_sapronak_atomic"(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric) to "authenticated";
grant execute on function "public"."save_external_sapronak_atomic"(p_header_id uuid, p_detail_id uuid, p_assignment_id uuid, p_barn_id uuid, p_supplier_id uuid, p_shipment_date date, p_reference_number text, p_notes text, p_item_id uuid, p_quantity numeric, p_purchase_unit_price numeric) to "service_role";
grant execute on function "public"."save_external_sapronak_return_atomic"(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric) to "authenticated";
grant execute on function "public"."save_external_sapronak_return_atomic"(p_id uuid, p_external_shipment_item_id uuid, p_return_date date, p_reference text, p_notes text, p_quantity numeric) to "service_role";
grant execute on function "public"."save_logistics_return_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb) to "anon";
grant execute on function "public"."save_logistics_return_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb) to "authenticated";
grant execute on function "public"."save_logistics_return_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_return_date date, p_reference text, p_notes text, p_items jsonb) to "service_role";
grant execute on function "public"."save_logistics_shipment_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb) to "anon";
grant execute on function "public"."save_logistics_shipment_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb) to "authenticated";
grant execute on function "public"."save_logistics_shipment_atomic"(p_id uuid, p_barn_id uuid, p_assignment_id uuid, p_shipment_date date, p_shipping_note_number text, p_notes text, p_items jsonb) to "service_role";
grant execute on function "public"."save_production_abk_harvest_atomic"(p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric) to "authenticated";
grant execute on function "public"."save_production_abk_harvest_atomic"(p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric) to "service_role";
grant execute on function "public"."save_production_abk_initial_population_atomic"(p_link_id uuid, p_initial_birds integer) to "authenticated";
grant execute on function "public"."save_production_abk_initial_population_atomic"(p_link_id uuid, p_initial_birds integer) to "service_role";
grant execute on function "public"."save_production_abk_result_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric, p_sizes jsonb) to "anon";
grant execute on function "public"."save_production_abk_result_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric, p_sizes jsonb) to "authenticated";
grant execute on function "public"."save_production_abk_result_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_abk_id uuid, p_harvest_date date, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric, p_sizes jsonb) to "service_role";
grant execute on function "public"."save_production_estimate_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_estimated_on date, p_remaining_birds integer, p_feed_used_kg numeric, p_notes text, p_estimated_revenue numeric, p_estimated_cost numeric, p_estimated_profit numeric, p_profit_per_chick_in numeric, p_sizes jsonb) to "anon";
grant execute on function "public"."save_production_estimate_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_estimated_on date, p_remaining_birds integer, p_feed_used_kg numeric, p_notes text, p_estimated_revenue numeric, p_estimated_cost numeric, p_estimated_profit numeric, p_profit_per_chick_in numeric, p_sizes jsonb) to "authenticated";
grant execute on function "public"."save_production_estimate_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_estimated_on date, p_remaining_birds integer, p_feed_used_kg numeric, p_notes text, p_estimated_revenue numeric, p_estimated_cost numeric, p_estimated_profit numeric, p_profit_per_chick_in numeric, p_sizes jsonb) to "service_role";
grant execute on function "public"."save_recording_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb) to "anon";
grant execute on function "public"."save_recording_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb) to "authenticated";
grant execute on function "public"."save_recording_atomic"(p_id uuid, p_assignment_id uuid, p_barn_id uuid, p_recorded_on date, p_age_days integer, p_mortality integer, p_culling integer, p_feed_item_id uuid, p_feed_quantity_units numeric, p_sample_count integer, p_sample_weight_total_kg numeric, p_notes text, p_photo_data text, p_weights jsonb) to "service_role";
grant execute on function "public"."save_rhpp_final_atomic"(p_contract_assignment_id uuid) to "service_role";
grant execute on function "public"."set_cycle_state"(p_cycle uuid, p_action text, p_reason text) to "authenticated";
grant execute on function "public"."set_cycle_state"(p_cycle uuid, p_action text, p_reason text) to "service_role";
grant execute on function "public"."transfer_external_sapronak_return_atomic"(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text) to "authenticated";
grant execute on function "public"."transfer_external_sapronak_return_atomic"(p_external_return_item_id uuid, p_target_assignment_id uuid, p_quantity numeric, p_transferred_on date, p_notes text) to "service_role";
grant execute on function "public"."update_production_abk_harvest_atomic"(p_size_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric) to "authenticated";
grant execute on function "public"."update_production_abk_harvest_atomic"(p_size_id uuid, p_harvest_date date, p_birds integer, p_weight_kg numeric, p_feed_pre_kg numeric, p_feed_starter_kg numeric, p_feed_finisher_kg numeric) to "service_role";
grant execute on function "public"."validate_chick_in"() to "service_role";
grant execute on function "public"."validate_cycle_population"() to "service_role";
