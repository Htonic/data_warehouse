CREATE OR REPLACE PACKAGE bl_cl.stores_ext_to_src_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_stores;
    PROCEDURE merge_stores;
END stores_ext_to_src_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.stores_ext_to_src_pkg
IS

    PROCEDURE insert_stores
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE schema_src.src_stores';
    
    INSERT INTO schema_src.src_stores ( store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number)
    SELECT  store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number FROM schema_src.external_stores ;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_stores');
    COMMIT;
    
    END;

    PROCEDURE merge_stores
    IS
    BEGIN
     INSERT INTO schema_src.src_stores ( store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number)
    SELECT  store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number FROM schema_src.external_stores
    MINUS 
    SELECT  store_number, store_name, street_address, city,
    state_province, country, postcode, phone_number FROM schema_src.src_stores;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table src_stores');
    COMMIT;
    END;
END stores_ext_to_src_pkg;
/