CREATE OR REPLACE PACKAGE bl_cl.stores_src_to_cl_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_stores;
  --  PROCEDURE merge_stores;

END stores_src_to_cl_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.stores_src_to_cl_pkg
IS

    PROCEDURE insert_stores
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_cl.cl_stores';
    
    INSERT INTO cl_stores ( store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number)
    SELECT trim(store_number), trim(store_name) as stname, trim(street_address), trim(city),
    trim(state_province), trim(country), CASE WHEN postcode IS NULL THEN NULL ELSE trim(postcode) END AS postcode,
    CASE WHEN phone_number IS NULL THEN NULL ELSE TRIM(phone_number) END AS phone_number
    FROM schema_src.src_stores;
    log_event('Inserted '|| SQL%ROWCOUNT || 'rows into table bl_cl.cl_stores');
    COMMIT;
    
    END;
    
    /*
    PROCEDURE merge_stores
    IS
    BEGIN
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_cl.cl_stores');
    COMMIT;
    END;*/
    
END stores_src_to_cl_pkg;
/