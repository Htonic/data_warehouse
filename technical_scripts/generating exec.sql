
Select CONCAT('EXEC ', sch.name, '.', obj.name, ';') from sysobjects obj 
JOIN sys.schemas sch ON obj.uid = sch.schema_id
where obj.type = 'P' and obj.category = 0 and sch.name = 'bl_qa'
