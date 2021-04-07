CREATE OR REPLACE PACKAGE bl_cl.customers_cl_to_3nf_pkg
   AUTHID DEFINER
IS
    PROCEDURE insert_customers;
    PROCEDURE insert_age_range;
    PROCEDURE insert_marital_statuses;
    PROCEDURE insert_family_sizes;
    PROCEDURE insert_no_of_childs;
    PROCEDURE merge_customers;
    PROCEDURE merge_age_range;
    PROCEDURE merge_marital_statuses;
    PROCEDURE merge_family_sizes;
    PROCEDURE merge_no_of_childs;

END customers_cl_to_3nf_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.customers_cl_to_3nf_pkg
IS

    PROCEDURE insert_customers
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_customers';
    
    INSERT INTO bl_3nf.ce_customers(customer_id, customer_natural_id, rented, income_bracket,
        age_range_id, marital_id, family_id, no_of_child_id, update_dt) 
    VALUES
        (-1, -1, 0, 0,
        -1, -1, -1, -1, current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_customers');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_customers(customer_id, customer_natural_id, rented, income_bracket,
    age_range_id, marital_id, family_id, no_of_child_id, update_dt)
    SELECT bl_3nf.customers.NEXTVAL, customer_id,
    CASE WHEN rented IS NULL THEN 0 ELSE rented END AS rented,
    CASE WHEN income_bracket IS NULL THEN 0 ELSE income_bracket END AS income_bracket,
    CASE WHEN car.age_range_id IS NULL THEN -1 ELSE car.age_range_id END AS age_range_id,
    CASE WHEN cms.marital_id IS NULL THEN -1 ELSE cms.marital_id END AS marital_id,
    CASE WHEN cfs.family_id IS NULL THEN -1 ELSE cfs.family_id END AS family_id,
    CASE WHEN cch.no_of_child_id IS NULL THEN -1 ELSE cch.no_of_child_id END AS no_of_child_id,
    current_date
    FROM bl_cl.cl_customers sr
    LEFT JOIN bl_3nf.ce_age_range car ON car.age_range = sr.age_range
    LEFT JOIN bl_3nf.ce_family_sizes cfs ON cfs.family_size = sr.family_size
    LEFT JOIN bl_3nf.ce_marital_statuses  cms ON cms.marital_status = sr.marital_status 
    LEFT JOIN bl_3nf.ce_no_of_childs  cch ON cch.no_of_child = sr.no_of_children;

    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_customers');
    COMMIT;
    
    END;
    
    PROCEDURE insert_age_range
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_age_range';
    
    INSERT INTO bl_3nf.ce_age_range(age_range_id, age_range, update_dt) VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_age_range');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_age_range(age_range_id, age_range, update_dt)
    SELECT bl_3nf.sequence_common_1.NEXTVAL, age_range, current_date FROM
    (SELECT  age_range FROM bl_cl.cl_customers
    GROUP BY age_range)a
    WHERE age_range IS NOT NULL;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_age_range');
    COMMIT;
    END;
    
    PROCEDURE insert_marital_statuses
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_marital_statuses';
    
    INSERT INTO bl_3nf.ce_marital_statuses(marital_id, marital_status, update_dt) 
    VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_marital_statuses');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_marital_statuses(marital_id, marital_status, update_dt)
    SELECT bl_3nf.sequence_common_1.NEXTVAL, marital_status, current_date  FROM
    (SELECT  marital_status FROM bl_cl.cl_customers
    GROUP BY marital_status)a
    WHERE marital_status IS NOT NULL;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_marital_statuses');
    COMMIT;
    
    END;
    
    PROCEDURE insert_family_sizes
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_family_sizes';
    
    INSERT INTO bl_3nf.ce_family_sizes(family_id, family_size, update_dt) 
    VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_family_sizes');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_family_sizes(family_id, family_size, update_dt)
    SELECT bl_3nf.sequence_common_1.NEXTVAL, family_size, current_date  FROM
    (SELECT  family_size FROM bl_cl.cl_customers
    GROUP BY family_size)a
    WHERE family_size IS NOT NULL;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_family_sizes');
    COMMIT;
    
    END;
    
    PROCEDURE insert_no_of_childs
    IS
    BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_no_of_childs';
    
    INSERT INTO bl_3nf.ce_no_of_childs(no_of_child_id, no_of_child, update_dt)
    VALUES
        (-1, 'N/A', current_date);
    log_event('Inserted default value -1 for table bl_3nf.ce_no_of_childs');
    COMMIT;
    
    INSERT INTO bl_3nf.ce_no_of_childs(no_of_child_id, no_of_child, update_dt)
    SELECT bl_3nf.sequence_common_1.NEXTVAL, no_of_children, current_date  FROM
    (SELECT  no_of_children FROM bl_cl.cl_customers
    GROUP BY no_of_children)a
    WHERE no_of_children IS NOT NULL;
    
    log_event('Inserted ' || sql%Rowcount || ' rows into table ce_no_of_childs');
    COMMIT;
    
    END;
    
    PROCEDURE merge_customers
    IS
    BEGIN
    
    merge_age_range();
    merge_marital_statuses();
    merge_family_sizes();
    merge_no_of_childs();
    
    MERGE INTO bl_3nf.ce_customers C
    USING ( SELECT customer_id,rented, income_bracket,
        car.age_range_id, cms.marital_id, cfs.family_id,
        cch.no_of_child_id
        FROM bl_cl.cl_customers sr
        JOIN bl_3nf.ce_age_range car ON car.age_range = sr.age_range
        JOIN bl_3nf.ce_family_sizes cfs ON cfs.family_size = sr.family_size
        JOIN bl_3nf.ce_marital_statuses  cms ON cms.marital_status = sr.marital_status 
        JOIN bl_3nf.ce_no_of_childs  cch ON cch.no_of_child = sr.no_of_children
    )A ON (A.customer_id = C.customer_natural_id)
    WHEN MATCHED THEN UPDATE SET 
    C.rented = A.rented,
    C.income_bracket = A.income_bracket,
    C.age_range_id = A.age_range_id,
    C.marital_id = A.marital_id,
    C.family_id = A.family_id,
    C.no_of_child_id =  A.no_of_child_id,
    C.update_dt = current_date
    WHEN NOT MATCHED THEN
    INSERT (C.customer_id, C.customer_natural_id, C.rented, C.income_bracket,
    C.age_range_id, C.marital_id, C.family_id, C.no_of_child_id, C.update_dt)
    VALUES (bl_3nf.customers.NEXTVAL,A.customer_id, A.rented, A.income_bracket,
    A.age_range_id, A.marital_id, A.family_id, A.no_of_child_id, current_date);


    log_event('Merged ' || sql%Rowcount || ' rows into table ce_customers');
    COMMIT;
    END;
    
    PROCEDURE merge_age_range
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_age_range R
    USING (SELECT  age_range FROM bl_cl.cl_customers
    GROUP BY age_range)A ON (LOWER(A.age_range) = LOWER(R.age_range))
    WHEN NOT MATCHED THEN
    INSERT (R.age_range_id, R.age_range, R.update_dt)
    VALUES (bl_3nf.sequence_common_1.NEXTVAL, A.age_range, current_date);
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_age_range');
    COMMIT;
    END;
    
    PROCEDURE merge_marital_statuses
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_marital_statuses M
    USING (SELECT  marital_status FROM bl_cl.cl_customers
    GROUP BY marital_status)A ON (LOWER(A.marital_status) = LOWER(M.marital_status))
    WHEN NOT MATCHED THEN
    INSERT (M.marital_id, M.marital_status, M.update_dt)
    VALUES (bl_3nf.sequence_common_1.NEXTVAL,A.marital_status ,current_date );
    
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_marital_statuses');
    COMMIT;
    
    END;
    
    PROCEDURE merge_family_sizes
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_family_sizes F
    USING (SELECT  family_size FROM bl_cl.cl_customers
    GROUP BY family_size)A ON (LOWER(A.family_size) = LOWER(F.family_size))
    WHEN NOT MATCHED THEN
    INSERT (F.family_id, F.family_size, F.update_dt)
    VALUES (bl_3nf.sequence_common_1.NEXTVAL ,A.family_size ,current_date);
    
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_family_sizes');
    COMMIT;
    
    END;
    
    PROCEDURE merge_no_of_childs
    IS
    BEGIN
    
    MERGE INTO bl_3nf.ce_no_of_childs C
    USING (SELECT  no_of_children FROM bl_cl.cl_customers
    GROUP BY no_of_children)A ON (LOWER(A.no_of_children) = LOWER(C.no_of_child))
    WHEN NOT MATCHED THEN
    INSERT (C.no_of_child_id, C.no_of_child, C.update_dt)
    VALUES (bl_3nf.sequence_common_1.NEXTVAL, A.no_of_children, current_date);
    
    log_event('Merged ' || sql%Rowcount || ' rows into table ce_no_of_childs');
    COMMIT;
    END;

END customers_cl_to_3nf_pkg;
/