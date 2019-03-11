use AMendelsohn_2019;
go

drop table if exists RoomStay;
drop table if exists RoomStatus;
drop table if exists Room;
drop table if exists GuestStatus;
drop table if exists GuestLinkClass;
drop table if exists Guest;
drop table if exists Class;
drop table if exists ClassType;
drop table if exists ServiceSale;
drop table if exists ServiceStatus;
drop table if exists Service;
drop table if exists Receipt;
drop table if exists Inventory;
drop table if exists Supply;
--drop table if exists Rat;
drop table if exists Tavern;
drop table if exists Location;
drop table if exists TavernUser;
drop table if exists Role;
go

create table Role (
	id int identity primary key,
	name varchar(50) not null,
	role varchar(200) not null
);

create table TavernUser (
	id int identity primary key,
	name varchar(50) not null,
	roleId int foreign key references Role(id)
);

create table Location (
	id int identity primary key,
	name varchar(100) not null,
);

create table Tavern (
	id int identity primary key,
	name varchar(50) not null,
	locationId int foreign key references Location(id),
	userId int foreign key references TavernUser(id),
	numFloors int not null
);

--create table Rat (
--	id int identity primary key,
--	name varchar(50) not null,
--	tavernId int foreign key references Tavern(id)
--);

create table Supply (
	id int identity primary key,
	name varchar(50) not null,
	unit varchar(50)
);

create table Inventory (
	id int identity primary key,
	supplyId int foreign key references Supply(id),
	tavernId int foreign key references Tavern(id),
	updateDate date default(GETDATE()) not null,
	supplyCount int not null
);

create table Receipt (
	id int identity primary key,
	supplyId int foreign key references Supply(id),
	tavernId int foreign key references Tavern(id),
	cost money not null,
	amountReceived int not null,
	receiptDate date default(GETDATE()) not null
);

create table Service (
	id int identity primary key,
	name varchar(50) not null
);

create table ServiceStatus (
	id int identity primary key,
	name varchar(50) not null,
	serviceId int foreign key references Service(id)
);

create table ServiceSale (
	id int identity primary key,
	serviceId int foreign key references Service(id),
	guest varchar(50) not null,
	price money not null,
	purchaseDate date default(GETDATE()) not null,
	amountPurchased int not null,
	tavernId int foreign key references Tavern(id)
);

create table ClassType (
	id int identity primary key,
	name varchar(50) not null
);

create table Class (
	id int identity primary key,
	classTypeId int foreign key references ClassType(id),
	level int not null
);

create table Guest (
	id int identity primary key,
	name varchar(50) not null,
	notes varchar(200),
	birthday date not null,
	cakeday date,
	--classId int foreign key references Class(id),
	tavernId int
);
alter table Guest add foreign key (tavernId) references Tavern(id);

create table GuestLinkClass (
	guestId int foreign key references Guest(id),
	classId int foreign key references Class(id)
);

create table GuestStatus (
	id int identity,
	name varchar(50) not null,
	guestId int
);
alter table GuestStatus add primary key (id);
alter table GuestStatus add foreign key (guestId) references Guest(id);

create table Room (
	id int identity primary key,
	tavernId int foreign key references Tavern(id)
);

create table RoomStatus (
	id int identity primary key,
	name varchar(50) not null,
	roomId int foreign key references Room(id)
);

create table RoomStay (
	id int identity primary key,
	serviceSaleId int foreign key references ServiceSale(id),
	guestId int foreign key references Guest(id),
	roomId int foreign key references Room(id),
	dateStayedIn date default GETDATE(),
	rate money not null
);
go

insert into Role values ('Critic', 'Critiques the tavern');
insert into Role values ('Manager', 'Manages the tavern');
insert into Role values ('Cleaner', 'Cleans the tavern');
insert into Role values ('Bard', 'Entertains the guests');
insert into Role values ('Theologist', 'Wait, what?');
select * from Role;

insert into TavernUser values ('Mickey Mouse', 4);
insert into TavernUser values ('Roger Ebert', 1);
insert into TavernUser values ('Wall-E', 3);
insert into TavernUser values ('Bugs Bunny', 4);
insert into TavernUser values ('Plankton', 2);
select * from TavernUser;

insert into Location values ('Bikini Bottom'), ('Landfill'), ('Somewhere'), ('Kingdom Hearts'), ('Las Vegas');
select * from Location;

insert into Tavern values ('Chum Bucket', 1, 5, 2);
insert into Tavern values ('Krusty Krab', 1, 5, 1);
insert into Tavern values ('Wall-E Shelter', 2, 3, 1);
insert into Tavern values ('House of Critics', 3, 2, 2);
insert into Tavern values ('House of Mouse', 4, 1, 3);
select * from Tavern;

--insert into Rat values ('Alex', 1);
--insert into Rat values ('Brian', 2);
--insert into Rat values ('Cathy', 3);
--insert into Rat values ('Diana', 5);
--insert into Rat values ('Eric', 5);
--select * from Rat;

insert into Supply values ('Milk', 'Gallons');
insert into Supply values ('Egg', null);
insert into Supply values ('Sugar', 'Pounds');
insert into Supply values ('Flour', 'Pounds');
insert into Supply values ('Buffalo Sauce', 'Gallons');
select * from Supply;

insert into Inventory values (1, 1, '2019-01-01', 5);
insert into Inventory values (2, 2, '2019-01-02', 4);
insert into Inventory values (3, 3, '2019-01-03', 3);
insert into Inventory values (4, 4, '2019-01-04', 2);
insert into Inventory values (5, 5, '2019-01-05', 1);
select * from Inventory;

insert into Receipt values (1, 1, 2.00, 5, '2019-01-06');
insert into Receipt values (2, 2, 4.00, 4, '2019-01-07');
insert into Receipt values (3, 3, 6.00, 3, '2019-01-08');
insert into Receipt values (4, 4, 8.00, 2, '2019-01-09');
insert into Receipt values (5, 5, 10.00, 1, '2019-01-10');
select * from Receipt;

insert into Service values ('Singing');
insert into Service values ('Dancing');
insert into Service values ('Cleaning');
insert into Service values ('Assisting');
insert into Service values ('Critiquing');
select * from Service;

insert into ServiceStatus values ('Active', 1);
insert into ServiceStatus values ('Active', 2);
insert into ServiceStatus values ('Active', 3);
insert into ServiceStatus values ('Inactive', 4);
insert into ServiceStatus values ('Active', 5);
select * from ServiceStatus;

insert into ServiceSale values (1, 'Alice', 2.00, '2019-02-01', 5, 1);
insert into ServiceSale values (1, 'Buford', 5.00, '2019-02-02', 4, 2);
insert into ServiceSale values (1, 'Charlie', 9.00, '2019-02-03', 3, 3);
insert into ServiceSale values (1, 'Daniel', 19.00, '2019-02-04', 2, 4);
insert into ServiceSale values (1, 'Eli', 21.00, '2019-02-05', 1, 5);
select * from ServiceSale;

insert into ClassType values ('Bard'), ('Fighter'), ('Monk'), ('Wizard'), ('Sage');
select * from ClassType;

insert into Class values (1, 99), (2, 98), (3, 97), (4, 96), (5, 95);
select * from Class;

insert into Guest values ('Neil Patrick Harry', 'Plays Count Dracula', '1987-01-31', null, 1);
insert into Guest values ('Tom Crews', 'Is his own stunt double for sailing', '1987-02-01', '1987-02-01', 2);
insert into Guest values ('Leonardo DiCappy', 'Is a sentient cap that possesses actors', '1987-02-02', null, 3);
insert into Guest values ('Justin Beaver', 'Sings about dams', '1987-02-03', '1987-02-06', 4);
insert into Guest values ('Gandalf the Beige', 'Flies and is not a fool', '1987-02-04', null, 5);
select * from Guest;

insert into GuestLinkClass values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
select * from GuestLinkClass;

insert into GuestStatus values ('Hangry', 1);
insert into GuestStatus values ('Happy', 2);
insert into GuestStatus values ('Fine', 3);
insert into GuestStatus values ('Placid', 4);
insert into GuestStatus values ('Raging', 5);
select * from GuestStatus;

insert into Room values (1), (2), (3), (4), (5);
select * from Room;

insert into RoomStatus values ('Available', 1), ('No windows', 1), ('Available', 2), ('Available', 3), ('Available', 4), ('Available', 5);
select * from RoomStatus;

insert into RoomStay values (1, 1, 1, '2019-02-01', 5.00), (2, 2, 2, '2019-02-02', 5.00), (3, 3, 3, '2019-02-03', 5.00),
	(4, 4, 4, '2019-02-04', 5.00), (5, 5, 5, '2019-02-05', 5.00);
select * from RoomStay;
go

select name, birthday from Guest where YEAR(birthday) < 2000;
select Room.id, tavernId, serviceSaleId, guestId, dateStayedIn, rate
	from Room inner join RoomStay on Room.id = RoomStay.roomId where rate > 1.00; -- I'm treating $1.00 as 100 gold
select distinct name from Guest;
select * from Guest order by name asc;
select top 10 * from ServiceSale order by price desc;
select distinct TABLE_NAME from INFORMATION_SCHEMA.TABLES;
select g.name, ct.name as [className], c.level,
	(case when c.level <= 10 then '1-10' when c.level <= 20 then '11-20' when c.level <= 30 then '21-30' when c.level <= 40 then '31-40' when c.level <= 50 then '41-50'
		when c.level <= 60 then '51-60' when c.level <= 70 then '61-70' when c.level <= 80 then '71-80' when c.level <= 90 then '81-90' else '91-99' end) as [grouping]
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id) inner join ClassType ct on (c.classTypeId = ct.id);
drop table if exists DummyStatus;
create table DummyStatus (
	id int identity primary key,
	name varchar(50) not null,
	holderId int not null,
);
insert into DummyStatus select name, roomId from RoomStatus;
select * from DummyStatus;
go
