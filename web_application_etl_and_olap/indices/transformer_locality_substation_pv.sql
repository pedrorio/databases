-- Return the number of transformers with a given primary voltage by locality
-- SELECT locality, COUNT(*)
-- FROM transformer
-- NATURAL JOIN substation
-- WHERE pv = < some_value >
-- GROUP BY locality;

create index idx_substation_pv if not exists on table substation (pv) using hash;
create index idx_transformer_locality if not exists on table transformer (locality);
