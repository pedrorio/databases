DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS supervisor CASCADE;
DROP TABLE IF EXISTS analyst CASCADE;
DROP TABLE IF EXISTS substation CASCADE;
DROP TABLE IF EXISTS element CASCADE;
DROP TABLE IF EXISTS line CASCADE;
DROP TABLE IF EXISTS bus_bar CASCADE;
DROP TABLE IF EXISTS line_connection CASCADE;
DROP TABLE IF EXISTS transformer CASCADE;
DROP TABLE IF EXISTS incident CASCADE;
DROP TABLE IF EXISTS line_incident CASCADE;
DROP TABLE IF EXISTS analyses CASCADE;

CREATE TABLE person (
    name VARCHAR(80),
    address VARCHAR(255),
    phone VARCHAR(15) UNIQUE NOT NULL,
    taxID VARCHAR(30) UNIQUE NOT NULL,
    CONSTRAINT pk_person PRIMARY KEY (name, address),
    CONSTRAINT chk_person_phone_min_length CHECK (length(phone) >= 3)
    -- every person must exist in at least one of the supervisor or analyst tables
);

CREATE TABLE supervisor (
    name VARCHAR(80),
    address VARCHAR(255),
    CONSTRAINT pk_supervisor PRIMARY KEY (name, address),
    CONSTRAINT fk_supervisor_person FOREIGN KEY (name, address) REFERENCES person(name, address)
);

CREATE TABLE analyst (
    name VARCHAR(80),
    address VARCHAR(255),
    CONSTRAINT pk_analyst PRIMARY KEY (name, address),
    CONSTRAINT fk_analyst_person FOREIGN KEY (name, address) REFERENCES person(name, address)
);

CREATE TABLE substation (
    latitude NUMERIC(9,6),
    longitude NUMERIC(8,6),
    locality_name VARCHAR(30),
    supervisor_name VARCHAR(255) NOT NULL,
    supervisor_address VARCHAR(255) NOT NULL,
    CONSTRAINT pk_substation PRIMARY KEY (latitude,longitude),
    CONSTRAINT fk_substation_supervisor FOREIGN KEY (supervisor_name, supervisor_address) REFERENCES supervisor (name, address)
    );

CREATE TABLE element(
    id VARCHAR(10),
    constraint pk_element PRIMARY KEY (id)
    -- Every element must exist in the line, bus_bar or transformer tables
    -- No element can exist at the same time in more than one of the line, bus_bar or transformer tables
);

CREATE TABLE line(
    id VARCHAR(10),
    impedance DOUBLE PRECISION NOT NULL,
    CONSTRAINT pk_line PRIMARY KEY (id),
    CONSTRAINT fk_line_element FOREIGN KEY (id) REFERENCES element (id)
    -- every line must appear in the line_connection table
);

CREATE TABLE bus_bar(
    id VARCHAR(10),
    voltage DOUBLE PRECISION NOT NULL,
    CONSTRAINT pk_bus_bar PRIMARY KEY (id),
    CONSTRAINT fk_busbar_element FOREIGN KEY (id) REFERENCES element (id)
);

CREATE TABLE line_connection(
    line_id VARCHAR(10),
    first_bus_bar_id VARCHAR(10),
    second_bus_bar_id VARCHAR(10),
    CONSTRAINT pk_line_connection PRIMARY KEY (line_id, first_bus_bar_id, second_bus_bar_id),
    CONSTRAINT fk_line_connection_line FOREIGN KEY (line_id) references line(id),
    CONSTRAINT fk_line_connection_first_bus_bar FOREIGN KEY(first_bus_bar_id) REFERENCES bus_bar(id),
    CONSTRAINT fk_line_connection_second_bus_bar FOREIGN KEY (second_bus_bar_id) REFERENCES bus_bar(id),
    CONSTRAINT chk_line_connection_diff_bus_bars CHECK (
        first_bus_bar_id <> second_bus_bar_id
    )
);

CREATE TABLE transformer(
    transformer_id VARCHAR(10),
    located_latitude NUMERIC(9,6),
    located_longitude NUMERIC(8,6),
    primary_busbar_id VARCHAR(10) NOT NULL,
    primary_voltage INTEGER NOT NULL,
    secondary_busbar_id VARCHAR(10) NOT NULL,
    secondary_voltage INTEGER NOT NULL,
    CONSTRAINT pk_transformer PRIMARY KEY (transformer_id),
    CONSTRAINT fk_transformer_located_substation FOREIGN KEY (located_latitude,located_longitude) REFERENCES substation (latitude,longitude),
    CONSTRAINT fk_transformer_is_element FOREIGN KEY (transformer_id) REFERENCES element (id),
    CONSTRAINT fk_transformer_busbar_connection_primary FOREIGN KEY (primary_busbar_id) REFERENCES bus_bar (id),
    CONSTRAINT fk_transformer_busbar_connection_secondary FOREIGN KEY (secondary_busbar_id) REFERENCES bus_bar (id),
    CONSTRAINT chk_line_connection_diff_bus_bars CHECK (
        primary_busbar_id <> secondary_busbar_id
    )
-- IC-1:  The voltage of the primary Bus Bar must match the primary voltage of the Transformer to which the Bus Bar is connected
-- IC-2: The voltage of the secondary Bus Bar must match the secondary voltage of the Transformer to which the Bus Bar is connected
    );

CREATE TABLE incident(
    element_id VARCHAR(10),
    instant TIMESTAMP NOT NULL,
    description VARCHAR(2000),
    severity VARCHAR(30),
    CONSTRAINT pk_incident PRIMARY KEY(element_id,instant),
    CONSTRAINT fk_incident_element FOREIGN KEY (element_id) REFERENCES element(id)
);

CREATE TABLE line_incident(
  element_id VARCHAR(10),
  instant TIMESTAMP NOT NULL,
  point NUMERIC(3,2),
  CONSTRAINT pk_lineincident PRIMARY KEY (element_id, instant),
  CONSTRAINT fk_lineincident_element FOREIGN KEY (element_id,instant) REFERENCES incident(element_id,instant)
);

CREATE TABLE analyses(
  analyst_name VARCHAR(80),
  analyst_address VARCHAR(255),
  analysed_element_id VARCHAR(10),
  analysed_incident_instant TIMESTAMP,
  report TEXT,
  CONSTRAINT pk_analyses PRIMARY KEY (analysed_element_id,analysed_incident_instant),
  CONSTRAINT fk_analyses_incident FOREIGN KEY (analysed_element_id,analysed_incident_instant) REFERENCES incident (element_id,instant),
  CONSTRAINT fk_analyses_analyst FOREIGN KEY (analyst_name,analyst_address) REFERENCES analyst (name,address)
-- IC-5 Persons cannot analyse incidents regarding elements of a substation they supervise
);

