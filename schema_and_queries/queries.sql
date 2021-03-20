-- A. List the names of all analysts that analysed element with id 'B-789'
SELECT DISTINCT ant.name
FROM analyst ant
INNER JOIN analyses ans ON ant.name = ans.analyst_name AND ant.address = ans.analyst_address
INNER JOIN incident i ON ans.analysed_element_id = i.element_id
WHERE i.element_id = 'B-789';


-- B. What is the name of the analyst that has reported more incidents
SELECT ant.name
FROM analyst ant
INNER JOIN analyses ans ON ant.name = ans.analyst_name AND ant.address = ans.analyst_address
INNER JOIN incident i ON ans.analysed_element_id = i.element_id AND ans.analysed_incident_instant = i.instant
GROUP BY (ant.name,ant.address)
HAVING COUNT(*) >= ALL (
SELECT COUNT(*)
    FROM analyst ant
    INNER JOIN analyses ans ON ant.name = ans.analyst_name AND ant.address = ans.analyst_address
    INNER JOIN incident i ON ans.analysed_element_id = i.element_id AND ans.analysed_incident_instant = i.instant
    GROUP BY (ant.name,ant.address));

-- C. List all substations with more than one transformer
SELECT located_latitude, located_longitude
FROM transformer
GROUP BY (located_latitude, located_longitude)
HAVING COUNT(*) > 1;

-- D. Find the names of the localities that have more substations than every other locality
SELECT locality_name
FROM substation
GROUP BY locality_name
HAVING COUNT(*) >= ALL (
    SELECT COUNT (*)
    FROM substation
    GROUP BY locality_name);


