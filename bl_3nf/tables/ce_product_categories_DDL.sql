CREATE TABLE ce_product_categories (
    product_category_id    INTEGER NOT NULL,
    product_category_desc  NVARCHAR(40) NOT NULL,
    update_dt              DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_product_categories(product_category_id, product_category_desc) VALUES
(-1, 'N/A');
COMMIT;