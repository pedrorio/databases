drop trigger if exists chk_pv_pbbid on transformer;
drop function if exists chk_pv_pbbid_proc();

create or replace function chk_pv_pbbid_proc() returns trigger as
$$
declare pbbv numeric(7,4);
begin

    select voltage
    into pbbv
    from busbar
    where new.pbbid = id;

    if pbbv <> new.pv then
        raise exception 'Primary bus bar % voltage does not match the transformer primary voltage', pbbid
        using hint = 'Please check both voltages';
    end if;

    return new;
end
$$ language plpgsql;

create trigger chk_pv_pbbid
before insert or update on transformer
for each row execute procedure chk_pv_pbbid_proc();