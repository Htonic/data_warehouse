CREATE TABLE src_products(
    item_id VARCHAR2(255),
    brand VARCHAR2(255),
    brand_type VARCHAR2(255),
    product_category VARCHAR2(255)
);

INSERT INTO src_products ( item_id, brand, brand_type, product_category)
SELECT item_id, brand, brand_type, "category" FROM external_item_data;
COMMIT;