INSERT INTO bl_dm.dim_products (product_id, product_surrogate_id, brand,
    brand_type, brand_id, brand_type_id,
    product_category_desc, product_category_id,
    start_date, end_date, is_currrent)
SELECT SEQUENCE_PRODUCTS.nextval, cp.product_id, cpb.brand,
    cpbt.brand_type, cpb.brand_id, cpbt.brand_type_id,
    cpc.product_category_desc, cpc.product_category_id,
    cp.start_date, cp.end_date, cp.is_currrent
FROM BL_3NF.ce_products cp 
JOIN BL_3NF.ce_product_brand cpb ON cpb.brand_id = cp.brand_id
JOIN BL_3NF.ce_product_brand_types cpbt 
    ON cpbt.brand_type_id = cpb.brand_type_id
JOIN BL_3NF.ce_product_categories cpc 
    ON cpc.product_category_id = cp.product_category_id;
COMMIT;
