INSERT INTO ce_age_range(age_range_id, age_range)
SELECT sequence_common_1.NEXTVAL, age_range FROM
    (SELECT  age_range FROM bl_cl.cl_customers
    GROUP BY age_range)a ;
	
COMMIT;
