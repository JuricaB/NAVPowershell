set nocount on
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF

declare @company varchar(128) = '$(Company)';
declare @fromDatabase varchar(128) = '$(FromDatabase)';
declare @toDatabase varchar(128) = '$(ToDatabase)';

-- Temporary table containing a list of tables with user specific data.
-- tableName name of the table to get data from
-- UserSIDFieldName name of field in the table where the user id is stored
-- joinType: 0 - Means the field contains a User SID which which coresponds to the "User Security ID" field
--           1 - Means the field contains domain\user name which coresponds to the "User Name" field
create table #TablesWithUserData (tableName nvarchar(128), userSIDFieldName nvarchar(128), joinType int);
insert into #TablesWithUserData (tableName, userSIDFieldName, joinType) values
('Page Data Personalization', 	'User SID',		0), 
('Printer Selection', 		'User ID',		1), 
('User', 			'User Security ID', 	0),  
('User Default Style Sheet', 	'User ID',		0), 
('User Metadata', 		'User SID',		0),  
('User Personalization', 	'User SID',		0),  
('User Property', 		'User Security ID',	0), 
('Access Control', 		'User Security ID',	0);

-- Temporary table containing a list of tables that carry company specific data

-- drop table #TablesWithCompanySpecificData
create table #TablesWithCompanySpecificData (tableName nvarchar(128), companyFieldName nvarchar(128));
insert into #TablesWithCompanySpecificData (tableName, companyFieldName) values 
('Record Link', 'Company');

-- Temporary table containing a list of tables that are not copied

-- drop table #NotCopiedTables
create table #NotCopiedTables (tableName nvarchar(128));
insert into #NotCopiedTables (tableName) values 
('Active Session'),('Object Metadata Snapshot'),('Object Translation'),
('Report List Translation'),('Server Instance'),('Session Event'), ('Company');

-- print 'Copying table content for company '+@company+' from '+@fromDatabase+' to '+@toDatabase;

declare @sql varchar(max);
declare @columnList varchar(max);
declare @columnName varchar(128);
declare @fromTable varchar(128);
declare @toTable varchar(128);
declare @tableName varchar(128);
declare @dataPerCompany int;

-- Gather information about users to copy. All data from tables containing user specific data will be copied if the user ID coresponds to what we select here

-- drop table #UsersIDsToCopy
select distinct AC.[User Security ID] as [UserSID], U.[User Name] as [UserName] into #UsersIDsToCopy from [dbo].[Access Control] AC join [dbo].[User] U on AC.[User Security ID] = U.[User Security ID] where AC.[Company Name] = @company or AC.[Company Name] = '';
insert into #UsersIDsToCopy ([UserSID],[UserName]) values (newid(),''); -- Insert a blank value e.g. for the printer selection table the printer selection for blank need to be copied to all tenants

-- Main loop

declare tablesCursor CURSOR FOR 
select [oms].[Name], [oms].[Data Per Company] from [Object Metadata Snapshot] oms where not exists(select top 1 null from #NotCopiedTables ncd where ncd.[tableName] collate Latin1_General_100_CS_AS = oms.[Name]);

declare @hasIdentity int 

open tablesCursor
fetch next from tablesCursor into @tableName, @dataPerCompany
while (@@FETCH_STATUS <> -1)
begin
	if (@dataPerCompany = 1)
	begin
		set @fromTable = @company+'$'+@tableName;
	end else
	begin
		set @fromTable = @tableName;
	end;

	set @fromTable = replace(replace(replace(replace(@fromTable, '.','_'),'/','_'),'"','_'),'%','_');
	set @toTable = @fromTable;
	
	set @fromTable = '['+@fromDatabase+'].[dbo].['+@fromTable+']';
	set @toTable = '['+@toDatabase+'].[dbo].['+@toTable+']';

	set @columnList = '';
	declare columns CURSOR FOR select name from sys.columns where object_id = OBJECT_ID(@fromTable) and system_type_id <> 189 -- Leave out timestamp column
	open columns
	fetch next from columns into @columnName;
	while (@@FETCH_STATUS <> -1)
	begin
		set @columnList = @columnList +'['+@columnName+'],';
		fetch next from columns into @columnName;
	end
	close columns
	deallocate columns
        
        if (len(@columnList) = 0) continue

	set @columnList = substring(@columnList,1,len(@columnList)-1);

	set @sql = 'DELETE FROM '+@toTable;

	set @sql = @sql +'; INSERT INTO '+@toTable+' ('+@columnList+') SELECT '+@columnList+' FROM '+@fromtable;
	
	declare @filterClause nvarchar(max) = '';

	-- If the table contains user specific data handle it here

	declare @userSIDNameField nvarchar(128) 
	declare @joinType int
	declare tableWithUserDataCursor CURSOR FOR select userSIDFieldName, joinType from #TablesWithUserData where tableName = @tableName
	open tableWithUserDataCursor 
	fetch next from tableWithUserDataCursor into @userSIDNameField, @joinType;
	if (@@FETCH_STATUS <> -1)
	begin
		if (@joinType = 1)
		begin
			set @filterClause = @filterClause + ' JOIN #UsersIDsToCopy ON #UsersIDsToCopy.UserName = '+@fromTable+'.['++@userSIDNameField+']';
		end
		else
		begin
			set @filterClause = @filterClause + ' JOIN #UsersIDsToCopy ON #UsersIDsToCopy.UserSID = '+@fromTable+'.['++@userSIDNameField+']';
		end;
	end;
	close tableWithUserDataCursor
	deallocate tableWithUserDataCursor

	-- If the table contains company specific data handle it here

	declare @companyNameField nvarchar(128) = (select companyFieldName from #TablesWithCompanySpecificData where tableName = @tableName);
	
	if (not @companyNameField is null)
	begin
		set @filterClause = @filterClause + ' WHERE ['+@companyNameField+'] = N'''+@company+'''';
	end;

	set @sql = @sql + @filterClause;

	set @hasIdentity = (select count(*) from sys.columns where is_identity =1 and object_id = OBJECT_ID(@fromTable));

	if (@hasIdentity > 0)
	begin
		set @sql = 
			'SET IDENTITY_INSERT '+@toTable+' ON; ' + 
			@sql +
			'; SET IDENTITY_INSERT '+@toTable+' OFF';
	end;

	-- print 'Copying '+@tableName
	exec(@sql)
	--print @sql
	
	fetch next from tablesCursor into @tableName, @dataPerCompany
end
close tablesCursor
deallocate tablesCursor
-- print 'Done copying table content'
