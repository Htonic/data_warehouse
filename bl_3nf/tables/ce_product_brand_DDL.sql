CREATE TABLE ce_product_brand (
    brand_id    INTEGER PRIMARY KEY,
    brand       INTEGER,
    brand_type_id INTEGER DEFAULT -1 NOT NULL,
    update_dt   DATE DEFAULT CURRENT_DATE NOT NULL
);

ALTER TABLE ce_product_brand
    ADD CONSTRAINT brand_type_fk FOREIGN KEY ( brand_type_id )
        REFERENCES ce_product_brand_types ( brand_type_id );

INSERT INTO ce_product_brand(brand_id, brand, brand_type_id) VALUES
(-1, -1, -1);
COMMIT;