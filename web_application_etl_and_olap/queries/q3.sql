select e.id as substations_with_least_incidents from element as e
left outer join incident as i
on e.id = i.id
group by e.id
having count(i.id) <= all(
    select count(i.id) from element as e
    left outer join incident as i
    on e.id = i.id
    group by e.id
    );