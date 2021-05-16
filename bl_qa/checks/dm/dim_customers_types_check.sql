CREATE OR ALTER  PROCEDURE bl_qa.dim_customers_types_check
AS
DECLARE @failed_count INT;
DECLARE @failed_perc DECIMAL(18, 2);
DECLARE @status_id  INT;
DECLARE @table_name NVARCHAR(20) = 'dim_customers';
DECLARE @event_message nvarchar(max) = '';
DECLARE @expected_table table (columns_structure nvarchar(225));
BEGIN

	INSERT INTO @expected_table VALUES 
	('age_range NOT NULL nvarchar(8)'),
	('marital_status NOT NULL nvarchar(40)'),
	('family_size NOT NULL nvarchar(4)'),
	('no_of_child NOT NULL nvarchar(4)'),
	('customer_surrogate_id NOT NULL int'),
	('customer_id NOT NULL int'),
	('customer_natural_id NOT NULL int'),
	('rented NOT NULL int'),
	('income_bracket NOT NULL int'),
	('update_dt NOT NULL date'),
	('age_range_id NOT NULL int'),
	('no_of_child_id NOT NULL int'),
	('family_size_id NOT NULL int'),
	('marital_status_id NOT NULL int');

	WITH first_comarison AS (
	SELECT COUNT(*) AS diff_1 FROM (
		SELECT * FROM @expected_table
		EXCEPT
		SELECT * FROM bl_dm.dbo.get_table_types(@table_name)
	)A
	),
	second_comparison AS (
	SELECT COUNT(*) AS diff_2 FROM (
		SELECT * FROM bl_dm.dbo.get_table_types(@table_name)
		EXCEPT
		SELECT * FROM @expected_table
	)A
	)
	SELECT @failed_count = (diff_1 + diff_2) FROM
		first_comarison, second_comparison;

	

	IF(@failed_count <> 0)
	  BEGIN
		SELECT @failed_perc  = ROUND(CAST(@failed_count AS decimal(18, 2)) / COUNT(*) * 100, 2)  
		FROM @expected_table;
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Failed';
	  END
	ELSE
	  BEGIN
		SET @failed_perc = 0.0;
		SELECT @status_id = status_id from bl_qa.dbo.check_status WHERE status_name = 'Passed';
	  END
	;
    
	INSERT INTO bl_qa.dbo.dq_checks(check_name, failed_perc,
						check_type_id, status_id, priority_id, stage_id)
	SELECT 'Data types check for dim_customers' as check_name,
	@failed_perc,
	(select check_type_id from bl_qa.dbo.check_type where check_type_name = 'ETL Check') as check_type_id,
	@status_id,
	(select priority_id from bl_qa.dbo.check_priority where priority_name = 'Critical') as priority_id,
	(select stage_id from bl_qa.dbo.stage where stage_name = 'bl_dm') as stage_id;


	SET @event_message = CONCAT('Check data types for dim_customers finished with status_id: ', @status_id);
    EXEC bl_cl.dbo.log_event @event_desc = @event_message;
END;