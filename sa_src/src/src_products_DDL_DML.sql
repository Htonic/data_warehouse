CREATE TABLE src_products(
    item_id NVARCHAR(255),
    brand NVARCHAR(255),
    brand_type NVARCHAR(255),
    product_category NVARCHAR(255)
);

INSERT INTO src_products ( item_id, brand, brand_type, product_category)
SELECT item_id, brand, brand_type, "category" FROM external_item_data;
COMMIT;