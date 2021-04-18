CREATE OR ALTER  PROCEDURE "3nf_to_dm".insert_customers
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_dm.dbo.dim_customers';
    EXEC sys.sp_executesql @cmd;

    INSERT INTO bl_dm.dbo.dim_customers (customer_surrogate_id, customer_id,customer_natural_id, age_range,
    marital_status, rented, family_size, no_of_child, income_bracket, age_range_id, no_of_child_id,
    family_size_id, marital_status_id, update_dt)
    SELECT NEXT VALUE FOR bl_dm.dbo.SEQUENCE_CUSTOMERS, cc.customer_id,cc.customer_natural_id,
    cag.age_range, cms.marital_status,
    cc.rented, cfs.family_size, cnof.no_of_child, 
    cc.income_bracket, cag.age_range_id, cnof.no_of_child_id,
    cfs.family_id, cms.marital_id, cc.update_dt
    FROM bl_3nf.dbo.ce_customers cc
    JOIN bl_3nf.dbo.ce_family_sizes cfs ON cfs.family_id = cc.family_id 
    JOIN bl_3nf.dbo.ce_no_of_childs cnof ON cnof.no_of_child_id = cc.no_of_child_id
    JOIN bl_3nf.dbo.ce_age_range cag ON cag.age_range_id = cc.age_range_id
    JOIN bl_3nf.dbo.ce_marital_statuses cms ON cms.marital_id = cc.marital_id;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table dim_customers');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;