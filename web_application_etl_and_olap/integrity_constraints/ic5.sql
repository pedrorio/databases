drop trigger if exists chk_a_t_s_sname_saddress on analyses;
drop function if exists chk_a_t_s_sname_saddress_proc();

create or replace function chk_a_t_s_sname_saddress_proc() returns trigger as
$$
declare ss substation%rowtype;
declare t transformer%rowtype;
begin

--  element -- transformer
    select * into t
    from transformer
    where id = new.id;

--  transformer -- substation
    select * into ss
    from substation
    where (
        t.gpslat = substation.gpslat
            and
        t.gpslong = substation.gpslong);

    if ss.sname = new.name and ss.saddress = new.address then
        raise exception 'The name and address cannot be the same in the analyst and substation'
        using hint = 'Please ensure a different combination of names and address';
    end if;

    return new;
end
$$ language plpgsql;

create trigger chk_a_t_s_sname_saddress
before insert or update on analyses
for each row execute procedure chk_a_t_s_sname_saddress_proc();