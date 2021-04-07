 CREATE TABLE dim_coupons (
    coupon_surrogate_id  INTEGER PRIMARY KEY,
    coupon_id 			 INTEGER NOT NULL,
	coupon_natural_id 			 INTEGER NOT NULL,
    coupon_desc          VARCHAR2(60) NOT NULL,
    issued_quantity      INTEGER NOT NULL,
    update_dt            DATE NOT NULL
);


CREATE TABLE dim_customers (
    customer_surrogate_id     INTEGER PRIMARY KEY,
    customer_id  		 	  INTEGER NOT NULL,
	customer_natural_id  	  INTEGER NOT NULL,
    age_range                 VARCHAR2(8) NOT NULL,
    marital_status            VARCHAR2(40) NOT NULL,
    rented                    INTEGER NOT NULL,
    family_size               VARCHAR2(4) NOT NULL,
    no_of_child               VARCHAR2(4) NOT NULL,
    income_bracket            INTEGER NOT NULL,
    update_dt                 DATE  NOT NULL,
    age_range_id              INTEGER NOT NULL,
    no_of_child_id            INTEGER NOT NULL,
    family_size_id            INTEGER NOT NULL,
    marital_status_id         INTEGER NOT NULL
);



CREATE TABLE dim_employees (
    employee_surrogate_id     INTEGER PRIMARY KEY,
    employee_id               INTEGER NOT NULL,
	employee_natural_id       INTEGER NOT NULL,
    employee_name             VARCHAR2(80) NOT NULL,
    employee_surname          VARCHAR2(80) NOT NULL,
    age                       INTEGER NOT NULL,
    email                     VARCHAR2(80) NOT NULL,
    phone                     VARCHAR2(80) NOT NULL,
    update_dt                 DATE   NOT NULL
);

CREATE TABLE dim_payment_types (
    payment_type_surrogate_id  INTEGER PRIMARY KEY,
    payment_type_id            INTEGER NOT NULL,
	payment_type_natural_id    INTEGER NOT NULL,
    payment_type_desc          VARCHAR2(20) NOT NULL,
    update_dt                  DATE  NOT NULL
);


CREATE TABLE dim_products (
    product_surrogate_id     INTEGER PRIMARY KEY,
    product_id               INTEGER NOT NULL,
	product_natural_id       INTEGER NOT NULL,
    brand                    INTEGER NOT NULL,
    brand_type               VARCHAR2(20) NOT NULL,
    brand_id                 INTEGER NOT NULL,
    brand_type_id            INTEGER NOT NULL,
    product_category_desc    VARCHAR2(40) NOT NULL,
    product_category_id      INTEGER NOT NULL,
    start_date               DATE NOT NULL,
    end_date                 DATE NOT NULL,
    is_active                VARCHAR2(1) NOT NULL,
    update_dt                DATE  NOT NULL
);

CREATE TABLE dim_stores (
    store_surrogate_id  INTEGER PRIMARY KEY,
    store_id            INTEGER NOT NULL,
    store_number        VARCHAR2(14) NOT NULL,
    store_name          VARCHAR2(60) NOT NULL,
    street_address      VARCHAR2(255) NOT NULL,
    city_name           VARCHAR2(85) NOT NULL,
    state_or_province   VARCHAR2(14) NOT NULL,
    country_name        VARCHAR2(7) NOT NULL,
    postcode            VARCHAR2(12) NOT NULL,
    phone_number        VARCHAR2(20) NOT NULL,
    city_id             INTEGER NOT NULL,
    state_id            INTEGER NOT NULL,
    country_id          INTEGER NOT NULL,
    postcode_id         INTEGER NOT NULL,
	update_dt           DATE NOT NULL
);

CREATE TABLE dim_dates(
 sale_date DATE PRIMARY KEY,
 fulldate_desc VARCHAR2(40) NOT NULL,
 day_number_in_week INTEGER NOT NULL,
 day_of_week_desc VARCHAR2(25) NOT NULL,
 day_number_in_calendar_month INTEGER NOT NULL ,
 day_number_in_calendar_year INTEGER NOT NULL,
 calendar_week_number_in_year INTEGER NOT NULL,
 calendar_month INTEGER NOT NULL,
 calendar_month_desc VARCHAR2(25) NOT NULL,
 calendar_quarter INTEGER NOT NULL,
 calendar_year INTEGER NOT NULL,
 day_number_in_fiscal_month INTEGER  NOT NULL,
 day_number_in_fiscal_year INTEGER  NOT NULL,
 update_dt DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE fct_sales (
    sale_id          		   INTEGER PRIMARY KEY,
    product_surrogate_id       INTEGER NOT NULL,
    customer_surrogate_id      INTEGER NOT NULL,
    sale_date           	   DATE NOT NULL,
    coupon_surrogate_id        INTEGER NOT NULL,
    employee_surrogate_id      INTEGER NOT NULL,
    payment_type_surrogate_id  INTEGER NOT NULL,
    store_surrogate_id         INTEGER NOT NULL,
    quantity         		   INTEGER NOT NULL,
    selling_price    		   NUMBER(18, 2) NOT NULL,
    cost_price       		   NUMBER(18, 2) NOT NULL,
    other_discount   		   NUMBER(18, 2) NOT NULL,
    coupon_discount  		   NUMBER(18, 2) NOT NULL,
    update_dt        		   DATE NOT NULL
)
TABLESPACE USERS
PARTITION BY RANGE(sale_date)
(PARTITION part_default VALUES LESS THAN (TO_DATE('01.01.1980','dd.mm.yyyy')))
ENABLE ROW MOVEMENT;

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_coupons_fk FOREIGN KEY ( coupon_surrogate_id )
        REFERENCES dim_coupons ( coupon_surrogate_id );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_customers_fk FOREIGN KEY ( customer_surrogate_id )
        REFERENCES dim_customers ( customer_surrogate_id );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_dates_fk FOREIGN KEY ( employee_surrogate_id )
        REFERENCES dim_employees ( employee_surrogate_id );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_dates_fkv1 FOREIGN KEY ( sale_date )
        REFERENCES dim_dates ( sale_date );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_payment_types_fk FOREIGN KEY ( payment_type_surrogate_id )
        REFERENCES dim_payment_types ( payment_type_surrogate_id );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_products_fk FOREIGN KEY ( product_surrogate_id )
        REFERENCES dim_products ( product_surrogate_id );

ALTER TABLE fct_sales
    ADD CONSTRAINT sales_stores_fk FOREIGN KEY ( store_surrogate_id )
        REFERENCES dim_stores ( store_surrogate_id );  
