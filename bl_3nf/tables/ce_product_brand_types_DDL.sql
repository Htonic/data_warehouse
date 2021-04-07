CREATE TABLE ce_product_brand_types (
    brand_type_id INTEGER PRIMARY KEY,
    brand_type  VARCHAR2(20),
    update_dt   DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_product_brand_types(brand_type_id, brand_type) VALUES
(-1, 'N/A');
COMMIT;