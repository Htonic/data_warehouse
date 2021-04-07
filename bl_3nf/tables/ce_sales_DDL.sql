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
    selling_price    NUMBER(18, 2) NOT NULL,
    other_discount   NUMBER(18, 2) NOT NULL,
    coupon_discount  NUMBER(18, 2) NOT NULL,
    cost_price       NUMBER(18, 2) NOT NULL,
    update_dt        DATE DEFAULT GETDATE() NOT NULL
);

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

