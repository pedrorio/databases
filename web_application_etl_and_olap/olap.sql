select severity, locality, week_day, count(*) from f_incident
natural join d_location
natural join d_time
group by cube(severity, locality, week_day);