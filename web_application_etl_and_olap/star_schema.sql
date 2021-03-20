DROP TABLE IF EXISTS d_time CASCADE;
DROP TABLE IF EXISTS d_reporter CASCADE;
DROP TABLE IF EXISTS d_location CASCADE;
DROP TABLE IF EXISTS d_element CASCADE;
DROP TABLE IF EXISTS f_incident CASCADE;


CREATE TABLE d_time(
  id_time INT NOT NULL,
  day INT NOT NULL,
  week_day VARCHAR(15) NOT NULL,
  week INT NOT NULL,
  month INT NOT NULL,
  trimester INT NOT NULL,
  year INT NOT NULL,
  PRIMARY KEY(id_time)
);

CREATE TABLE d_reporter(
  id_reporter SERIAL NOT NULL,
  name VARCHAR(80) NOT NULL,
  address VARCHAR(80) NOT NULL,
  PRIMARY KEY(id_reporter)
);

CREATE TABLE d_location(
  id_location SERIAL NOT NULL,
  latitude NUMERIC(9,6) NOT NULL,
  longitude NUMERIC(8,6) NOT NULL,
  locality VARCHAR(80) NOT NULL,
  PRIMARY KEY(id_location)
);

CREATE TABLE d_element(
  id_element SERIAL NOT NULL,
  element_id INT NOT NULL,
  element_type VARCHAR(15) NOT NULL,
  PRIMARY KEY(id_element)
);

CREATE TABLE f_incident(
  id_reporter INT NOT NULL,
  id_time INT NOT NULL,
  id_location INT NOT NULL,
  id_element INT NOT NULL,
  severity VARCHAR(30) NOT NULL,
  PRIMARY KEY(id_reporter, id_time, id_location, id_element),
  FOREIGN KEY(id_reporter) REFERENCES d_reporter(id_reporter),
  FOREIGN KEY(id_time) REFERENCES d_time(id_time),
  FOREIGN KEY(id_location) REFERENCES d_location(id_location),
  FOREIGN KEY(id_element) REFERENCES d_element(id_element)
);
