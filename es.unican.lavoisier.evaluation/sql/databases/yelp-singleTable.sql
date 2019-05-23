USE master;
go

-- Eliminar base de datos si existe (usa tabla sys del sistema)
IF EXISTS(select * from sys.databases where name='yelpSingleTable')
  DROP DATABASE yelpSingleTable;
go

create database yelpSingleTable;
go

-- Usar la base de datos creada
use yelpSingleTable;
go

create table location (
    id int primary key,
    street varchar(80),
    postalCode varchar(80),
    city varchar(80)
);
go

insert into location values (1, 'picadilly', '882 LON', 'london');
insert into location values (2, 'Brick lane', '854 LON', 'london');
insert into location values (3, 'Abbey Post', '111 BIR', 'birmingham');
go

create table business (
    id int primary key,
    name varchar(80),
    stars decimal(2,1),
    locationId int foreign key references location(id)
);
go

insert into business values (1, 'pizza', 4, 1);
insert into business values (2, 'sushi', 5, 2);
insert into business values (3, 'vegan', 1, 3);

create table category (
    name varchar(40) primary key
);
go

insert into category values ('dj'),
                            ('kosher'),
                            ('buffet');

create table businessCategory (
    businessId int foreign key references business(id),
    category varchar(40) foreign key references category(name),
    primary key (businessId, category)
);
go

insert into businessCategory
values (1,'dj'), (2,'kosher'), (3,'buffet');

create table [user] (
    id int primary key,
    name varchar(40)
);
go

create table review (
    id int primary key,
    userId int foreign key references [user](id),
    businessId int foreign key references business (id),
    stars decimal(2,1),
    text varchar(2000)
);

create table featureGroup (
    id int primary key,
    name varchar(50)
);
go

insert into featureGroup values (1, 'GoodForMeal');


-- Diferences start here

create table feature (
    name varchar(80) primary key,
    type varchar(40)
);
go

insert into feature
values ('WiFi', 'AvailableFeature'),
       ('Parking', 'AvailableFeature'),
       ('Smoking', 'ValuedFeature'),
       ('breakfast', 'GroupedFeature');

create table businessFeature (
    businessId int foreign key references business(id),
    feature varchar(80) foreign key references feature(name),
    available varchar(5),
    value varchar(40),
    groupId int foreign key references featuregroup(id),
    primary key(businessId, feature)
);
go

insert into businessFeature
values (1, 'WiFi', 'true', null, null),
       (2, 'WiFi', 'false', null, null),
       (1, 'Parking', 'false', null, null),
       (2, 'Parking', 'true', null, null),
       (1, 'Smoking', null, 'yes', null),
       (2, 'Smoking', null, 'outdoor', null),
       (3, 'Smoking', null, 'no', null),
       (1, 'breakfast', 'true', null, 1);
