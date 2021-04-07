SELECT CONCAT('DROP TABLE ', TABLE_NAME, ';')
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE'

DROP TABLE dim_coupons;
DROP TABLE dim_customers;
DROP TABLE dim_employees;
DROP TABLE dim_payment_types;
DROP TABLE dim_products;
DROP TABLE dim_stores;
DROP TABLE dim_dates;
DROP TABLE fct_sales;