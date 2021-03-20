insert into
    person (name, address, phone, taxid)
values
    ('John Doe','Street With No Name',123456789,1112223334445556667),
    ('Ruby Tuesday','Rolling Street',968235648,12345678912345678912),
    ('Real Person','Real Street',222222222,22222222222222222222),
    ('Gary Mediocre','Average Street',910000000,10000000000000000000),
    ('Jesus Christ','Kingdom of Judea',666666666,66666666666666666666);

insert into
    supervisor (name, address)
values
    ('John Doe','Street With No Name'),
    ('Real Person','Real Street'),
    ('Gary Mediocre','Average Street');


insert into
    analyst (name, address)
values
    ('Ruby Tuesday','Rolling Street'),
    ('Jesus Christ','Kingdom of Judea'),
    ('Real Person','Real Street');

insert into
    substation (gpslat, gpslong, locality, sname, saddress)
values
    (-77.0364,38.8951,'Hogwarts','John Doe','Street With No Name'),
    (-20.2345,-10.6839,'Narnia','John Doe','Street With No Name'),
    (65.8634,10.6839,'Neverland','Real Person','Real Street'),
    (22.8634,-57.1139,'Narnia','John Doe','Street With No Name');

insert into
    element (id)
values
    ('B-789'),
    ('B-202'),
    ('B-303'),
    ('B-404'),
    ('B-505'),
    ('L-606'),
    ('L-707'),
    ('T-808'),
    ('T-909'),
    ('T-101'),
    ('T-111');


insert into
    busbar (id, voltage)
values
    ('B-789',200.0000),
    ('B-202',180.0000),
    ('B-303',220.0000),
    ('B-404',150.0000),
    ('B-505',235.0000);

insert into
    transformer (id, gpslat, gpslong, pv, sv, pbbid, sbbid)
values
    ('T-808',-77.0364,38.8951,200.0000,180.0000,'B-789','B-202'),
    ('T-909',-20.2345,-10.6839,220.0000,150.0000,'B-303','B-404'),
    ('T-101',-20.2345,-10.6839,150.0000,235.0000,'B-404','B-505');

insert into
    line (id, impedance, pbbid, sbbid)
values
    ('L-606', 040.0000, 'B-789', 'B-202'),
    ('L-707', 060.0000, 'B-789', 'B-303');

insert into
    incident (instant, id, severity, description)
values
    ('2020-10-01 04:05:06','B-404','Urgent','The bus bar went bus bye'),
    ('2020-10-24 14:25:36','T-909','Standard','The transformer overheated for 10 seconds and returned to normal temperature'),
    ('2020-10-11 08:15:03','L-606','Standard','The line became unaligned'),
    ('2020-11-02 22:43:57','L-707','Immediate','A mouse chewed some cables'),
    ('2020-10-13 13:13:13','B-789','Very Urgent','The bus bar had a short-circuit'),
    ('2020-09-30 18:30:00','B-789','Standard','The bus bar left the station'),
    ('2020-11-02 19:45:40','B-789','Urgent','A dinosaur trampled the equipment'),
    ('2020-10-29 02:32:54','T-909','Standard','The transformer was attacked by a Pokemon'),
    ('2020-11-11 11:11:11','T-909','Not Urgent','The transformer turned off and on again');


insert into
    lineincident (instant, id, point)
values
    ('2020-10-11 08:15:03','L-606',3.63),
    ('2020-11-02 22:43:57','L-707',1.43);


insert into
    analyses (instant, id, report, name, address)
values
    ('2020-10-01 04:05:06','B-404','This is a long report describing how the bus bar decided to go bye-bye','Ruby Tuesday','Rolling Street'),
    ('2020-10-11 08:15:03','L-606','The L-606 line suffered....(rest of the report)','Real Person','Real Street'),
    ('2020-10-13 13:13:13','B-789','Placeholder','Ruby Tuesday','Rolling Street'),
    ('2020-11-02 19:45:40','B-789','A T-Rex trampled the bus bar and then vanished','Ruby Tuesday','Rolling Street'),
    ('2020-09-30 18:30:00','B-789','I really do not know what happened','Ruby Tuesday','Rolling Street');