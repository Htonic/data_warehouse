 CREATE TABLE dim_coupons (
    coupon_surrogate_id  INTEGER NOT NULL, 
    coupon_id 			 INTEGER NOT NULL,
	coupon_natural_id 	 INTEGER NOT NULL,
    coupon_desc          NVARCHAR(60) NOT NULL,
    issued_quantity      INTEGER NOT NULL,
    update_dt            DATE NOT NULL
);


CREATE TABLE dim_customers (
    customer_surrogate_id     INTEGER NOT NULL,
    customer_id  		 	  INTEGER NOT NULL,
	customer_natural_id  	  INTEGER NOT NULL,
    age_range                 NVARCHAR(8) NOT NULL,
    marital_status            NVARCHAR(40) NOT NULL,
    rented                    INTEGER NOT NULL,
    family_size               NVARCHAR(4) NOT NULL,
    no_of_child               NVARCHAR(4) NOT NULL,
    income_bracket            INTEGER NOT NULL,
    update_dt                 DATE  NOT NULL,
    age_range_id              INTEGER NOT NULL,
    no_of_child_id            INTEGER NOT NULL,
    family_size_id            INTEGER NOT NULL,
    marital_status_id         INTEGER NOT NULL
);



CREATE TABLE dim_employees (
    employee_surrogate_id     INTEGER NOT NULL,
    employee_id               INTEGER NOT NULL,
	employee_natural_id       INTEGER NOT NULL,
    employee_name             NVARCHAR(80) NOT NULL,
    employee_surname          NVARCHAR(80) NOT NULL,
    age                       INTEGER NOT NULL,
    email                     NVARCHAR(80) NOT NULL,
    phone                     NVARCHAR(80) NOT NULL,
    update_dt                 DATE   NOT NULL
);

CREATE TABLE dim_payment_types (
    payment_type_surrogate_id  INTEGER NOT NULL,
    payment_type_id            INTEGER NOT NULL,
	payment_type_natural_id    INTEGER NOT NULL,
    payment_type_desc          NVARCHAR(20) NOT NULL,
    update_dt                  DATE  NOT NULL
);


CREATE TABLE dim_products (
    product_surrogate_id     INTEGER NOT NULL,
    product_id               INTEGER NOT NULL,
	product_natural_id       INTEGER NOT NULL,
    brand                    INTEGER NOT NULL,
    brand_type               NVARCHAR(20) NOT NULL,
    brand_id                 INTEGER NOT NULL,
    brand_type_id            INTEGER NOT NULL,
    product_category_desc    NVARCHAR(40) NOT NULL,
    product_category_id      INTEGER NOT NULL,
    start_date               DATE NOT NULL,
    end_date                 DATE NOT NULL,
    is_active                NVARCHAR(1) NOT NULL,
    update_dt                DATE  NOT NULL
);

CREATE TABLE dim_stores (
    store_surrogate_id  INTEGER NOT NULL,
    store_id            INTEGER NOT NULL,
    store_number        NVARCHAR(14) NOT NULL,
    store_name          NVARCHAR(60) NOT NULL,
    street_address      NVARCHAR(255) NOT NULL,
    city_name           NVARCHAR(85) NOT NULL,
    state_or_province   NVARCHAR(14) NOT NULL,
    country_name        NVARCHAR(7) NOT NULL,
    postcode            NVARCHAR(12) NOT NULL,
    phone_number        NVARCHAR(20) NOT NULL,
    city_id             INTEGER NOT NULL,
    state_id            INTEGER NOT NULL,
    country_id          INTEGER NOT NULL,
    postcode_id         INTEGER NOT NULL,
	update_dt           DATE NOT NULL
);

CREATE TABLE dim_dates(
 sale_date DATE NOT NULL, 
 fulldate_desc NVARCHAR(40) NOT NULL,
 day_number_in_week INTEGER NOT NULL,
 day_of_week_desc NVARCHAR(25) NOT NULL,
 day_number_in_calendar_month INTEGER NOT NULL ,
 day_number_in_calendar_year INTEGER NOT NULL,
 calendar_week_number_in_year INTEGER NOT NULL,
 calendar_month INTEGER NOT NULL,
 calendar_month_desc NVARCHAR(25) NOT NULL,
 calendar_quarter INTEGER NOT NULL,
 calendar_year INTEGER NOT NULL,
 day_number_in_fiscal_month INTEGER  NOT NULL,
 day_number_in_fiscal_year INTEGER  NOT NULL,
 update_dt DATE DEFAULT GETDATE()  NOT NULL
);

CREATE TABLE fct_sales (
    sale_id          		   INTEGER NOT NULL,
    product_surrogate_id       INTEGER NOT NULL,
    customer_surrogate_id      INTEGER NOT NULL,
    sale_date           	   DATE NOT NULL,
    coupon_surrogate_id        INTEGER NOT NULL,
    employee_surrogate_id      INTEGER NOT NULL,
    payment_type_surrogate_id  INTEGER NOT NULL,
    store_surrogate_id         INTEGER NOT NULL,
    quantity         		   INTEGER NOT NULL,
    selling_price    		   NUMERIC(18, 2) NOT NULL,
    cost_price       		   NUMERIC(18, 2) NOT NULL,
    other_discount   		   NUMERIC(18, 2) NOT NULL,
    coupon_discount  		   NUMERIC(18, 2) NOT NULL,
    update_dt        		   DATE NOT NULL
);


