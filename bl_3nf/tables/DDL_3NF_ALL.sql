CREATE TABLE ce_age_range (
    age_range_id  INTEGER PRIMARY KEY,
    age_range     VARCHAR2(8) NOT NULL,
    update_dt     DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_cities (
    city_id    INTEGER PRIMARY KEY,
    city_name  VARCHAR2(85) NOT NULL,
    state_id   INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_countries (
    country_id    INTEGER PRIMARY KEY,
    country_name  VARCHAR2(7) NOT NULL,
    update_dt    DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_coupons(
    coupon_id            INTEGER PRIMARY KEY,
    coupon_natural_id  INTEGER NOT NULL,
    coupon_desc          VARCHAR2(60) NOT NULL,
    issued_quantity   INTEGER NOT NULL,
    update_dt            DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_customers (
    customer_id            INTEGER PRIMARY KEY,
    customer_natural_id  INTEGER NOT NULL,
    rented                 INTEGER NOT NULL,
    income_bracket         INTEGER NOT NULL,
    age_range_id           INTEGER DEFAULT -1 NOT NULL,
    marital_id             INTEGER DEFAULT -1 NOT NULL,
    family_id              INTEGER DEFAULT -1 NOT NULL,
    no_of_child_id         INTEGER DEFAULT -1 NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_employees (
    employee_id            INTEGER PRIMARY KEY,
    employee_natural_id  INTEGER NOT NULL,
    employee_name          VARCHAR2(80) NOT NULL,
    employee_surname       VARCHAR2(80) NOT NULL,
    age                    INTEGER NOT NULL,
    email                  VARCHAR2(80) NOT NULL,
    phone                  VARCHAR2(80) NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_family_sizes (
    family_id    INTEGER PRIMARY KEY,
    family_size  VARCHAR2(4) NOT NULL,
    update_dt    DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_marital_statuses (
    marital_id      INTEGER PRIMARY KEY,
    marital_status  VARCHAR2(40) NOT NULL,
    update_dt       DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_no_of_childs (
    no_of_child_id  INTEGER PRIMARY KEY,
    no_of_child     VARCHAR2(4) NOT NULL,
    update_dt       DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_payment_types (
    payment_type_id            INTEGER PRIMARY KEY,
    payment_type_natural_id  INTEGER NOT NULL,
    payment_type_desc          VARCHAR2(20) NOT NULL,
    update_dt                  DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_postcodes (
    postcode_id  INTEGER PRIMARY KEY,
    postcode     VARCHAR2(12) NOT NULL,
    update_dt    DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE ce_product_brand (
    brand_id    INTEGER PRIMARY KEY,
    brand       INTEGER,
    brand_type_id INTEGER DEFAULT -1 NOT NULL,
    update_dt   DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE ce_product_brand_types (
    brand_type_id INTEGER PRIMARY KEY,
    brand_type  VARCHAR2(20),
    update_dt   DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE ce_product_categories (
    product_category_id    INTEGER PRIMARY KEY,
    product_category_desc  VARCHAR2(40) NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_products (
    product_id            INTEGER PRIMARY KEY,
    product_natural_id    INTEGER NOT NULL,
    brand_id              INTEGER DEFAULT -1 NOT NULL,
    product_category_id   INTEGER DEFAULT -1 NOT NULL,
    start_date            DATE DEFAULT CURRENT_DATE NOT NULL,
    end_date              DATE DEFAULT '31-12-9999' NOT NULL,
    is_active           CHAR(1) NOT NULL,
    update_dt             DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_sales (
    sale_id          INTEGER PRIMARY KEY,
	cl_sale_id       INTEGER,
    product_id       INTEGER DEFAULT -1 NOT NULL,
    customer_id      INTEGER DEFAULT -1 NOT NULL,
    sale_date        DATE NOT NULL,
    coupon_id        INTEGER DEFAULT -1 NOT NULL,
    employee_id      INTEGER DEFAULT -1 NOT NULL,
    payment_type_id  INTEGER DEFAULT -1 NOT NULL,
    store_id         INTEGER DEFAULT -1 NOT NULL,
    quantity         INTEGER NOT NULL,
    selling_price    NUMBER(18, 2) NOT NULL,
    other_discount   NUMBER(18, 2) NOT NULL,
    coupon_discount  NUMBER(18, 2) NOT NULL,
    cost_price       NUMBER(18, 2) NOT NULL,
    update_dt        DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_states (
    state_id    INTEGER PRIMARY KEY,
    state_name  VARCHAR2(14) NOT NULL,
    country_id  INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT CURRENT_DATE NOT NULL
);


CREATE TABLE ce_stores (
    store_id        INTEGER PRIMARY KEY,
    store_number    VARCHAR2(14) NOT NULL,
    store_name      VARCHAR2(60) NOT NULL,
    street_address  VARCHAR2(255) NOT NULL,
    phone_number    VARCHAR2(20) NOT NULL,
    city_id         INTEGER DEFAULT -1 NOT NULL,
    postcode_id     INTEGER DEFAULT -1 NOT NULL,
    update_dt      DATE DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE ce_cities
    ADD CONSTRAINT city_state_fk FOREIGN KEY ( state_id )
        REFERENCES ce_states ( state_id );

ALTER TABLE ce_customers
    ADD CONSTRAINT customers_age_range_fk FOREIGN KEY ( age_range_id )
        REFERENCES ce_age_range ( age_range_id );

ALTER TABLE ce_customers
    ADD CONSTRAINT customers_family_sizes_fk FOREIGN KEY ( family_id )
        REFERENCES ce_family_sizes ( family_id );

ALTER TABLE ce_customers
    ADD CONSTRAINT customers_marital_statuses_fk FOREIGN KEY ( marital_id )
        REFERENCES ce_marital_statuses ( marital_id );

ALTER TABLE ce_customers
    ADD CONSTRAINT customers_no_of_childs_fk FOREIGN KEY ( no_of_child_id )
        REFERENCES ce_no_of_childs ( no_of_child_id );
	
ALTER TABLE ce_product_brand
    ADD CONSTRAINT brand_type_fk FOREIGN KEY ( brand_type_id )
        REFERENCES ce_product_brand_types ( brand_type_id );

ALTER TABLE ce_products
    ADD CONSTRAINT products_product_brand_fk FOREIGN KEY ( brand_id )
        REFERENCES ce_product_brand ( brand_id );

ALTER TABLE ce_products
    ADD CONSTRAINT products_product_categories_fk FOREIGN KEY ( product_category_id )
        REFERENCES ce_product_categories ( product_category_id );

ALTER TABLE ce_sales
    ADD CONSTRAINT sales_coupons_fk FOREIGN KEY ( coupon_id )
        REFERENCES ce_coupons ( coupon_id );

ALTER TABLE ce_sales
    ADD CONSTRAINT sales_customers_fk FOREIGN KEY ( customer_id )
        REFERENCES ce_customers ( customer_id );

ALTER TABLE ce_sales
    ADD CONSTRAINT sales_dates_fk FOREIGN KEY ( employee_id )
        REFERENCES ce_employees ( employee_id );
		


ALTER TABLE ce_sales
    ADD CONSTRAINT sales_payment_types_fk FOREIGN KEY ( payment_type_id )
        REFERENCES ce_payment_types ( payment_type_id );

ALTER TABLE ce_sales
    ADD CONSTRAINT sales_products_fk FOREIGN KEY ( product_id )
        REFERENCES ce_products ( product_id );

ALTER TABLE ce_sales
    ADD CONSTRAINT sales_stores_fk FOREIGN KEY ( store_id )
        REFERENCES ce_stores ( store_id );

ALTER TABLE ce_states
    ADD CONSTRAINT state_country_fk FOREIGN KEY ( country_id )
        REFERENCES ce_countries ( country_id );

ALTER TABLE ce_stores
    ADD CONSTRAINT stores_cities_fk FOREIGN KEY ( city_id )
        REFERENCES ce_cities ( city_id );

ALTER TABLE ce_stores
    ADD CONSTRAINT stores_postcodes_fk FOREIGN KEY ( postcode_id )
        REFERENCES ce_postcodes ( postcode_id );