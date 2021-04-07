CREATE OR REPLACE PACKAGE bl_cl.products_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_products;
    PROCEDURE merge_products;


END products_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.products_ext_to_src_pkg
IS
    PROCEDURE insert_products
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_products';
    
    INSERT INTO schema_src.src_products ( item_id, brand, brand_type, product_category)
        SELECT item_id, brand, brand_type, "category" FROM schema_src.external_item_data;
        
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_products');
    COMMIT;
    
    END; 
    
   
    
    PROCEDURE merge_products
    IS
    BEGIN
    
    INSERT INTO schema_src.src_products ( item_id, brand, brand_type, product_category)
    SELECT item_id, brand, brand_type, "category" FROM schema_src.external_item_data
    MINUS
    SELECT item_id, brand, brand_type, product_category FROM schema_src.src_products;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_products');
    COMMIT;
    
    END;
END products_ext_to_src_pkg;
/