CREATE OR REPLACE PACKAGE bl_cl.products_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_products;
    PROCEDURE insert_product_brand;
    PROCEDURE insert_product_brand_types;
    PROCEDURE insert_product_categories;
    PROCEDURE merge_products;
    PROCEDURE merge_products_brand;
    PROCEDURE merge_products_brand_types;
    PROCEDURE merge_products_categories;

END products_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.products_cl_to_3nf_pkg
IS
    PROCEDURE insert_products
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_products';

    INSERT INTO bl_3nf.ce_products(product_id, product_natural_id, brand_id,
        product_category_id,start_date, end_date, is_active, update_dt) VALUES
        (-1,-1, -1, -1, '12.12.1970','12.12.1970', 'N', current_date);
    
    log_event('Inserted default value -1 for table bl_3nf.ce_products');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_products(product_id, product_natural_id, brand_id,
    product_category_id,start_date, is_active, update_dt)
    SELECT bl_3nf.products.NEXTVAL, item_id, pb.brand_id,
    cpc.product_category_id,
    TO_CHAR(SYSDATE, 'MM.DD.YYYY'), '1', insert_date FROM bl_cl.cl_products sss
    LEFT JOIN bl_3nf.ce_product_brand pb ON pb.brand = sss.brand
    LEFT JOIN bl_3nf.ce_product_categories cpc ON cpc.product_category_desc = sss.product_category
    LEFT JOIN bl_3nf.ce_product_brand_types cpbt ON cpbt.brand_type_id = pb.brand_type_id
    WHERE cpbt.brand_type = sss.brand_type;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_products');
    COMMIT;
    
    END; 
    
    PROCEDURE insert_product_brand
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_product_brand';
    
    INSERT INTO bl_3nf.ce_product_brand(brand_id, brand, brand_type_id, update_dt) VALUES
        (-1, -1, -1, current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_product_brand');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_product_brand(brand_id, brand, brand_type_id)
    SELECT bl_3nf.products.NEXTVAL, a.brand, cpbt.brand_type_id FROM
    (SELECT  brand, brand_type FROM bl_cl.cl_products
    GROUP BY brand_type, brand)a
    LEFT JOIN bl_3nf.ce_product_brand_types cpbt on cpbt.brand_type = a.brand_type;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_brand');
    COMMIT;
    
    END; 
    
    PROCEDURE insert_product_brand_types
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_product_brand_types';
    
    INSERT INTO bl_3nf.ce_product_brand_types(brand_type_id, brand_type, update_dt) VALUES
        (-1, 'N/A', current_Date);
    log_event('Inserted default value -1 for table bl_3nf.ce_product_brand_types');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_product_brand_types(brand_type_id, brand_type)
    SELECT bl_3nf.products.NEXTVAL, brand_type FROM
    (SELECT  brand_type FROM bl_cl.cl_products
    GROUP BY brand_type)a;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_brand_types');
    COMMIT;
    
    END; 
    
    PROCEDURE insert_product_categories
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_product_categories';
    
    INSERT INTO bl_3nf.ce_product_categories(product_category_id,
        product_category_desc, update_dt)
    VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_product_categories');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_product_categories(product_category_id, product_category_desc, update_dt)
    SELECT bl_3nf.products.NEXTVAL, product_category, current_date FROM
    (SELECT  product_category FROM bl_cl.cl_products
    GROUP BY product_category)a;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_categories');
    COMMIT;
    
    END; 
    
    PROCEDURE merge_products
    IS
    BEGIN
    merge_products_brand();
    merge_products_categories();
    
    
    MERGE INTO bl_3nf.ce_products P USING 
    (SELECT item_id, pb.brand_id,
        cpc.product_category_id,
        to_char(sysdate, 'MM.DD.YYYY') AS start_date, 'Y' AS is_active, insert_date FROM bl_cl.cl_products sss
        JOIN bl_3nf.ce_product_brand pb ON pb.brand = sss.brand
        JOIN bl_3nf.ce_product_categories cpc ON cpc.product_category_desc = sss.product_category
        JOIN bl_3nf.ce_product_brand_types cpbt ON cpbt.brand_type_id = pb.brand_type_id
        WHERE cpbt.brand_type = sss.brand_type
    )A 
    ON (P.product_natural_id = A.item_id)
    WHEN MATCHED THEN UPDATE SET 
    P.end_date = current_date,
    P.is_active = 'N'
    WHERE (P.brand_id <> A.brand_id OR 
    P.product_category_id <> A.product_category_id) AND A.insert_date > P.update_dt
    WHEN NOT MATCHED THEN
    INSERT (p.product_id, p.product_natural_id, p.brand_id,
    p.product_category_id,p.start_date, p.is_active, p.update_dt)
    VALUES (bl_3nf.products.NEXTVAL, a.item_id, a.brand_id, a.product_category_id,
    a.start_date, a.is_active, a.insert_date);
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_products');
    
    
    INSERT INTO bl_3nf.ce_products(product_id, product_natural_id, brand_id,
    product_category_id,start_date, is_active, update_dt)
    SELECT bl_3nf.products.NEXTVAL, item_id, pb.brand_id,
        cpc.product_category_id,
        to_char(sysdate, 'MM.DD.YYYY') AS start_date, 'Y' AS is_active, sss.insert_date FROM bl_cl.cl_products sss
        LEFT JOIN bl_3nf.ce_product_brand pb ON pb.brand = sss.brand
        LEFT JOIN bl_3nf.ce_product_categories cpc ON cpc.product_category_desc = sss.product_category
        LEFT JOIN bl_3nf.ce_product_brand_types cpbt ON cpbt.brand_type_id = pb.brand_type_id
        LEFT JOIN bl_3nf.ce_products cp ON cp.product_natural_id = sss.item_id
        WHERE cpbt.brand_type = sss.brand_type AND
        sss.insert_date > cp.update_dt AND (pb.brand_id <> cp.brand_id OR 
                    cpc.product_category_id <> cp.product_category_id);
    log_event('Inserted ' || SQL%ROWCOUNT || ' new rows into table bl_3nf.ce_products');
    COMMIT;
    
    END;
    
    PROCEDURE merge_products_brand
    IS
    BEGIN
    merge_products_brand_types();
  
    MERGE INTO bl_3nf.ce_product_brand pb
    USING (SELECT A.brand, cpbt.brand_type_id FROM
            (SELECT  brand, brand_type FROM bl_cl.cl_products
            GROUP BY brand_type, brand)A
            JOIN bl_3nf.ce_product_brand_types cpbt ON cpbt.brand_type = A.brand_type
            )
    br ON (pb.brand = br.brand)
    WHEN MATCHED THEN UPDATE SET 
    pb.brand_type_id = br.brand_type_id,
    pb.update_dt = current_date
    WHEN NOT MATCHED THEN
    INSERT (pb.brand_id, pb.brand, pb.brand_type_id, pb.update_dt)
    VALUES (bl_3nf.products.NEXTVAL, br.brand, br.brand_type_id, current_date );

    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_brand');
    COMMIT;

    END; 
    
    PROCEDURE merge_products_brand_types
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_product_brand_types bt
    USING (SELECT  brand_type FROM bl_cl.cl_products
    GROUP BY brand_type)a ON (lower(a.brand_type) = lower(bt.brand_type))
    WHEN NOT MATCHED THEN 
    INSERT (bt.brand_type_id, bt.brand_type, bt.update_dt)
    VALUES (bl_3nf.products.NEXTVAL, a.brand_type, CURRENT_DATE);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_brand_types');
    COMMIT;
    
    END; 
    
    PROCEDURE merge_products_categories
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_product_categories pc
    USING (SELECT  product_category FROM bl_cl.cl_products
    GROUP BY product_category)a ON (lower(a.product_category) = lower(pc.product_category_desc))
    WHEN NOT MATCHED THEN
    INSERT(pc.product_category_id, pc.product_category_desc, pc.update_dt)
    VALUES(bl_3nf.products.NEXTVAL, a.product_category, CURRENT_DATE);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_product_categories');
    COMMIT;
    
    END; 
END products_cl_to_3nf_pkg;
/