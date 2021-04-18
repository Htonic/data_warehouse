CREATE OR ALTER  PROCEDURE src_to_cl.insert_sales
AS
DECLARE @cmd nvarchar(max) = '';
DECLARE @event_message nvarchar(max) = ''; 
BEGIN
	SET @cmd = 'TRUNCATE TABLE cl_sales';
    EXEC sys.sp_executesql @cmd;
    
    INSERT INTO cl_sales (cl_sale_id, coupon_id, store_id, payment_type_id, employee_id,
      sale_date, customer_id, item_id, quantity,
      selling_price, cost_price, other_discount, coupon_discount,update_dt)
    SELECT NEXT VALUE FOR cl_sale_seq,CAST(coupon_id AS INT), CAST(store_id AS INT),
    CAST(payment_type_id AS INT) ,CAST(employee_id AS INT),
      CAST(sale_date as date),CAST(customer_id AS INT), CAST(item_id AS INT), CAST(quantity AS INT),
      CAST(selling_price AS decimal(18, 2)), CAST(selling_price AS decimal(18, 2)) * 0.75,
      CAST(other_discount AS decimal(18, 2)), 
      CAST(coupon_discount AS decimal(18, 2)),
      GETDATE()
    FROM sa_src.dbo.src_sales;

    SET @event_message = CONCAT('Inserted ',  @@ROWCOUNT, ' rows into table cl_sales');
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;