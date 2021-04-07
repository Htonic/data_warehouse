CREATE OR REPLACE PACKAGE bl_3nf.switch_constraints_pkg
   AUTHID DEFINER
IS
    PROCEDURE disable_3nf_foreign_keys;
    PROCEDURE enable_3nf_foreign_keys;

END switch_constraints_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_3nf.switch_constraints_pkg
IS

    PROCEDURE disable_3nf_foreign_keys
    IS
    BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_cities
        DISABLE CONSTRAINT city_state_fk';
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        DISABLE CONSTRAINT customers_age_range_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        DISABLE CONSTRAINT customers_family_sizes_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        DISABLE CONSTRAINT customers_marital_statuses_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        DISABLE CONSTRAINT customers_no_of_childs_fk' ;
        
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_product_brand
        DISABLE CONSTRAINT brand_type_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_products
        DISABLE CONSTRAINT products_product_brand_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_products
        DISABLE CONSTRAINT products_product_categories_fk';
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_coupons_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_customers_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_dates_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_payment_types_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_products_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        DISABLE CONSTRAINT sales_stores_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_states
        DISABLE CONSTRAINT state_country_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_stores
        DISABLE CONSTRAINT stores_cities_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_stores
        DISABLE CONSTRAINT stores_postcodes_fk' ;
        bl_cl.log_event('Disabled foreign keys for 3nf schema');
    END;

    PROCEDURE enable_3nf_foreign_keys
    IS
    BEGIN 
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_cities
        ENABLE CONSTRAINT city_state_fk';
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        ENABLE CONSTRAINT customers_age_range_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        ENABLE CONSTRAINT customers_family_sizes_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        ENABLE CONSTRAINT customers_marital_statuses_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_customers
        ENABLE CONSTRAINT customers_no_of_childs_fk' ;
        
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_product_brand
        ENABLE CONSTRAINT brand_type_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_products
        ENABLE CONSTRAINT products_product_brand_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_products
        ENABLE CONSTRAINT products_product_categories_fk';
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_coupons_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_customers_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_dates_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_payment_types_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_products_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_sales
        ENABLE CONSTRAINT sales_stores_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_states
        ENABLE CONSTRAINT state_country_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_stores
        ENABLE CONSTRAINT stores_cities_fk' ;
    
    EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_stores
        ENABLE CONSTRAINT stores_postcodes_fk' ;
        bl_cl.log_event('Enabled foreign keys for 3nf schema');
    END;
END switch_constraints_pkg;
/