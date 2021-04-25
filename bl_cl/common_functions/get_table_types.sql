CREATE OR ALTER  FUNCTION get_table_types (@table_name NVARCHAR(50))
RETURNS @table_columns TABLE 
	(columns_structure nvarchar(225))
AS
BEGIN
WITH numeric_fields AS (
	SELECT CONCAT(COLUMN_NAME, 
		(CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL ' ELSE ' NULL ' END),
		DATA_TYPE, '(', NUMERIC_PRECISION, ',', NUMERIC_SCALE, ')'
		) AS columns_structure
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = lower(@table_name) AND
	DATA_TYPE IN ('decimal', 'numeric', 'float', 'real')
),
string_fields AS (
	SELECT CONCAT(COLUMN_NAME, 
		(CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL ' ELSE ' NULL ' END),
		DATA_TYPE, '(', CHARACTER_MAXIMUM_LENGTH ,')'
		) AS columns_structure
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = lower(@table_name) AND
	DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar', 'ntext', 'text')
),
other_fields AS (
	SELECT CONCAT(COLUMN_NAME, 
		(CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL ' ELSE ' NULL ' END),
		DATA_TYPE 
		) AS columns_structure
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = lower(@table_name) AND
	DATA_TYPE NOT IN ('varchar', 'nvarchar', 'char', 'nchar', 'ntext', 'text', 'decimal', 'numeric', 'float', 'real')
	)
	INSERT INTO @table_columns
	SELECT * FROM numeric_fields
	UNION ALL
	SELECT * FROM string_fields
	UNION ALL
	SELECT * FROM other_fields
	RETURN
END;
