use AMendelsohn_2019;
go

drop table if exists LabCreateTable;
go
create table LabCreateTable (
	id int identity,
	code varchar(100)
);
insert into LabCreateTable values (CONCAT('create table ', (select top 1 TABLE_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Tavern'))), ('(');
insert into LabCreateTable (code) select CONCAT('    ', c.COLUMN_NAME, ' ', c.DATA_TYPE,
	case when c.CHARACTER_MAXIMUM_LENGTH is not null then CONCAT('(', c.CHARACTER_MAXIMUM_LENGTH, ')') else '' end,
	COALESCE(
		(select CONCAT (' foreign key references ', kcu.TABLE_NAME, '(', kcu.COLUMN_NAME, ')')
			from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
				inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc on (tc.CONSTRAINT_NAME = rc.CONSTRAINT_NAME)
				inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu on (rc.UNIQUE_CONSTRAINT_NAME = kcu.CONSTRAINT_NAME)
				inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu2 on (tc.CONSTRAINT_NAME = kcu2.CONSTRAINT_NAME)
			where tc.CONSTRAINT_TYPE = 'FOREIGN KEY' and tc.TABLE_NAME = 'Tavern' and kcu2.COLUMN_NAME = c.COLUMN_NAME)
	, ''),
	case when exists(
		select sysObj.name, sysCol.name 
			from sys.objects sysObj inner join sys.columns sysCol on sysObj.object_id = sysCol.object_id 
			where sysCol.is_identity = 1 and sysObj.name = 'Tavern' and sysCol.name = c.COLUMN_NAME
	) then ' identity' else '' end,
	case when exists(
		select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu on (tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME)
			where tc.CONSTRAINT_TYPE = 'PRIMARY KEY' and tc.TABLE_NAME = 'Tavern' and kcu.COLUMN_NAME = c.COLUMN_NAME
	) then ' primary key' else '' end,
	',') from INFORMATION_SCHEMA.COLUMNS c where c.TABLE_NAME = 'Tavern';
update LabCreateTable set code = SUBSTRING(code, 1, LEN(code) - 1) where id = (select MAX(id) from LabCreateTable);
alter table LabCreateTable drop column id;
insert into LabCreateTable values (');');
select * from LabCreateTable;
go

select * from Tavern where name like '%Bucket';
go

drop function if exists MakeMeACreateTable;
go
create function MakeMeACreateTable(@tableName varchar(50))
returns table as
return
	SELECT 
	CONCAT('CREATE TABLE ',TABLE_NAME, ' (') as queryPiece 
	FROM INFORMATION_SCHEMA.TABLES
	 WHERE TABLE_NAME = @tableName
	UNION ALL
	SELECT CONCAT(cols.COLUMN_NAME, ' ', cols.DATA_TYPE, 
	(
	CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
	Then CONCAT
	('(', CAST(CHARACTER_MAXIMUM_LENGTH as varchar(100)), ')') 
	Else '' 
	END)
	, 
	CASE WHEN CONSTRAINT_TYPE = 'PRIMARY KEY'
	Then 
	(' PRIMARY KEY') 
	Else '' 
	END
	, 
	CASE WHEN CONSTRAINT_TYPE = 'FOREIGN KEY'
	Then 
	(CONCAT(' FOREIGN KEY REFERENCES ', constKeys.TABLE_NAME, '(', constKeys.COLUMN_NAME, ')')) 
	Else '' 
	END
	, 
	CASE WHEN sysCol.is_identity = 1
	Then 
	(' IDENTITY') 
	Else '' 
	END
	,
	',') as queryPiece FROM 
	INFORMATION_SCHEMA.COLUMNS as cols
	LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as keys ON 
	(keys.TABLE_NAME = cols.TABLE_NAME and keys.COLUMN_NAME = cols.COLUMN_NAME)
	LEFT JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as refConst ON 
	(refConst.CONSTRAINT_NAME = keys.CONSTRAINT_NAME)
	LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS as consts ON 
	(consts.TABLE_NAME = cols.TABLE_NAME AND consts.CONSTRAINT_NAME = keys.CONSTRAINT_NAME)
	LEFT JOIN 
	(SELECT DISTINCT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE) 
	as constKeys ON (constKeys.CONSTRAINT_NAME = refConst.UNIQUE_CONSTRAINT_NAME)
	JOIN sys.objects sysObj ON (sysObj.Name = cols.TABLE_NAME)
	JOIN sys.columns sysCol ON (sysObj.object_id = sysCol.object_id AND SysCol.Name = cols.COLUMN_NAME)
	 WHERE cols.TABLE_NAME = @tableName
	UNION ALL
	SELECT ')';
go
select * from MakeMeACreateTable('Tavern');
go

drop function if exists pricing;
go
create function pricing(@serviceSaleId int)
returns money as
begin
	declare @result money;
	select @result = price * amountPurchased from ServiceSale where @serviceSaleId = id;
	return @result;
end;
go
select s.name, ss.price, ss.amountPurchased, dbo.pricing(ss.id) as [totalPrice] from ServiceSale ss inner join Service s on (ss.serviceId = s.id);
go
