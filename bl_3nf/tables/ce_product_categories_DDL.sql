CREATE TABLE ce_product_categories (
    product_category_id    INTEGER PRIMARY KEY,
    product_category_desc  VARCHAR2(40) NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_product_categories(product_category_id, product_category_desc) VALUES
(-1, 'N/A');
COMMIT;