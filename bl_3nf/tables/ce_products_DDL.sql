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

ALTER TABLE ce_products
    ADD CONSTRAINT products_product_brand_fk FOREIGN KEY ( brand_id )
        REFERENCES ce_product_brand ( brand_id );

ALTER TABLE ce_products
    ADD CONSTRAINT products_product_categories_fk FOREIGN KEY ( product_category_id )
        REFERENCES ce_product_categories ( product_category_id );

INSERT INTO ce_products(product_id, product_natural_id, brand_id,
product_category_id,start_date, end_date, is_active) VALUES
(-1,-1, -1, -1, '31-12-9999','31-12-9999', '0');
COMMIT;