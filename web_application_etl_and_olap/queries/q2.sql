select name, address from supervisor
where (name,address) not in (
    select sname,saddress from substation
    where gpslat < 39.336775
    );