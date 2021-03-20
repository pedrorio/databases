select name, address, count(gpslat)
from supervisor as sr
left outer join substation as sb
on sr.name = sb.sname and sr.address = sb.saddress
group by (name, address);
