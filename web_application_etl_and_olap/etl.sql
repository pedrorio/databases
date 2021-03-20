--
-- LOAD TIME DIMENSION
--

CREATE OR REPLACE FUNCTION load_d_time() RETURNS VOID AS
$$
DECLARE
date_value TIMESTAMP;
BEGIN
  date_value := '2017-01-02 00:00:00';
  WHILE
date_value < '2021-01-31 00:00:00' LOOP
    INSERT INTO d_time(
      id_time,
      day,
      week_day,
      week,
      month,
      trimester,
      year
    ) VALUES (
      EXTRACT(YEAR FROM date_value) * 10000
      + EXTRACT(MONTH FROM date_value) * 100
      + EXTRACT(DAY FROM date_value),
      EXTRACT(DAY FROM date_value),
      CASE
      WHEN EXTRACT (DOW FROM date_value) = 0 THEN 'Sunday'
      WHEN EXTRACT (DOW FROM date_value) = 1 THEN 'Monday'
      WHEN EXTRACT (DOW FROM date_value) = 2 THEN 'Tuesday'
      WHEN EXTRACT (DOW FROM date_value) = 3 THEN 'Wednesday'
      WHEN EXTRACT (DOW FROM date_value) = 4 THEN 'Thursday'
      WHEN EXTRACT (DOW FROM date_value) = 5 THEN 'Friday'
      ELSE 'Saturday'
      END,
      CAST(EXTRACT(WEEK FROM date_value) AS INTEGER),
      CAST(EXTRACT(MONTH FROM date_value) AS INTEGER),
      CASE
      WHEN EXTRACT (MONTH FROM date_value) IN (1,2,3) THEN 1
      WHEN EXTRACT (MONTH FROM date_value) IN (4,5,6) THEN 2
      WHEN EXTRACT (MONTH FROM date_value) IN (7,8,9) THEN 3
      ELSE 4
      END,
      CAST(EXTRACT(YEAR FROM date_value) AS INTEGER)
    );
    date_value := date_value + INTERVAL '1 DAY';
END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT load_d_time();


create or replace function get_d_time(instant timestamp) returns d_time as $$
declare
date_and_time d_time%ROWTYPE;
begin
select *
into date_and_time
from d_time
where id_time = cast(
            extract(year from instant) * 10000
            + extract(month from instant) * 100
            + extract(day from instant)
    as int);
return date_and_time;
end
$$
language plpgsql;

--
-- LOAD REPORTER DIMENSION
--

INSERT INTO d_reporter(name, address)
SELECT name, address
FROM analyst;

create or replace function get_d_reporter(reporter_name varchar(80), reporter_address varchar(80)) returns d_reporter as $$
declare
reporter d_reporter%ROWTYPE;
begin

select *
into reporter
from d_reporter
where (
              d_reporter.name = reporter_name and
              d_reporter.address = reporter_address and
              reporter_name is not null and
              reporter_address is not null
          );
return reporter;

end
$$ language plpgsql;


--
-- LOAD LOCATION DIMENSION
--

INSERT INTO d_location(latitude, longitude, locality)
SELECT gpslat, gpslong, locality
FROM substation;

drop type if exists location_data cascade;
create type location_data as (
    gpslat numeric(9, 6),
    gpslong numeric(8, 6),
    locality varchar(80)
);

create or replace function get_d_location_line(element_id varchar(10)) returns location_data as $$
declare location location_data;
begin
        select gpslat, gpslong, null as locality
        into location
        from incident
        join line on incident.id = line.id
        join transformer on line.pbbid = transformer.pbbid or line.sbbid = transformer.sbbid;
return location;
end
$$ language plpgsql;

create or replace function get_d_location_transformer(element_id varchar(10)) returns location_data as $$
declare location location_data;
begin
        select transformer.gpslat, transformer.gpslong, substation.locality
        into location
        from incident
        join transformer on transformer.id = element_id
        join substation on substation.gpslat = transformer.gpslat and substation.gpslong = transformer.gpslong;
return location;
end
$$ language plpgsql;

create or replace function get_d_location_busbar(element_id varchar(10)) returns location_data as $$
declare location location_data;
begin
        select transformer.gpslat, transformer.gpslong, substation.locality
        into location
        from incident
        join busbar on busbar.id = element_id
        join transformer on busbar.id = transformer.pbbid or busbar.id = transformer.sbbid
        join substation on substation.gpslat = transformer.gpslat and substation.gpslong = transformer.gpslong;
return location;
end
$$ language plpgsql;

create or replace function get_d_location(element_id varchar(10)) returns d_location as $$
declare element_location location_data;
declare location d_location%ROWTYPE;
begin
    case
    when split_part(element_id, '-',1) = 'L' then
        select gpslat, gpslong, locality
        into element_location
        from get_d_location_line(element_id);
    when split_part(element_id, '-',1) = 'B' then
        select gpslat, gpslong, locality
        into element_location
        from get_d_location_busbar(element_id);
    when split_part(element_id, '-',1) = 'T' then
        select gpslat, gpslong, locality
        into element_location
        from get_d_location_transformer(element_id);
    end case;

    select *
    into location
    from d_location
    where (
        d_location.longitude = element_location.gpslong and
        d_location.latitude = element_location.gpslat
    );

return location;
end
$$ language plpgsql;

--
-- LOAD ELEMENT DIMENSION
--

create or replace function load_d_element() returns void as $$
declare
begin
insert into d_element (element_id, element_type)
select cast(split_part(id, '-', 2) as int),
       case
           when split_part(id, '-', 1) = 'L' then 'Line'
           when split_part(id, '-', 1) = 'B' then 'Bus Bar'
           when split_part(id, '-', 1) = 'T' then 'Transformer'
        end
from element;
end
$$ language plpgsql;

select load_d_element();

create or replace function get_d_element(incident_id varchar(10)) returns d_element as $$
declare element d_element%ROWTYPE;
begin
    select *
    into element
    from d_element
    where (
                  d_element.element_id = cast(split_part(incident_id, '-', 2) as int) and
                  d_element.element_type = case
                                               when split_part(incident_id, '-', 1) = 'L' then 'Line'
                                               when split_part(incident_id, '-', 1) = 'B' then 'Bus Bar'
                                               when split_part(incident_id, '-', 1) = 'T' then 'Transformer'
                                            end
              );
return element;
end
$$ language plpgsql;

--
-- LOAD INCIDENT FACTS
--

create or replace function load_f_incident() returns void as $$
declare
begin
insert into f_incident (id_reporter, id_time, id_location, id_element, severity)
select (select id_reporter from get_d_reporter(analyses.name, analyses.address)),
       (select id_time from get_d_time(incident.instant)),
       (select id_location from get_d_location(incident.id)),
       (select id_element from get_d_element(incident.id)),
       incident.severity
from incident
natural join analyses
natural join analyst;
end;
$$
language plpgsql;

select load_f_incident();