-- We refrain from testing if repeat values can be entered in each of the tables in the primary key columns,
-- since the fact that they are defined as primary key prohibits it entirely

-- Inserting values into person
INSERT INTO person VALUES ('John Doe','Street With No Name','1234567890','111222333444555');
INSERT INTO person VALUES ('Ruby Tuesday','Rolling Street','968235648','123456789123');
INSERT INTO person VALUES ('Real Person','Real Street','222222222','222222222222222');
INSERT INTO person VALUES ('Gary Mediocre','Average Street','9100000000','100000000000000');
INSERT INTO person VALUES ('Jesus Christ','Kingdom of Judea','666666666','666666666666666');

-- Defining John Doe as a supervisor
INSERT INTO supervisor VALUES ('John Doe','Street With No Name');

-- Proving that supervisor is correctly defined as a specification of person (These inserts are meant to fail)
-- 1. Trying to insert a supervisor that is not a person in the database
-- INSERT INTO supervisor VALUES ('Impostor','Fake Street');
-- 2. Trying to insert a supervisor with the name of one person and the address of another
-- INSERT INTO supervisor VALUES ('John Doe','Real Street');

-- Defining Ruby Tuesday and Jesus Christ as analysts
INSERT INTO analyst VALUES ('Ruby Tuesday','Rolling Street');
INSERT INTO analyst VALUES ('Jesus Christ','Kingdom of Judea');

-- Defining Real Person as both a supervisor and an analyst (should work)
INSERT INTO supervisor VALUES ('Real Person','Real Street');
INSERT INTO analyst VALUES ('Real Person','Real Street');

-- Inserting some substations supervised by the existing supervisors
INSERT INTO substation VALUES (-77.0364,38.8951,'Hogwarts','John Doe','Street With No Name');
INSERT INTO substation VALUES (-20.2345,-10.6839,'Narnia','John Doe','Street With No Name');
INSERT INTO substation VALUES (65.8634,10.6839,'Neverland','Real Person','Real Street');
--Inserting a substation on the same location but at different coordinates
INSERT INTO substation VALUES (22.8634,-57.1139,'Narnia','John Doe','Street With No Name');

-- Testing some substation inserts that should fail
-- 1. Trying to insert a subsation without a supervisor
-- INSERT INTO substation VALUES (-12.3456,65.4321,'North Korea');
-- 2. Trying to insert a substation with a supervisor that is not a person
-- INSERT INTO substation VALUES (43.5558,05.0222,'Deimos','Fake Person','Nothing Street');
-- 3. Trying to insert a substation with a supervisor that is a person but not a supervisor
-- INSERT INTO substation VALUES (-19.1919,-18.1818,'Phobos','Gary Mediocre','Average Street');

-- Inserting values into grid_element
INSERT INTO element VALUES('B-789');
INSERT INTO element VALUES('B-202');
INSERT INTO element VALUES('B-303');
INSERT INTO element VALUES('B-404');
INSERT INTO element VALUES('B-505');
INSERT INTO element VALUES('L-606');
INSERT INTO element VALUES('L-707');
INSERT INTO element VALUES('T-808');
INSERT INTO element VALUES('T-909');
INSERT INTO element VALUES('T-101');

-- Inserting some values into line and bus_bar
INSERT INTO bus_bar VALUES('B-789','2000');
INSERT INTO bus_bar VALUES('B-202','1800');
INSERT INTO bus_bar VALUES('B-303','2200');
INSERT INTO bus_bar VALUES('B-404','1500');
INSERT INTO bus_bar VALUES('B-505','2350');
INSERT INTO line VALUES('L-606','40');
INSERT INTO line VALUES('L-707','60');

-- Inserting values into line connection
INSERT INTO line_connection VALUES('L-606','B-789','B-202');
INSERT INTO line_connection VALUES('L-707','B-789','B-303');

-- Testing some line connection inserts that should fail
-- 1. Trying to insert a connection between 2 lines and 1 bus bar
-- INSERT INTO line_connection VALUES('L-606','L-707','B-202');
-- 2. Trying to insert a connection using an id that's not even a grid_element
-- INSERT INTO line_connection VALUES('L-225','B-404','B-505');
-- 3. Trying to insert a connection using a a grid_element that's not a line
-- INSERT INTO line_connection VALUES('B-505','B-789','B-303');
-- 4. Trying to insert a connection repeating the same bus bar
-- INSERT INTO line_connection VALUES('L-707','B-505','B-505');
-- 5. Trying to insert a connection with only one bus bar
-- INSERT INTO line_connection VALUES('L-707','B-505');

-- Inserting values into transformer
INSERT INTO transformer VALUES('T-808',-77.0364,38.8951,'B-789','2000','B-202','1800');
INSERT INTO transformer VALUES('T-909',-20.2345,-10.6839,'B-303','2200','B-404','1500');
INSERT INTO transformer VALUES('T-101',-20.2345,-10.6839,'B-404','1500','B-505','2350');

-- Inserting values into incident
INSERT INTO incident VALUES('B-404','2020-10-01 04:05:06','The bus bar went bus bye','Urgent');
INSERT INTO incident VALUES('T-909','2020-10-24 14:25:36','The transformer overheated for 10 seconds and returned to normal temperature','Standard');
INSERT INTO incident VALUES('L-606','2020-10-11 08:15:03','The line became unaligned','Standard');
INSERT INTO incident VALUES('L-707','2020-11-02 22:43:57','A mouse chewed some cables','Immediate');
INSERT INTO incident VALUES('B-789','2020-10-13 13:13:13','The bus bar had a short-circuit','Very Urgent');
INSERT INTO incident VALUES('B-789','2020-09-30 18:30:00','The bus bar left the station','Standard');
INSERT INTO incident VALUES('B-789','2020-11-02 19:45:40','A dinosaur trampled the equipment','Urgent');
INSERT INTO incident VALUES('T-909','2020-10-29 02:32:54','The bus bar was attacked by a Pokemon','Standard');

-- Inserting values into line_incident
INSERT INTO line_incident VALUES('L-606','2020-10-11 08:15:03',3.63);
INSERT INTO line_incident VALUES('L-707','2020-11-02 22:43:57',1.43);

-- Inserting values into analyses
INSERT INTO analyses VALUES('Ruby Tuesday','Rolling Street','B-404','2020-10-01 04:05:06','This is a long report describing how the bus bar decided to go bye-bye');
INSERT INTO analyses VALUES('Real Person','Real Street','L-606','2020-10-11 08:15:03','The L-606 line suffered....(rest of the report)');
INSERT INTO analyses VALUES('Ruby Tuesday','Rolling Street','B-789','2020-10-13 13:13:13','Placeholder');
INSERT INTO analyses VALUES('Ruby Tuesday','Rolling Street','B-789','2020-11-02 19:45:40','A T-Rex trampled the bus bar and then vanished');
INSERT INTO analyses VALUES('Real Person','Real Street','B-789','2020-09-30 18:30:00','I really do not know what happened');
INSERT INTO analyses VALUES('Jesus Christ','Kingdom of Judea','T-909','2020-10-29 02:32:54','A Pikachu appeared and used Thunderbolt and the bus bar just could not handle it');