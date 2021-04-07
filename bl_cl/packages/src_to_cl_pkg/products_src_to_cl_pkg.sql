CREATE OR REPLACE PACKAGE bl_cl.products_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_products;
    --PROCEDURE merge_products;


END products_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.products_src_to_cl_pkg
IS
    PROCEDURE insert_products
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_products';
    
    INSERT INTO cl_products ( item_id, brand, brand_type, product_category)
    SELECT CAST(TRIM(item_id) AS INT),  CAST(TRIM(brand) AS INT), TRIM(brand_type),
     TRIM(product_category) FROM schema_src.src_products;
     
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_cl.cl_products');
    COMMIT;
    
    END; 

    
    /*PROCEDURE merge_products
    IS
    BEGIN
  
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_cl.cl_products');
    COMMIT;
    
    END;*/
END products_src_to_cl_pkg;
/