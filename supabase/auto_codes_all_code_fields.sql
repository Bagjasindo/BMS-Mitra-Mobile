create sequence if not exists public.cycle_code_seq start 1;
create sequence if not exists public.item_code_seq start 1;
create sequence if not exists public.employee_code_seq start 1;

create or replace function public.assign_master_auto_code()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare prefix text; seq regclass;
begin
  case TG_TABLE_NAME
    when 'barns' then prefix:='KD-'; seq:='public.barn_code_seq'::regclass;
    when 'cycles' then prefix:='SK-'; seq:='public.cycle_code_seq'::regclass;
    when 'items' then prefix:='SP-'; seq:='public.item_code_seq'::regclass;
    when 'employees' then prefix:='KY-'; seq:='public.employee_code_seq'::regclass;
    else raise exception 'Unsupported auto-code table: %',TG_TABLE_NAME;
  end case;
  loop
    new.code:=prefix||lpad(nextval(seq)::text,3,'0');
    exit when
      (TG_TABLE_NAME<>'barns' or not exists(select 1 from public.barns x where x.code=new.code))
      and (TG_TABLE_NAME<>'cycles' or not exists(select 1 from public.cycles x where x.code=new.code))
      and (TG_TABLE_NAME<>'items' or not exists(select 1 from public.items x where x.code=new.code))
      and (TG_TABLE_NAME<>'employees' or not exists(select 1 from public.employees x where x.code=new.code));
  end loop;
  return new;
end
$$;

create or replace function public.protect_master_auto_code()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.code is distinct from old.code then raise exception 'Kode dibuat otomatis dan tidak dapat diubah'; end if;
  return new;
end
$$;

revoke all on function public.assign_master_auto_code() from public,anon,authenticated;
revoke all on function public.protect_master_auto_code() from public,anon,authenticated;

drop trigger if exists assign_barn_code on public.barns;
drop trigger if exists assign_master_auto_code on public.barns;
drop trigger if exists assign_master_auto_code on public.cycles;
drop trigger if exists assign_master_auto_code on public.items;
drop trigger if exists assign_master_auto_code on public.employees;

create trigger assign_master_auto_code before insert on public.barns for each row execute function public.assign_master_auto_code();
create trigger assign_master_auto_code before insert on public.cycles for each row execute function public.assign_master_auto_code();
create trigger assign_master_auto_code before insert on public.items for each row execute function public.assign_master_auto_code();
create trigger assign_master_auto_code before insert on public.employees for each row execute function public.assign_master_auto_code();

drop trigger if exists protect_master_auto_code on public.barns;
drop trigger if exists protect_master_auto_code on public.cycles;
drop trigger if exists protect_master_auto_code on public.items;
drop trigger if exists protect_master_auto_code on public.employees;

create trigger protect_master_auto_code before update of code on public.barns for each row execute function public.protect_master_auto_code();
create trigger protect_master_auto_code before update of code on public.cycles for each row execute function public.protect_master_auto_code();
create trigger protect_master_auto_code before update of code on public.items for each row execute function public.protect_master_auto_code();
create trigger protect_master_auto_code before update of code on public.employees for each row execute function public.protect_master_auto_code();
