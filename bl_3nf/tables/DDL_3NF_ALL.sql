CREATE TABLE ce_age_range (
    age_range_id  INTEGER NOT NULL,
    age_range     NVARCHAR(8) NOT NULL,
    update_dt     DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_cities (
    city_id    INTEGER NOT NULL,
    city_name  NVARCHAR(85) NOT NULL,
    state_id   INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_countries (
    country_id    INTEGER NOT NULL,
    country_name  NVARCHAR(7) NOT NULL,
    update_dt    DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_coupons(
    coupon_id            INTEGER NOT NULL,
    coupon_natural_id  INTEGER NOT NULL,
    coupon_desc          NVARCHAR(60) NOT NULL,
    issued_quantity   INTEGER NOT NULL,
    update_dt            DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_customers (
    customer_id            INTEGER NOT NULL,
    customer_natural_id  INTEGER NOT NULL,
    rented                 INTEGER NOT NULL,
    income_bracket         INTEGER NOT NULL,
    age_range_id           INTEGER DEFAULT -1 NOT NULL,
    marital_id             INTEGER DEFAULT -1 NOT NULL,
    family_id              INTEGER DEFAULT -1 NOT NULL,
    no_of_child_id         INTEGER DEFAULT -1 NOT NULL,
    update_dt              DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_employees (
    employee_id            INTEGER NOT NULL,
    employee_natural_id  INTEGER NOT NULL,
    employee_name          NVARCHAR(80) NOT NULL,
    employee_surname       NVARCHAR(80) NOT NULL,
    age                    INTEGER NOT NULL,
    email                  NVARCHAR(80) NOT NULL,
    phone                  NVARCHAR(80) NOT NULL,
    update_dt              DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_family_sizes (
    family_id    INTEGER NOT NULL,
    family_size  NVARCHAR(4) NOT NULL,
    update_dt    DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_marital_statuses (
    marital_id      INTEGER NOT NULL,
    marital_status  NVARCHAR(40) NOT NULL,
    update_dt       DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_no_of_childs (
    no_of_child_id  INTEGER NOT NULL,
    no_of_child     NVARCHAR(4) NOT NULL,
    update_dt       DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_payment_types (
    payment_type_id            INTEGER NOT NULL,
    payment_type_natural_id  INTEGER NOT NULL,
    payment_type_desc          NVARCHAR(20) NOT NULL,
    update_dt                  DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_postcodes (
    postcode_id  INTEGER NOT NULL,
    postcode     NVARCHAR(12) NOT NULL,
    update_dt    DATE DEFAULT GETDATE() NOT NULL
);

CREATE TABLE ce_product_brand (
    brand_id    INTEGER NOT NULL,
    brand       INTEGER NOT NULL,
    brand_type_id INTEGER DEFAULT -1 NOT NULL,
    update_dt   DATE DEFAULT GETDATE() NOT NULL
);

CREATE TABLE ce_product_brand_types (
    brand_type_id INTEGER NOT NULL,
    brand_type  NVARCHAR(20),
    update_dt   DATE DEFAULT GETDATE() NOT NULL
);

CREATE TABLE ce_product_categories (
    product_category_id    INTEGER NOT NULL,
    product_category_desc  NVARCHAR(40) NOT NULL,
    update_dt              DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_products (
    product_id            INTEGER NOT NULL,
    product_natural_id    INTEGER NOT NULL,
    brand_id              INTEGER DEFAULT -1 NOT NULL,
    product_category_id   INTEGER DEFAULT -1 NOT NULL,
    start_date            DATE DEFAULT GETDATE() NOT NULL,
    end_date              DATE DEFAULT '31-12-9999' NOT NULL,
    is_active           CHAR(1) NOT NULL,
    update_dt             DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_sales (
    sale_id          INTEGER NOT NULL,
	cl_sale_id       INTEGER NOT NULL,
    product_id       INTEGER DEFAULT -1 NOT NULL,
    customer_id      INTEGER DEFAULT -1 NOT NULL,
    sale_date        DATE NOT NULL,
    coupon_id        INTEGER DEFAULT -1 NOT NULL,
    employee_id      INTEGER DEFAULT -1 NOT NULL,
    payment_type_id  INTEGER DEFAULT -1 NOT NULL,
    store_id         INTEGER DEFAULT -1 NOT NULL,
    quantity         INTEGER NOT NULL,
    selling_price    NUMERIC(18, 2) NOT NULL,
    other_discount   NUMERIC(18, 2) NOT NULL,
    coupon_discount  NUMERIC(18, 2) NOT NULL,
    cost_price       NUMERIC(18, 2) NOT NULL,
    update_dt        DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_states (
    state_id    INTEGER NOT NULL,
    state_name  NVARCHAR(14) NOT NULL,
    country_id  INTEGER DEFAULT -1 NOT NULL,
    update_dt  DATE DEFAULT GETDATE() NOT NULL
);


CREATE TABLE ce_stores (
    store_id        INTEGER NOT NULL,
    store_number    NVARCHAR(14) NOT NULL,
    store_name      NVARCHAR(60) NOT NULL,
    street_address  NVARCHAR(255) NOT NULL,
    phone_number    NVARCHAR(20) NOT NULL,
    city_id         INTEGER DEFAULT -1 NOT NULL,
    postcode_id     INTEGER DEFAULT -1 NOT NULL,
    update_dt      DATE DEFAULT GETDATE() NOT NULL
);