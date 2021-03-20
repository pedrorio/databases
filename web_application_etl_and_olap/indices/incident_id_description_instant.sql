-- List all descriptions of line incidents that start with a given prefix within two points in time:
-- SELECT id, description
-- FROM incident
-- WHERE instant BETWEEN < ts1 > AND < ts2 >
-- AND description LIKE '<S OME_PATTERN>% ';

create index idx_incident_id_description_instant if not exists on table incident (id, description, instant);
