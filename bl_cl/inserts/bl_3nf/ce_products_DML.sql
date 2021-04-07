INSERT INTO ce_products(product_id, product_surrogate_id, brand_id,
product_category_id,start_date, is_currrent)
SELECT products.NEXTVAL, item_id, pb.brand_id,
cpc.product_category_id,
TO_CHAR(SYSDATE, 'MM.DD.YYYY'), '1' FROM bl_cl.cl_products sss
JOIN ce_product_brand pb ON pb.brand = sss.brand
JOIN ce_product_categories cpc ON cpc.product_category_desc = sss.product_category
JOIN ce_product_brand_types cpbt ON cpbt.brand_type_id = pb.brand_type_id
WHERE cpbt.brand_type = sss.brand_type;
COMMIT;
