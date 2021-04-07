GRANT REFERENCES ON bl_dm.dim_coupons  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_payment_types  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_stores  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_customers  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_dates  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_products  TO bl_cl;
GRANT REFERENCES ON bl_dm.dim_employees  TO bl_cl;

CREATE TABLE tmp_fct_sales (
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
);



ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_coupons_fk FOREIGN KEY ( coupon_surrogate_id )
        REFERENCES bl_dm.dim_coupons ( coupon_surrogate_id );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_customers_fk FOREIGN KEY ( customer_surrogate_id )
        REFERENCES bl_dm.dim_customers ( customer_surrogate_id );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_dates_fk FOREIGN KEY ( employee_surrogate_id )
        REFERENCES bl_dm.dim_employees ( employee_surrogate_id );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_dates_fkv1 FOREIGN KEY ( sale_date )
        REFERENCES bl_dm.dim_dates ( sale_date );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_payment_types_fk FOREIGN KEY ( payment_type_surrogate_id )
        REFERENCES bl_dm.dim_payment_types ( payment_type_surrogate_id );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_products_fk FOREIGN KEY ( product_surrogate_id )
        REFERENCES bl_dm.dim_products ( product_surrogate_id );

ALTER TABLE tmp_fct_sales
    ADD CONSTRAINT tmp_sales_stores_fk FOREIGN KEY ( store_surrogate_id )
        REFERENCES bl_dm.dim_stores ( store_surrogate_id );  