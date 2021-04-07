INSERT INTO bl_dm.dim_customers (customer_id, customer_surrogate_id, age_range,
    marital_status, rented, family_size, no_of_child, income_bracket, age_range_id, no_of_child_id,
    family_size_id, marital_status_id)
SELECT SEQUENCE_CUSTOMERS.nextval, cc.customer_id, cag.age_range, cms.marital_status,
cc.rented, cfs.family_size, cnof.no_of_child, 
cc.income_bracket, cag.age_range_id, cnof.no_of_child_id,
cfs.family_id, cms.marital_id
FROM BL_3NF.ce_customers cc
JOIN BL_3NF.ce_family_sizes cfs ON cfs.family_id = cc.family_id 
JOIN BL_3NF.ce_no_of_childs cnof ON cnof.no_of_child_id = cc.no_of_child_id
JOIN BL_3NF.ce_age_range cag ON cag.age_range_id = cc.age_range_id
JOIN BL_3NF.ce_marital_statuses cms ON cms.marital_id = cc.marital_id;
COMMIT;
