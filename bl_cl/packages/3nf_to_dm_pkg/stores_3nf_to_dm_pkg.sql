CREATE OR REPLACE PACKAGE bl_cl.stores_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_stores;
    PROCEDURE insert_stores;
END stores_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.stores_3nf_to_dm_pkg
IS
    PROCEDURE insert_stores
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_stores';
    INSERT INTO bl_dm.dim_stores (store_surrogate_id, store_id, store_number, store_name,
    street_address, city_name, state_or_province, country_name, postcode, phone_number, 
    city_id, state_id, country_id, postcode_id, update_dt)
    SELECT bl_dm.SEQUENCE_STORES.nextval, cs.store_id, cs.store_number, cs.store_name,
    cs.street_address, ci.city_name, cst.state_name, cc.country_name, cp.postcode,
    cs.phone_number, ci.city_id, cst.state_id, cc.country_id, cp.postcode_id, cs.update_dt
    FROM BL_3NF.ce_stores cs
    JOIN BL_3NF.ce_cities ci ON ci.city_id = cs.city_id
    JOIN BL_3NF.ce_states cst ON cst.state_id = ci.state_id
    JOIN BL_3NF.ce_countries cc ON cc.country_id = cst.country_id
    JOIN BL_3NF.ce_postcodes cp ON cp.postcode_id = cs.postcode_id;

    log_event('Inserted ' || sql%Rowcount || ' rows into table dim_stores');

    END;
    
    PROCEDURE merge_stores
     IS
     
         TYPE store_type IS RECORD (
    store_id  INTEGER :=0,
    store_number        VARCHAR2(12) :='',
    store_name          VARCHAR2(60) :='',
    street_address      VARCHAR2(255) :='',
    city_name           VARCHAR2(85) :='',
    state_or_province   VARCHAR2(14):='',
    country_name        VARCHAR2(7) :='',
    postcode            VARCHAR2(12) :='',
    phone_number        VARCHAR2(20) :='',
    city_id             INTEGER :=0,
    state_id            INTEGER :=0,
    country_id          INTEGER :=0,
    postcode_id         INTEGER :=0,
	update_dt 			DATE := CURRENT_DATE
    );
    
     TYPE t_store_ids IS TABLE OF store_type
    INDEX BY PLS_INTEGER;
    
    CURSOR curs IS SELECT cs.store_id, cs.store_number, cs.store_name,
    cs.street_address, ci.city_name, cst.state_name, cc.country_name, cp.postcode,
    cs.phone_number, ci.city_id, cst.state_id, cc.country_id, cp.postcode_id, cs.update_dt
    FROM BL_3NF.ce_stores cs, BL_3NF.ce_cities ci, BL_3NF.ce_states cst,
    BL_3NF.ce_countries cc, BL_3NF.ce_postcodes cp
    WHERE
    ci.city_id = cs.city_id
    AND cst.state_id = ci.state_id
    AND cc.country_id = cst.country_id
    AND cp.postcode_id = cs.postcode_id;
    V_COUNT NUMBER := 0;
    l_store_ids t_store_ids;
	inserted_rows NUMBER := 0;
	
    BEGIN
     OPEN curs;
     FETCH curs BULK COLLECT INTO  l_store_ids;
     CLOSE curs;
     FORALL i IN l_store_ids.FIRST..l_store_ids.LAST
      UPDATE  bl_dm.dim_stores b 
      SET b.store_number = l_store_ids(i).store_number,       
    b.store_name = l_store_ids(i).store_name,
    b.street_address = l_store_ids(i).street_address,
    b.city_name = l_store_ids(i).city_name,
    b.state_or_province = l_store_ids(i).state_or_province,
    b.postcode = l_store_ids(i). postcode 
    WHERE b.store_id = l_store_ids(i).store_id;
    log_event('Updated ' || sql%Rowcount || ' rows into table dim_stores');
    COMMIT;
	
	FOR i IN l_store_ids.FIRST..l_store_ids.LAST LOOP
        SELECT 1 INTO V_COUNT FROM bl_dm.dim_stores b WHERE 
            b.store_id = l_store_ids(i).store_id;
        
        IF V_COUNT IS NULL OR V_COUNT = 0 THEN
			INSERT INTO bl_dm.dim_stores (store_surrogate_id, store_id, store_number, store_name,
				street_address, city_name, state_or_province, country_name, postcode, phone_number, 
				city_id, state_id, country_id, postcode_id, update_dt)	
			VALUES (bl_dm.SEQUENCE_STORES.nextval,
            l_store_ids(i).store_id, l_store_ids(i).store_number, l_store_ids(i).store_name,
				l_store_ids(i).street_address, l_store_ids(i).city_name, l_store_ids(i).state_or_province,
				l_store_ids(i).country_name, l_store_ids(i).postcode,
				l_store_ids(i).phone_number, l_store_ids(i).city_id,
				l_store_ids(i).state_id, l_store_ids(i).country_id,
				l_store_ids(i).postcode_id, l_store_ids(i).update_dt);
            inserted_rows := inserted_rows + 1;
        END IF;
    V_COUNT := 0;
    END LOOP;
	log_event('Inserted ' || inserted_rows || ' rows into table dim_stores');
    
	END;
END stores_3nf_to_dm_pkg;
/