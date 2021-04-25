TRUNCATE TABLE dim_dates;

SET LANGUAGE English;
DECLARE @StartDate DATE = '19700101';
DECLARE @EndDate DATE = '20301231';

WITH all_dates AS (
SELECT  DATEADD(DAY, nbr - 1, @StartDate) as generic_date
FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr
          FROM      sys.columns c
		  CROSS JOIN sys.columns AS s2
        ) nbrs
WHERE   nbr - 1 <= DATEDIFF(DAY, @StartDate, @EndDate))

INSERT INTO dim_dates (sale_date, fulldate_desc, day_number_in_week,
 day_of_week_desc, day_number_in_calendar_month, day_number_in_calendar_year,
 calendar_week_number_in_year, calendar_month, calendar_month_desc,
 calendar_quarter, calendar_year, day_number_in_fiscal_month, day_number_in_fiscal_year)

select  generic_date, 
CONCAT(DATENAME(dw, generic_date), ', ', DATEPART(d, generic_date), ' ',DATENAME(m,generic_date), ' ', DATEPART(yy, generic_date)) as   fulldate_desc,
DATEPART(dw, generic_date) AS day_number_in_week,
DATENAME(dw, generic_date) AS day_of_week_desc,
DATEPART(d, generic_date) AS day_number_in_calendar_month,
DATEPART(DAYOFYEAR, generic_date) AS day_number_in_calendar_year,
DATEPART(isowk, generic_date) AS calendar_week_number_in_year,
DATEPART(m, generic_date) AS calendar_month,
DATENAME(m, generic_date) AS calendar_month_desc,
DATEPART(QUARTER, generic_date) AS calendar_quarter,
DATEPART(YEAR, generic_date) AS calendar_year,
DATEPART(DAY, generic_date) AS day_number_in_fiscal_month,
DATEPART(DAYOFYEAR, generic_date) AS day_number_in_fiscal_year
from all_dates;