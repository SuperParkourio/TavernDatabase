use AMendelsohn_2019;
go

drop table if exists LabCreateTable;
create table LabCreateTable (
	id int identity,
	code varchar(100)
);
insert into LabCreateTable values (CONCAT('CREATE TABLE ', (select top 1 TABLE_NAME from INFORMATION_SCHEMA.COLUMNS where table_name = 'Tavern'))), ('(');
insert into LabCreateTable (code) select CONCAT('    ', COLUMN_NAME, ' ', DATA_TYPE, ',') from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Tavern';
update LabCreateTable set code = SUBSTRING(code, 1, LEN(code) - 1) where id = (select MAX(id) from LabCreateTable);
alter table LabCreateTable drop column id;
insert into LabCreateTable values (');');
select * from LabCreateTable;

select * from Tavern where name like '%Bucket';
