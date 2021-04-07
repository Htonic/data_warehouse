CREATE TABLE ce_product_brand_types (
    brand_type_id INTEGER NOT NULL,
    brand_type  NVARCHAR(20),
    update_dt   DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_product_brand_types(brand_type_id, brand_type) VALUES
(-1, 'N/A');
COMMIT;