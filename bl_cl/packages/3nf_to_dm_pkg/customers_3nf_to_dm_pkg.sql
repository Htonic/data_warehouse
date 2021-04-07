CREATE OR REPLACE PACKAGE bl_cl.customers_3nf_to_dm_pkg
   AUTHID DEFINER
IS
    PROCEDURE merge_customers;
    PROCEDURE insert_customers;
END customers_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.customers_3nf_to_dm_pkg
IS
    PROCEDURE insert_customers
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_customers';
    INSERT INTO bl_dm.dim_customers (customer_surrogate_id, customer_id,customer_natural_id, age_range,
    marital_status, rented, family_size, no_of_child, income_bracket, age_range_id, no_of_child_id,
    family_size_id, marital_status_id, update_dt)
    SELECT bl_dm.SEQUENCE_CUSTOMERS.nextval, cc.customer_id,cc.customer_natural_id,
    cag.age_range, cms.marital_status,
    cc.rented, cfs.family_size, cnof.no_of_child, 
    cc.income_bracket, cag.age_range_id, cnof.no_of_child_id,
    cfs.family_id, cms.marital_id, cc.update_dt
    FROM BL_3NF.ce_customers cc
    JOIN BL_3NF.ce_family_sizes cfs ON cfs.family_id = cc.family_id 
    JOIN BL_3NF.ce_no_of_childs cnof ON cnof.no_of_child_id = cc.no_of_child_id
    JOIN BL_3NF.ce_age_range cag ON cag.age_range_id = cc.age_range_id
    JOIN BL_3NF.ce_marital_statuses cms ON cms.marital_id = cc.marital_id;
    log_event('Inserted ' || sql%Rowcount || ' rows into table dim_customers');
    END;
    
    PROCEDURE merge_customers
    IS
	
    TYPE customer_type IS RECORD (
    customer_id               INTEGER := 0,
    customer_natural_id               INTEGER := 0,
    age_range                 VARCHAR2(8) := '',
    marital_status            VARCHAR2(40) := '',
    rented                    INTEGER := 0,
    family_size               VARCHAR2(4) := '',
    no_of_child               VARCHAR2(4) := '',
    income_bracket            INTEGER := 0,
    age_range_id              INTEGER := 0,
    no_of_child_id            INTEGER := 0,
    family_size_id            INTEGER := 0,
    marital_status_id         INTEGER := 0,
	update_dt DATE := '31.12.9999'
    );
    
    TYPE t_customer_list IS TABLE OF customer_type
    INDEX BY PLS_INTEGER;
    l_customer_list t_customer_list;
    
    TYPE var_cur_type IS REF CURSOR;
    curs var_cur_type;
    insert_rows number := 0;
    v_count number := 0;
    BEGIN
    OPEN curs FOR SELECT cc.customer_id,cc.customer_natural_id, cag.age_range, cms.marital_status,
    cc.rented, cfs.family_size, cnof.no_of_child, 
    cc.income_bracket, cag.age_range_id, cnof.no_of_child_id,
    cfs.family_id, cms.marital_id, cc.update_dt
    FROM BL_3NF.ce_customers cc, BL_3NF.ce_family_sizes cfs, 
    BL_3NF.ce_no_of_childs cnof, BL_3NF.ce_age_range cag, BL_3NF.ce_marital_statuses cms
    WHERE 
        cfs.family_id = cc.family_id 
        AND cnof.no_of_child_id = cc.no_of_child_id
        AND cag.age_range_id = cc.age_range_id
        AND cms.marital_id = cc.marital_id;
    
    FETCH curs BULK COLLECT INTO  l_customer_list;
    CLOSE curs;
    
	FORALL i IN l_customer_list.FIRST..l_customer_list.LAST
        UPDATE bl_dm.dim_customers bd
        SET
        bd.age_range = l_customer_list(i).age_range,
    bd.marital_status = l_customer_list(i).marital_status ,
    bd.rented = l_customer_list(i).rented,
    bd.family_size = l_customer_list(i).family_size,
    bd.no_of_child = l_customer_list(i).no_of_child,
    bd.income_bracket = l_customer_list(i).income_bracket,
    bd.update_dt = l_customer_list(i).update_dt
    WHERE l_customer_list(i).customer_id = bd.customer_id;
    log_event('Updated ' || sql%Rowcount || ' rows into table dim_customers');
    
    FOR i IN l_customer_list.FIRST..l_customer_list.LAST LOOP
		SELECT COUNT(*) INTO V_COUNT FROM bl_dm.dim_customers bd WHERE 
			bd.customer_id = l_customer_list(i).customer_id;
		IF V_COUNT IS NULL OR V_COUNT = 0 THEN
			INSERT INTO bl_dm.dim_customers (customer_surrogate_id, customer_id, customer_natural_id, age_range,
				marital_status, rented, family_size, no_of_child, income_bracket, age_range_id, no_of_child_id,
				family_size_id, marital_status_id, update_dt)
				VALUES (bl_dm.SEQUENCE_CUSTOMERS.nextval, l_customer_list(i).customer_id, l_customer_list(i).customer_natural_id
                , l_customer_list(i).age_range, l_customer_list(i).marital_status,
				l_customer_list(i).rented, l_customer_list(i).family_size, l_customer_list(i).no_of_child, 
				l_customer_list(i).income_bracket, l_customer_list(i).age_range_id, l_customer_list(i).no_of_child_id,
				l_customer_list(i).family_size_id, l_customer_list(i).marital_status_id, l_customer_list(i).update_dt);
			insert_rows := insert_rows + 1;
		END IF;
		V_COUNT := 0;
    END LOOP;
    IF insert_rows > 0 THEN
		log_event('Inserted ' || insert_rows || ' rows into table dim_customers');
    END IF;
    END;
END customers_3nf_to_dm_pkg;
/