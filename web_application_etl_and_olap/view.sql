create or replace view superv_subs_count(superv_name,superv_address,num_stations_supervised)
as
select sr.name as superv_name, sr.address as superv_address, count(*) as num_stations_supervised
from supervisor as sr
inner join substation as sb
on sr.name = sb.sname
and sr.address = sb.saddress
group by (sr.name,sr.address);