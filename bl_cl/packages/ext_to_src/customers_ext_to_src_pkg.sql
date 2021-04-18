CREATE OR ALTER  PROCEDURE ext_to_src.insert_customers
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE sa_src.dbo.src_customers';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO sa_src.dbo.src_customers ( customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented)
    SELECT customer_id, age_range, family_size, income_bracket,
     marital_status,no_of_children, rented FROM sa_src.dbo.external_customer_demographics;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table src_customers');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;

