CREATE OR REPLACE PACKAGE bl_cl.stores_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_stores;
    PROCEDURE insert_cities;
    PROCEDURE insert_states;
    PROCEDURE insert_countries;
    PROCEDURE insert_postcodes;
    PROCEDURE merge_stores;
    PROCEDURE merge_cities;
    PROCEDURE merge_states;
    PROCEDURE merge_countries;
    PROCEDURE merge_postcodes;
END stores_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.stores_cl_to_3nf_pkg
IS

    PROCEDURE insert_stores
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_stores';
    
    INSERT INTO bl_3nf.ce_stores(store_id, store_number,
        store_name,street_address,
        phone_number,city_id,postcode_id, update_dt)
    VALUES
        (-1, 'N/A', 'N/A', 'N/A', 'N/A', -1, -1, sysdate);
        
    log_event('Inserted default value -1 for table bl_3nf.ce_stores');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_stores(store_id, store_number,
    store_name,street_address,
    phone_number,city_id,postcode_id, update_dt)
    SELECT bl_3nf.stores.NEXTVAL, 
    CASE WHEN ss.store_number IS NULL THEN 'N/A' ELSE ss.store_number END AS store_number,
    CASE WHEN ss.store_name IS NULL THEN 'N/A' ELSE ss.store_name END AS store_name,
    CASE WHEN ss.street_address IS NULL THEN 'N/A' ELSE ss.street_address END AS street_address,
    CASE WHEN ss.phone_number IS NULL THEN 'N/A' ELSE ss.phone_number END AS phone_number,
    CASE WHEN ci.city_id IS NULL THEN -1 ELSE ci.city_id END AS city_id,
    CASE WHEN cp.postcode_id IS NULL THEN -1 ELSE cp.postcode_id END AS postcode_id,
    current_date FROM bl_cl.cl_stores ss
        LEFT JOIN bl_3nf.ce_postcodes cp ON ss.postcode = cp.postcode
        LEFT JOIN bl_3nf.ce_cities ci ON ci.city_name = ss.city
        LEFT JOIN bl_3nf.ce_states cs ON cs.state_id = ci.state_id
        LEFT JOIN bl_3nf.ce_countries ccount ON ccount.country_id = cs.country_id
        WHERE cs.state_name = ss.state_province
        AND ccount.country_name = ss.country;
        
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_stores');
    COMMIT;
    END;
    
    PROCEDURE insert_cities
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_cities';
    
    INSERT INTO bl_3nf.ce_cities(city_id, city_name, state_id, update_dt) VALUES
    (-1, 'N/A', -1, current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_cities');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_cities(city_id, city_name, state_id, update_dt)
        SELECT bl_3nf.sequence_common_2.NEXTVAL, 
        city,
        CASE WHEN cs.state_id IS NULL THEN -1 ELSE cs.state_id END AS state_id,
        current_date  FROM
        (SELECT  city, state_province FROM bl_cl.cl_stores
        GROUP BY city, state_province)a
        LEFT JOIN bl_3nf.ce_states cs ON cs.state_name = a.state_province
        WHERE city IS NOT NULL;
    
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_cities');
    COMMIT;
    END;
    
    PROCEDURE insert_states
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_states';
    
    INSERT INTO bl_3nf.ce_states(state_id, state_name, country_id, update_dt) VALUES
    (-1, 'N/A', -1, current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_states');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_states(state_id, state_name, country_id, update_dt)
        SELECT bl_3nf.sequence_common_2.NEXTVAL, state_province, 
        CASE WHEN cc.country_id IS NULL THEN -1 ELSE cc.country_id END AS country_id,
        current_date FROM
        (SELECT  state_province, country FROM bl_cl.cl_stores
        GROUP BY state_province, country)a
        LEFT JOIN bl_3nf.ce_countries cc ON cc.country_name = A.country
        WHERE state_province IS NOT NULL;
        
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_states');
    COMMIT;
    END;
    
    PROCEDURE insert_countries
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_countries';
    
    INSERT INTO bl_3nf.ce_countries(country_id, country_name, update_dt) VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_countries');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_countries(country_id, country_name, update_dt)
        SELECT bl_3nf.sequence_common_2.NEXTVAL, country, current_date FROM
        (SELECT  country FROM bl_cl.cl_stores
        GROUP BY country)a
        WHERE country IS NOT NULL;
        
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_countries');
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Cannot insert in table where primary key used in another table.
            Please, disable foreign keys first.');
        log_event('procedure insert_countries failed');
        ROLLBACK;
    END;
    
    PROCEDURE insert_postcodes
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_postcodes';
    
    INSERT INTO bl_3nf.ce_postcodes( postcode_id, postcode, update_dt) VALUES
    (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_postcodes');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_postcodes( postcode_id, postcode, update_dt )
        SELECT bl_3nf.sequence_common_2.NEXTVAL, postcode, current_date FROM
        (SELECT  postcode FROM bl_cl.cl_stores
        GROUP BY postcode)a
        WHERE postcode IS NOT NULL;
        
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_postcodes');
    COMMIT;
    END;
    
    PROCEDURE merge_stores
    IS
    BEGIN
    
    merge_postcodes();
    merge_cities();
    
    MERGE INTO BL_3NF.ce_stores bf
    USING (SELECT ss.store_number, ss.store_name,
            ss.street_address, ss.phone_number, 
            ci.city_id, cp.postcode_id FROM bl_cl.cl_stores ss
            JOIN bl_3nf.ce_postcodes cp ON ss.postcode = cp.postcode
            JOIN bl_3nf.ce_cities ci ON ci.city_name = ss.city
            JOIN bl_3nf.ce_states cs ON cs.state_id = ci.state_id
            JOIN bl_3nf.ce_countries ccount ON ccount.country_id = cs.country_id
            WHERE cs.state_name = ss.state_province
            AND ccount.country_name = ss.country
    )bc ON (bf.store_number = bc.store_number)
    WHEN MATCHED THEN
    UPDATE SET
        bf.store_name = bc.store_name,
        bf.street_address = bc.street_address,
        bf.phone_number = bc.phone_number,
        bf.city_id = bc.city_id,
        bf.postcode_id = bc.postcode_id,
        bf.update_dt = CURRENT_DATE
    WHEN NOT MATCHED THEN
    INSERT(bf.store_id, bf.store_number,
    bf.store_name,bf.street_address,
    bf.phone_number,bf.city_id,bf.postcode_id, bf.update_dt)
    VALUES(bl_3nf.stores.NEXTVAL, bc.store_number, bc.store_name,
    bc.street_address, bc.phone_number, bc.city_id, bc.postcode_id, current_date);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_stores');
    COMMIT;
    END;
    
    PROCEDURE merge_cities
    IS
    BEGIN
    
    merge_states();
    
    MERGE INTO BL_3NF.ce_cities bf
    USING (SELECT city, cs.state_id FROM
            (SELECT  city, state_province FROM bl_cl.cl_stores
            GROUP BY city, state_province)a
            JOIN bl_3nf.ce_states cs ON cs.state_name = a.state_province
        )bc ON (lower(bc.city) = lower(bf.city_name))
    WHEN MATCHED THEN
    UPDATE SET
        bf.state_id = bc.state_id,
        bf.update_dt = CURRENT_DATE
    WHEN NOT MATCHED THEN
    INSERT(bf.city_id, bf.city_name, bf.state_id, bf.update_dt)
    VALUES(bl_3nf.sequence_common_2.NEXTVAL, bc.city, bc.state_id, current_date);    
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_cities');
    COMMIT;
    END;
    
    PROCEDURE merge_states
    IS
    BEGIN
    
    merge_countries();
    
    MERGE INTO BL_3NF.ce_states bf
    USING (SELECT state_province, cc.country_id FROM
            (SELECT  state_province, country FROM bl_cl.cl_stores
            GROUP BY state_province, country)a
            JOIN bl_3nf.ce_countries cc ON cc.country_name = a.country
            )bc ON (bc.state_province = bf.state_name)
    WHEN MATCHED THEN
    UPDATE SET
        bf.country_id = bc.country_id,
        bf.update_dt = CURRENT_DATE
    WHEN NOT MATCHED THEN
    INSERT(bf.state_id, bf.state_name, bf.country_id, bf.update_dt)
    VALUES(bl_3nf.sequence_common_2.NEXTVAL, bc.state_province, bc.country_id,
        current_date);    
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_states');
    COMMIT;
    
    END;
    
    PROCEDURE merge_countries
    IS
    BEGIN
    
    MERGE INTO BL_3NF.ce_countries bf  
    USING (SELECT country FROM bl_cl.cl_stores
    GROUP BY country)bc ON ( bc.country = bf.country_name)
    WHEN NOT MATCHED THEN
    INSERT(bf.country_id, bf.country_name, bf.update_dt)
    VALUES(bl_3nf.sequence_common_2.NEXTVAL, bc.country, current_date);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_countries');
    COMMIT;
    END;
    
    PROCEDURE merge_postcodes
    IS
    BEGIN
    
    MERGE INTO BL_3NF.ce_postcodes bf
    USING (SELECT  postcode FROM bl_cl.cl_stores
    GROUP BY postcode)bc ON (lower(bc.postcode) = lower(bf.postcode))
    WHEN NOT MATCHED THEN
    INSERT(bf.postcode_id, bf.postcode, bf.update_dt)
    VALUES(BL_3NF.sequence_common_2.NEXTVAL, bc.postcode, current_date);
    
    log_event('Merged ' || SQL%ROWCOUNT || ' rows into table bl_3nf.ce_postcodes');
    COMMIT;
    END;

END stores_cl_to_3nf_pkg;
/