INSERT INTO ce_product_brand(brand_id, brand, brand_type_id)
SELECT products.NEXTVAL, a.brand, cpbt.brand_type_id FROM
    (SELECT  brand, brand_type FROM bl_cl.cl_products
    GROUP BY brand_type, brand)a
JOIN ce_product_brand_types cpbt on cpbt.brand_type = a.brand_type;
COMMIT;
