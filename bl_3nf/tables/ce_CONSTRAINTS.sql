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