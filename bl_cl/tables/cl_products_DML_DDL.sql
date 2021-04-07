CREATE TABLE cl_products(
    item_id INT,
    brand INT,
    brand_type NVARCHAR(20),
    product_category NVARCHAR(40),
    insert_date DATE DEFAULT GETDATE()
);

INSERT INTO cl_products ( item_id, brand, brand_type, product_category)
SELECT CAST(TRIM(item_id) AS INT),  CAST(TRIM(brand) AS INT), TRIM(brand_type),
 TRIM(product_category) FROM schema_src.src_products;
COMMIT;
