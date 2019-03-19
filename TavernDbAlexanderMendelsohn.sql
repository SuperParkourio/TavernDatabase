use AMendelsohn_2019;
go

drop table if exists RoomStay;
drop table if exists RoomStatus;
drop table if exists Room;
drop table if exists GuestStatus;
drop table if exists GuestLinkClass;
drop table if exists ServiceSale;
drop table if exists Guest;
drop table if exists Class;
drop table if exists ClassType;
drop table if exists ServiceStatus;
drop table if exists Service;
drop table if exists Receipt;
drop table if exists Inventory;
drop table if exists Supply;
drop table if exists Tavern;
drop table if exists Location;
drop table if exists TavernUser;
drop table if exists Role;
go

create table Role (
	id int identity primary key,
	name varchar(50) not null,
	description varchar(200) not null
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
	tavernId int
);
alter table Guest add foreign key (tavernId) references Tavern(id);

create table ServiceSale (
	id int identity primary key,
	serviceId int foreign key references Service(id),
	guestId int foreign key references Guest(id),
	price money not null,
	purchaseDate date default(GETDATE()) not null,
	amountPurchased int not null,
	tavernId int foreign key references Tavern(id)
);

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
	roomId int foreign key references Room(id) on delete cascade
);

create table RoomStay (
	id int identity primary key,
	serviceSaleId int foreign key references ServiceSale(id),
	guestId int foreign key references Guest(id),
	roomId int foreign key references Room(id) on delete cascade,
	dateStayedIn date default GETDATE(),
	dateCheckedOut date default GETDATE(),
	rate money not null
);
go

insert into Role values ('Critic', 'Critiques the tavern');
insert into Role values ('Admin', 'Manages the tavern');
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

insert into ClassType values ('Bard'), ('Fighter'), ('Monk'), ('Wizard'), ('Sage');
select * from ClassType;

insert into Class values (1, 99), (2, 98), (3, 97), (4, 96), (5, 95), (3, 89);
select * from Class;

insert into Guest values ('Neil Patrick Harry', 'Plays Count Dracula', '1987-01-31', null, 1);
insert into Guest values ('Tom Crews', 'Is his own stunt double for sailing', '1987-02-01', '1987-02-01', 2);
insert into Guest values ('Leonardo DiCappy', 'Is a sentient cap that possesses actors', '1987-02-02', null, 3);
insert into Guest values ('Justin Beaver', 'Sings about dams', '1987-02-03', '1987-02-06', 4);
insert into Guest values ('Gandalf the Beige', 'Flies and is not a fool', '1987-02-04', null, 5);
select * from Guest;

insert into ServiceSale values (1, 1, 2.00, '2019-02-01', 5, 1);
insert into ServiceSale values (2, 2, 5.00, '2019-02-02', 4, 2);
insert into ServiceSale values (3, 3, 9.00, '2019-02-03', 3, 3);
insert into ServiceSale values (4, 4, 19.00, '2019-02-04', 2, 4);
insert into ServiceSale values (5, 5, 21.00, '2019-02-05', 1, 5);
select * from ServiceSale;

insert into GuestLinkClass values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (1, 6);
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

insert into RoomStay values (1, 1, 1, '2019-02-01', '2019-02-02', 5.00), (2, 2, 2, '2019-02-02', '2019-02-03', 5.00), (3, 3, 3, '2019-02-03', '2019-02-04', 5.00),
	(4, 4, 4, '2019-02-04', '2019-02-05', 5.00), (5, 5, 5, '2019-02-05', '2019-02-06', 5.00);
select * from RoomStay;
go

--Homework 3 Queries
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
go
create table DummyStatus (
	id int identity primary key,
	name varchar(50) not null,
	holderId int not null,
);
insert into DummyStatus select name, roomId from RoomStatus;
select * from DummyStatus;
go

--Homework 4 Queries
select tu.name, r.name as [role] from TavernUser tu inner join Role r on (tu.roleId = r.id) where r.name = 'Admin';
select tu.name as [username], r.name as [role], t.name as [tavernname], l.name as [locationName]
	from TavernUser tu inner join Role r on (tu.roleId = r.id) inner join Tavern t on (t.userId = tu.id) inner join Location l on (t.locationId = l.id)
	where r.name = 'Admin';
select g.name, c.level
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id)
	order by g.name asc;
select top 10 s.name, ss.price from ServiceSale ss inner join Service s on (ss.serviceId = s.id) order by ss.price;
select g.name, count(distinct c.id) as [numClasses]
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id)
	group by g.name
	having count(distinct c.id) >= 2;
select g.name, count(distinct c.id) as [numClasses]
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id and c.level > 5)
	group by g.name
	having count(distinct c.id) >= 2;
select g.name, ct.name as [class], c.level
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id) inner join ClassType ct on (ct.id = c.classTypeId)
		inner join
		(select g2.id, max(c2.level) as maxLvl from Class c2 inner join GuestLinkClass glc2 on c2.id = glc2.classId inner join Guest g2 on glc2.guestId = g2.id group by g2.id)
		gml on g.id = gml.id and gml.maxLvl = c.level;
declare @startdate date;
select @startdate = '2019-02-03';
declare @enddate date;
select @enddate = '2019-02-05';
select g.name, rs.dateStayedIn, rs.dateCheckedOut from Guest g inner join RoomStay rs on (g.id = rs.guestId)
	where DATEDIFF(day, @enddate, rs.dateStayedIn) <= 0 and DATEDIFF(day, rs.dateCheckedOut, @startdate) <= 0;
go

--Homework 5 Queries/Functions
select tu.id, tu.name, r.name as [role], r.description from TavernUser tu inner join Role r on tu.roleId = r.id;
select ct.name, count(distinct glc.guestId) as [guestCount]
	from ClassType ct inner join Class c on ct.id = c.classTypeId inner join GuestLinkClass glc on c.id = glc.classId
	group by ct.name;
drop function if exists LevelGrouping;
go
create function LevelGrouping(@level int)
returns varchar(15) as begin
	return case when @level <= 5 then 'Beginner' when @level <= 10 then 'Intermediate' else 'Expert' end;
end;
go
select g.name, ct.name as [class], c.level, dbo.LevelGrouping(c.level) as [rank]
	from Guest g inner join GuestLinkClass glc on (g.id = glc.guestId) inner join Class c on (glc.classId = c.id) inner join ClassType ct on (ct.id = c.classTypeId)
		inner join
		(select g2.id, max(c2.level) as maxLvl from Class c2 inner join GuestLinkClass glc2 on c2.id = glc2.classId inner join Guest g2 on glc2.guestId = g2.id group by g2.id)
		gml on g.id = gml.id and gml.maxLvl = c.level;
drop function if exists ReportUnusedRooms;
go
create function ReportUnusedRooms(@day date)
returns table as return
	select r.id as [roomNumber], rs.dateStayedIn, rs.dateCheckedOut, t.name, rs.rate
		from Room r inner join Tavern t on r.tavernId = t.id inner join RoomStay rs on r.id = rs.roomId
		where not (DATEDIFF(day, @day, rs.dateStayedIn) <= 0 and DATEDIFF(day, rs.dateCheckedOut, @day) <= 0);
go
select * from dbo.ReportUnusedRooms('2019-02-02');
drop function if exists ReportRoomsInPriceRange;
go
create function ReportRoomsInPriceRange(@priceLeftBound money, @priceRightBound money)
returns table as return
	select r.id as [roomNumber], rs.rate, t.name
		from Room r inner join Tavern t on r.tavernId = t.id inner join RoomStay rs on r.id = rs.roomId
		where @priceLeftBound <= rs.rate and rs.rate <= @priceRightBound;
go
select * from dbo.ReportRoomsInPriceRange(4.00, 6.00);
select * from dbo.ReportRoomsInPriceRange(3.00, 4.00);
insert into TavernUser(name, roleId) values ('RoboPlankton', 2);
insert into Tavern(name, locationId, userId, numFloors) values ('Discount Chum Bucket', 1, SCOPE_IDENTITY(), 1);
insert into Room(tavernId) values (SCOPE_IDENTITY());
insert into RoomStay(serviceSaleId, guestId, roomId, dateStayedIn, dateCheckedOut, rate) values (1, 1, SCOPE_IDENTITY(), '2019-03-05', '2019-03-05',
	(select top 1 rate from dbo.ReportRoomsInPriceRange(0, 10) order by rate asc) - 0.01
);
select * from TavernUser;
select * from Tavern;
select * from Room;
select * from RoomStay;
go

--Homework 6
drop procedure if exists GuestsWithClass;
go
create procedure GuestsWithClass
	@className varchar(50)
as begin
	select g.name, ct.name as 'class'
		from Guest g inner join GuestLinkClass glc on g.id = glc.guestId inner join Class c on glc.classId = c.id inner join ClassType ct on c.classTypeId = ct.id
		where ct.name = @className;
end;
go
drop procedure if exists TotalGuestSpentOnServices;
go
create procedure TotalGuestSpentOnServices
	@guestId int,
	@result money out
as begin
	select @result = sum(price * amountPurchased) from ServiceSale where guestId = @guestId;
end;
go
drop procedure if exists GuestsOfLevel;
go
create procedure GuestsOfLevel
	@level int,
	@getLower int = 0
as begin
	select g.name, ct.name as 'class', c.level
		from Guest g inner join GuestLinkClass glc on g.id = glc.guestId inner join Class c on glc.classId = c.id inner join ClassType ct on c.classTypeId = ct.id
		where (@getLower = 0 and c.level >= @level) or (@getLower = 1 and c.level <= @level)
		order by g.name, c.level desc;
end;
go
drop procedure if exists DeleteTavernWithId;
go
create procedure DeleteTavernWithId
	@tavernId int
as begin
	delete from Tavern where id = @tavernId;
end;
go
drop trigger if exists DeleteRecordsReferencingTavernId;
go
create trigger DeleteRecordsReferencingTavernId
	on Tavern instead of delete
as begin
	declare @tavernId int;
	select @tavernId = id from deleted;
	delete from Room where tavernId = @tavernId;
	delete from ServiceSale where tavernId = @tavernId;
	delete from Receipt where tavernId = @tavernId;
	delete from Inventory where tavernId = @tavernId;
	delete from Tavern where id = @tavernId;
end;
go
drop procedure if exists BookCheapestRoom;
go
create procedure BookCheapestRoom
	@serviceSaleId int,
	@guestId int
as begin
	declare @desiredRoomNum int;
	declare @desiredRate money;
	select top 1 @desiredRoomNum = roomNumber, @desiredRate = rate from dbo.ReportUnusedRooms(GETDATE()) order by rate asc;
	insert into RoomStay(serviceSaleId, guestId, roomId, dateStayedIn, dateCheckedOut, rate)
		values (@serviceSaleId, @guestId, @desiredRoomNum, GETDATE(), GETDATE(), @desiredRate);
end;
go
drop trigger if exists MakeCleaningServiceSaleForRoomStay;
go
create trigger MakeCleaningServiceSaleForRoomStay
	on RoomStay instead of insert
as begin
	declare @serviceSaleId int;
	select @serviceSaleId = serviceSaleId from inserted;
	if not exists (select * from ServiceSale where id = @serviceSaleId)
	begin
		declare @tavernId int;
		declare @guestId int;
		select @tavernId = r.tavernId, @guestId = i.guestId
			from inserted i inner join Room r on i.roomId = r.id;
		declare @cleaningServiceId int;
		select @cleaningServiceId = id from Service where name = 'Cleaning';
		declare @cleaningServicePrice money;
		select @cleaningServicePrice = price from ServiceSale where serviceId = @cleaningServiceId;
		insert into ServiceSale (serviceId, guestId, price, purchaseDate, amountPurchased, tavernId)
			values (@cleaningServiceId, @guestId, @cleaningServicePrice, GETDATE(), 1, @tavernId);
	end;
	insert into RoomStay select serviceSaleID, guestId, roomId, dateStayedIn, dateCheckedOut, rate from inserted;
end;
go
exec GuestsWithClass 'Monk';
declare @guestTotalSpendings money;
exec TotalGuestSpentOnServices 1, @guestTotalSpendings out;
select @guestTotalSpendings as 'spendings';
exec GuestsOfLevel 97;
exec GuestsOfLevel 97, 1;
exec DeleteTavernWithId 6;
select * from Tavern;
select * from Inventory;
select * from Receipt;
select * from ServiceSale;
select * from Room;
exec BookCheapestRoom 1, 1;
select * from RoomStay;
select * from ServiceSale;
exec BookCheapestRoom 6, 1; --serviceSaleId #6 will exist after this statement
select * from RoomStay;
select * from ServiceSale;
go
