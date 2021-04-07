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
        bl_3nf.switch_constraints_pkg.disable_3nf_foreign_keys;
    
        stores_cl_to_3nf_pkg.insert_countries;
        stores_cl_to_3nf_pkg.insert_postcodes;
        stores_cl_to_3nf_pkg.insert_states;
        stores_cl_to_3nf_pkg.insert_cities;
        stores_cl_to_3nf_pkg.insert_stores;
        
        products_cl_to_3nf_pkg.insert_product_brand_types;
        products_cl_to_3nf_pkg.insert_product_brand;
        products_cl_to_3nf_pkg.insert_product_categories;     
        products_cl_to_3nf_pkg.insert_products;
        
        customers_cl_to_3nf_pkg.insert_age_range;
        customers_cl_to_3nf_pkg.insert_family_sizes;
        customers_cl_to_3nf_pkg.insert_marital_statuses;
        customers_cl_to_3nf_pkg.insert_no_of_childs;
        customers_cl_to_3nf_pkg.insert_customers;
        
        payment_types_cl_to_3nf_pkg.insert_payment_types;
        employees_cl_to_3nf_pkg.insert_employees;
        coupons_cl_to_3nf_pkg.insert_coupons;
        
        sales_cl_to_3nf_pkg.insert_sales;
        
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