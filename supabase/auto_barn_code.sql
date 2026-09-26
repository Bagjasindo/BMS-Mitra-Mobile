create sequence if not exists public.barn_code_seq start 1;

create or replace function public.assign_barn_code()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.code is null or btrim(new.code) = '' then
    loop
      new.code := 'KD-' || lpad(nextval('public.barn_code_seq')::text,3,'0');
      exit when not exists(select 1 from public.barns where code=new.code);
    end loop;
  end if;
  return new;
end
$$;

revoke all on function public.assign_barn_code() from public,anon,authenticated;

drop trigger if exists assign_barn_code on public.barns;
create trigger assign_barn_code
before insert on public.barns
for each row execute function public.assign_barn_code();
