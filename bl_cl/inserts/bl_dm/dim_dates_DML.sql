alter session set nls_date_language = ENGLISH; --change language to english

INSERT INTO bl_dm.dim_dates (sale_date, fulldate_desc, day_number_in_week,
 day_of_week_desc, day_number_in_calendar_month, day_number_in_calendar_year,
 calendar_week_number_in_year, calendar_month, calendar_month_desc,
 calendar_quarter, calendar_year, day_number_in_fiscal_month, day_number_in_fiscal_year)
SELECT date_of_sale,
    TO_CHAR(date_of_sale, 'Day') || ' ' || EXTRACT(DAY FROM date_of_sale) || ' ' || TO_CHAR(date_of_sale, 'Mon') || ' ' || EXTRACT(YEAR FROM date_of_sale) AS  fulldate_desc,
    TO_CHAR(date_of_sale, 'D') AS day_number_in_week,
    TO_CHAR(date_of_sale, 'Day') AS day_of_week_desc, 
    EXTRACT(DAY FROM date_of_sale) AS day_number_in_calendar_month,
    TO_CHAR(date_of_sale, 'DDD') AS day_number_in_calendar_year,
    TO_CHAR(date_of_sale, 'WW') as calendar_week_number_in_year,
    EXTRACT(MONTH FROM date_of_sale) AS calendar_month,
    TO_CHAR(date_of_sale, 'Month') AS calendar_month_desc,
    TO_CHAR(date_of_sale, 'Q') AS calendar_quarter,
    EXTRACT(YEAR FROM date_of_sale) AS calendar_year,
    EXTRACT(DAY FROM date_of_sale) AS day_number_in_fiscal_month,
    TO_CHAR(date_of_sale, 'DDD') AS day_number_in_fiscal_year
    FROM (
    SELECT to_date('01.01.1970','DD.MM.YYYY') + level -1  AS date_of_sale
    FROM dual
    CONNECT by to_date('01.01.1970','DD.MM.YYYY') + level -1 <= to_date('31.12.2030','DD.MM.YYYY')
);
COMMIT;



