use AMendelsohn_2019;
go

drop table if exists LabCreateTable;
go

create table LabCreateTable (
	id int identity,
	code varchar(100)
);
insert into LabCreateTable values (CONCAT('CREATE TABLE ', (select top 1 TABLE_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Tavern'))), ('(');
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
