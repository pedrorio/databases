select name, address
from analyses a
natural join incident
where id = 'B-789'
group by (name, address)
having count(*) = (
    select count(*)
    from incident
    where id = 'B-789'
);