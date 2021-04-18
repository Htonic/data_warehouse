CREATE OR ALTER  PROCEDURE src_to_cl.insert_customers
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_customers';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_customers ( customer_id, age_range, family_size, income_bracket,
    marital_status,no_of_children, rented)
    SELECT CAST(customer_id AS INT), trim(age_range), trim(family_size), CAST(income_bracket AS INT),
    CASE WHEN marital_status IS NULL THEN NULL ELSE trim(marital_status) END AS marital_status,
    CASE WHEN no_of_children IS NULL THEN NULL ELSE trim(no_of_children) END AS no_of_children,
    CAST(rented AS INT) FROM sa_src.dbo.src_customers;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_customers');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;