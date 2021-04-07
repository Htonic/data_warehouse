INSERT INTO ce_customers(customer_id, customer_natural_id, rented, income_bracket,
age_range_id, marital_id, family_id, no_of_child_id)
SELECT customers.NEXTVAL, customer_id,rented, income_bracket,
car.age_range_id, cms.marital_id, cfs.family_id,
cch.no_of_child_id
FROM bl_cl.cl_customers sr
JOIN ce_age_range car ON car.age_range = sr.age_range
JOIN ce_family_sizes cfs ON cfs.family_size = sr.family_size
JOIN ce_marital_statuses  cms ON cms.marital_status = sr.marital_status 
JOIN ce_no_of_childs  cch ON cch.no_of_child = sr.no_of_children;
COMMIT;
