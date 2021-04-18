CREATE OR REPLACE PACKAGE bl_cl.manager_pkg
   AUTHID DEFINER
IS
    PROCEDURE dwh_initial_load_all;
    PROCEDURE dwh_incremental_load_sales;

END manager_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_cl.manager_pkg
IS

   
    

    PROCEDURE dwh_initial_load_all
    IS
    BEGIN
    --load into src
        stores_ext_to_src_pkg.insert_stores;
        products_ext_to_src_pkg.insert_products;
        customers_ext_to_src_pkg.insert_customers;
        sales_ext_to_src_pkg.insert_sales;
        employees_ext_to_src_pkg.insert_employees;
        coupons_ext_to_src_pkg.insert_coupons;
        payment_types_ext_to_src_pkg.insert_payment_types;
    --load into cl
        stores_src_to_cl_pkg.insert_stores;
        products_src_to_cl_pkg.insert_products;
        customers_src_to_cl_pkg.insert_customers;
        sales_src_to_cl_pkg.insert_sales;
        employees_src_to_cl_pkg.insert_employees;
        coupons_src_to_cl_pkg.insert_coupons;
        payment_types_src_to_cl_pkg.insert_payment_types;
    --load into 3nf
EXEC cl_to_3nf.insert_countries;
EXEC cl_to_3nf.insert_postcodes;
EXEC cl_to_3nf.insert_states;
EXEC cl_to_3nf.insert_cities;
EXEC cl_to_3nf.insert_stores;

EXEC cl_to_3nf.insert_product_brand_types;
EXEC cl_to_3nf.insert_product_brand;
EXEC cl_to_3nf.insert_product_categories;
EXEC cl_to_3nf.insert_products;

EXEC cl_to_3nf.insert_employees;
EXEC cl_to_3nf.insert_coupons;
EXEC cl_to_3nf.insert_payment_types;

EXEC cl_to_3nf.insert_age_range;
EXEC cl_to_3nf.insert_family_sizes;
EXEC cl_to_3nf.insert_marital_statuses;
EXEC cl_to_3nf.insert_no_of_childs;
EXEC cl_to_3nf.insert_customers;

EXEC cl_to_3nf.insert_sales;        
        
        bl_3nf.switch_constraints_pkg.enable_3nf_foreign_keys;
    --load into dm
        bl_dm.switch_constraints_pkg.disable_dm_foreign_keys;
    
        stores_3nf_to_dm_pkg.insert_stores;
        products_3nf_to_dm_pkg.insert_products;
        customers_3nf_to_dm_pkg.insert_customers;
        employees_3nf_to_dm_pkg.insert_employees;
        coupons_3nf_to_dm_pkg.insert_coupons;
        payment_types_3nf_to_dm_pkg.insert_payment_types;
        
        sales_3nf_to_dm_pkg.sales_initial_load;
        
        bl_dm.switch_constraints_pkg.enable_dm_foreign_keys;
    END;
    
    PROCEDURE dwh_incremental_load_sales
    IS
    BEGIN
        sales_ext_to_src_pkg.insert_sales;
        sales_src_to_cl_pkg.merge_sales;
        sales_cl_to_3nf_pkg.merge_sales;
        sales_3nf_to_dm_pkg.sales_incremental_load_last_month;
    END;
END manager_pkg;
/