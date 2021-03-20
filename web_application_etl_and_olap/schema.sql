-------------------------------------------------------------
-- Project Assignment - Part 3 - Schema
-------------------------------------------------------------
drop table if exists analyses cascade;
drop table if exists lineincident cascade;
drop table if exists incident cascade;
drop table if exists transformer  cascade;
drop table if exists line cascade;
drop table if exists busbar cascade;
drop table if exists element cascade;
drop table if exists substation cascade;
drop table if exists analyst cascade;
drop table if exists supervisor cascade;
drop table if exists person cascade;

create table person(
    name varchar(80),
    address varchar(80),
    phone numeric(9),
    taxid numeric(20),
	primary key(name, address),
	unique(phone),
	unique(taxid)
);

create table supervisor(
	name varchar(80),
    address varchar(80),
	primary key(name, address),
	foreign key(name, address) references person(name, address)
);

create table analyst(
	name varchar(80),
    address varchar(80),
	primary key(name, address),
	foreign key(name, address) references person(name, address)
);

create table substation(
    gpslat numeric(9,6),
    gpslong numeric(8,6),
    locality varchar(80),
    sname varchar(80),
    saddress varchar(80),
    primary key(gpslat, gpslong),
    foreign key(sname, saddress) references supervisor(name, address)
);

create table element(
    id varchar(10),
    primary key(id)
);

create table busbar(
    id varchar(10),
    voltage numeric(7,4),
    primary key(id),
    foreign key(id) references element(id)
);

create table transformer(
    id varchar(10),
    pv numeric(7, 4),
    sv numeric(7, 4),
    gpslat numeric(9,6),
    gpslong numeric(8,6),
    pbbid varchar(10),
    sbbid varchar(10),
    primary key(id),
    foreign key(id) references element(id),
    foreign key(gpslat, gpslong) references substation(gpslat, gpslong),
    foreign key(pbbid) references busbar(id),
    foreign key(sbbid) references busbar(id),
    check(pbbid<>sbbid)
);

create table line(
    id varchar(10),
    impedance numeric(7,4),
    pbbid varchar(10),
    sbbid varchar(10),
    primary key(id),
    foreign key(id) references element(id),
    foreign key(pbbid) references busbar(id),
    foreign key(sbbid) references busbar(id),
    check(pbbid<>sbbid)
);

create table incident(
    instant timestamp,
    id varchar(10),
    description varchar(250),
    severity varchar(30),
    primary key(instant, id),
    foreign key(id) references element(id)
);

create table lineincident(
    instant timestamp,
    id varchar(10),
    point FLOAT,
    primary key(instant, id),
    foreign key(instant, id) references incident(instant, id)
);

create table analyses(
    instant timestamp,
    id varchar(10),
    report varchar(255),
	name varchar(80),
    address varchar(80),
    primary key(instant, id),
    foreign key(instant, id) references incident(instant, id),
    foreign key(name, address) references analyst(name, address)
);