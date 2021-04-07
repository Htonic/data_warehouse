INSERT INTO ce_product_categories(product_category_id, product_category_desc)
SELECT products.NEXTVAL, product_category FROM
    (SELECT  product_category FROM bl_cl.cl_products
    GROUP BY product_category)a;
COMMIT;
