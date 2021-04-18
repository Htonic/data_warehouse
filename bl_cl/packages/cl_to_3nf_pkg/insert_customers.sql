CREATE OR ALTER  PROCEDURE cl_to_3nf.insert_customers
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE bl_3nf.dbo.ce_customers';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO bl_3nf.dbo.ce_customers(customer_id, customer_natural_id, rented, income_bracket,
        age_range_id, marital_id, family_id, no_of_child_id, update_dt) 
    VALUES
        (-1, -1, 0, 0,
        -1, -1, -1, -1, GETDATE());
	SET @event_message = 'Inserted default value -1 for table bl_3nf.dbo.ce_customers';
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;


	INSERT INTO bl_3nf.dbo.ce_customers(customer_id, customer_natural_id, rented, income_bracket,
    age_range_id, marital_id, family_id, no_of_child_id, update_dt)
    SELECT NEXT VALUE FOR bl_3nf.dbo.customers, customer_id,
    CASE WHEN rented IS NULL THEN 0 ELSE rented END AS rented,
    CASE WHEN income_bracket IS NULL THEN 0 ELSE income_bracket END AS income_bracket,
    CASE WHEN car.age_range_id IS NULL THEN -1 ELSE car.age_range_id END AS age_range_id,
    CASE WHEN cms.marital_id IS NULL THEN -1 ELSE cms.marital_id END AS marital_id,
    CASE WHEN cfs.family_id IS NULL THEN -1 ELSE cfs.family_id END AS family_id,
    CASE WHEN cch.no_of_child_id IS NULL THEN -1 ELSE cch.no_of_child_id END AS no_of_child_id,
    GETDATE()
    FROM cl_customers sr
    LEFT JOIN bl_3nf.dbo.ce_age_range car ON car.age_range = sr.age_range
    LEFT JOIN bl_3nf.dbo.ce_family_sizes cfs ON cfs.family_size = sr.family_size
    LEFT JOIN bl_3nf.dbo.ce_marital_statuses  cms ON cms.marital_status = sr.marital_status 
    LEFT JOIN bl_3nf.dbo.ce_no_of_childs  cch ON cch.no_of_child = sr.no_of_children;
    
	SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table ce_customers');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;
    
    
    
  