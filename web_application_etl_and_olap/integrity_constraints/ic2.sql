drop trigger if exists chk_sv_sbbid on transformer;
drop function if exists chk_sv_sbbid_proc();

create or replace function chk_sv_sbbid_proc() returns trigger as
$$
declare sbbv numeric(7,4);
begin

    select voltage
    into sbbv
    from busbar
    where new.sbbid = id;

    if sbbv <> new.sv then
        raise exception 'Secondary bus bar % voltage does not match the transformer secondary voltage', pbbid
        using hint = 'Please check both voltages';
    end if;

    return new;
end
$$ language plpgsql;

create trigger chk_sv_sbbid
before insert or update on transformer
for each row execute procedure chk_sv_sbbid_proc();