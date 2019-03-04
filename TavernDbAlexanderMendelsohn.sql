use master;
drop database if exists TavernDbAlexanderMendelsohn;
create database TavernDbAlexanderMendelsohn;
go
use TavernDbAlexanderMendelsohn;
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

create table Tavern (
	id int identity primary key,
	name varchar(50) not null,
	location varchar(100) not null,
	userId int foreign key references TavernUser(id),
	numFloors int not null
);

create table Rat (
	id int identity primary key,
	name varchar(50) not null,
	tavernId int foreign key references Tavern(id)
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

create table Status (
	id int identity primary key,
	name varchar(50) not null,
	serviceId int foreign key references Service(id)
);

create table Sales (
	id int identity primary key,
	serviceId int foreign key references Service(id),
	guest varchar(50) not null,
	price money not null,
	purchaseDate date default(GETDATE()) not null,
	amountPurchased int not null,
	tavernId int foreign key references Tavern(id)
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

insert into Tavern values ('Chum Bucket', 'Bikini Bottom', 5, 2);
insert into Tavern values ('Krusty Krab', 'Bikini Bottom', 5, 1);
insert into Tavern values ('Wall-E Shelter', 'Landfill', 3, 1);
insert into Tavern values ('House of Critics', 'Somewhere', 2, 2);
insert into Tavern values ('House of Mouse', 'Kingdom Hearts', 1, 3);
select * from Tavern;

insert into Rat values ('Alex', 1);
insert into Rat values ('Brian', 2);
insert into Rat values ('Cathy', 3);
insert into Rat values ('Diana', 5);
insert into Rat values ('Eric', 5);
select * from Rat;

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

insert into Status values ('Active', 1);
insert into Status values ('Active', 2);
insert into Status values ('Active', 3);
insert into Status values ('Inactive', 4);
insert into Status values ('Active', 5);
select * from Status;

insert into Sales values (1, 'Alice', 2.00, '2019-02-01', 5, 1);
insert into Sales values (1, 'Buford', 5.00, '2019-02-02', 4, 2);
insert into Sales values (1, 'Charlie', 9.00, '2019-02-03', 3, 3);
insert into Sales values (1, 'Daniel', 19.00, '2019-02-04', 2, 4);
insert into Sales values (1, 'Eli', 21.00, '2019-02-05', 1, 5);
select * from Sales;
go