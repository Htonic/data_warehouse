INSERT INTO ce_product_brand_types(brand_type_id, brand_type)
SELECT products.NEXTVAL, brand_type FROM
    (SELECT  brand_type FROM bl_cl.cl_products
    GROUP BY brand_type)a;
COMMIT;
