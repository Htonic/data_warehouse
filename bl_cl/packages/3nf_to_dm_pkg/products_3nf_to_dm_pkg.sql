CREATE OR REPLACE PACKAGE bl_cl.products_3nf_to_dm_pkg
   AUTHID DEFINER
IS
   
    
    PROCEDURE merge_products;
    PROCEDURE insert_products;
END products_3nf_to_dm_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.products_3nf_to_dm_pkg
IS
    PROCEDURE insert_products
    IS
    BEGIN
	EXECUTE IMMEDIATE 'TRUNCATE TABLE BL_DM.DIM_PRODUCTS';
    INSERT INTO bl_dm.dim_products (product_surrogate_id, product_id,product_natural_id, brand,
    brand_type, brand_id, brand_type_id,
    product_category_desc, product_category_id,
    start_date, end_date, is_active, update_dt)
    SELECT bl_dm.SEQUENCE_PRODUCTS.nextval, cp.product_id,cp.product_natural_id,
    cpb.brand, cpbt.brand_type, cpb.brand_id, cpbt.brand_type_id,
    cpc.product_category_desc, cpc.product_category_id,
    cp.start_date, cp.end_date, cp.is_active, cp.update_dt
    FROM BL_3NF.ce_products cp 
    JOIN BL_3NF.ce_product_brand cpb ON cpb.brand_id = cp.brand_id
    JOIN BL_3NF.ce_product_brand_types cpbt 
    ON cpbt.brand_type_id = cpb.brand_type_id
    JOIN BL_3NF.ce_product_categories cpc 
    ON cpc.product_category_id = cp.product_category_id;
	
    log_event('Inserted ' || SQL%ROWCOUNT || ' rows updated in table bl_dm.dim_products');
	
    END;
    
	
    PROCEDURE merge_products
    IS
    CURSOR cur1 IS SELECT cp.product_id, cp.product_natural_id, cpb.brand,
    cpbt.brand_type, cpb.brand_id, cpbt.brand_type_id,
    cpc.product_category_desc, cpc.product_category_id,
    cp.start_date, cp.end_date, cp.is_active, cp.update_dt
    FROM bl_3nf.ce_products cp 
    JOIN bl_3nf.ce_product_brand cpb ON cpb.brand_id = cp.brand_id
    JOIN bl_3nf.ce_product_brand_types cpbt 
    ON cpbt.brand_type_id = cpb.brand_type_id
    JOIN bl_3nf.ce_product_categories cpc 
    ON cpc.product_category_id = cp.product_category_id;  
    updated_rows number := 0;
    inserted_rows number := 0;
    v_count number := 0;
    flag_update VARCHAR2(1) := 'F';
    TYPE prod_type IS RECORD (
        PRODUCT_ID INT :=0,  
        PRODUCT_NATURAL_ID INT :=0, 
        BRAND INT :=0, 
        BRAND_TYPE VARCHAR2(20) := '12.12.2020', 
        BRAND_ID INT :=0, 
        BRAND_TYPE_ID INT :=0, 
        PRODUCT_CATEGORY_DESC VARCHAR2(40) := '12.12.2020', 
        PRODUCT_CATEGORY_ID INT :=0, 
        START_DATE DATE := CURRENT_DATE, 
        END_DATE DATE := CURRENT_DATE, 
        IS_ACTIVE VARCHAR2(1) := 'T',
		UPDATE_DT DATE := CURRENT_DATE
    );
    TYPE t_product_list IS TABLE OF prod_type
    INDEX BY PLS_INTEGER;
    l_product_list t_product_list;
 
    BEGIN
    
    OPEN cur1;
    FETCH cur1 BULK COLLECT INTO l_product_list;
    CLOSE cur1;
    FOR i in l_product_list.FIRST..l_product_list.LAST LOOP
        SELECT 1, 
            CASE WHEN (b.is_active != l_product_list(i).is_active OR b.end_date != l_product_list(i).end_date 
				OR b.update_dt != l_product_list(i).update_dt)
			AND b.start_date = l_product_list(i).start_date
            THEN 'T' END AS flag_update
            INTO V_COUNT, flag_update FROM bl_dm.dim_products b WHERE 
                    b.PRODUCT_ID = l_product_list(i).PRODUCT_ID;
        
        IF V_COUNT > 0 AND flag_update = 'T' THEN
            updated_rows := updated_rows + 1 ;
            UPDATE bl_dm.dim_products dp
            SET         dp.end_date = l_product_list(i).end_date,
            dp.is_active = l_product_list(i).is_active,
            dp.update_dt = l_product_list(i).update_dt
            WHERE dp.PRODUCT_ID = l_product_list(i).PRODUCT_ID;
            
        ELSIF V_COUNT IS NULL OR V_COUNT = 0 THEN
        
            INSERT INTO bl_dm.dim_products (product_surrogate_id, product_id,product_natural_id,
            brand, brand_type, brand_id, brand_type_id,
            product_category_desc, product_category_id,
            start_date, end_date, is_active, update_dt)
            VALUES (bl_dm.SEQUENCE_PRODUCTS.nextval, l_product_list(i).product_id,l_product_list(i).product_natural_id,
            l_product_list(i).brand, l_product_list(i).brand_type, l_product_list(i).brand_id, l_product_list(i).brand_type_id,
            l_product_list(i).product_category_desc, l_product_list(i).product_category_id,
            l_product_list(i).start_date, l_product_list(i).end_date, l_product_list(i).is_active, l_product_list(i).update_dt);
            inserted_rows := inserted_rows + 1;
        END IF;
    V_COUNT := 0;
    flag_update := 'F';
    END LOOP;
    IF inserted_rows > 0 THEN
    log_event(inserted_rows || ' rows inserted into table bl_dm.dim_products');
    END IF;
    IF updated_rows >0 THEN
    log_event(updated_rows || ' rows updated in table bl_dm.dim_products');
    END IF;
    END;
END products_3nf_to_dm_pkg;
/