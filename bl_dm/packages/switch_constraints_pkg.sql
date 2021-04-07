CREATE OR REPLACE PACKAGE bl_dm.switch_constraints_pkg
   AUTHID DEFINER
IS
    PROCEDURE disable_dm_foreign_keys;
    PROCEDURE enable_dm_foreign_keys;

END switch_constraints_pkg;
/

CREATE OR REPLACE PACKAGE BODY bl_dm.switch_constraints_pkg
IS
PROCEDURE disable_dm_foreign_keys
    IS
    BEGIN
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_coupons_fk';

     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_customers_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_dates_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_dates_fkv1';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_payment_types_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_products_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        DISABLE CONSTRAINT sales_stores_fk'; 
        
        
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_coupons_fk';

     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_customers_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_dates_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_dates_fkv1';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_payment_types_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_products_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        DISABLE CONSTRAINT tmp_sales_stores_fk';  
    END;
    
    PROCEDURE enable_dm_foreign_keys
    IS
    BEGIN
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_coupons_fk';

     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_customers_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_dates_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_dates_fkv1';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_payment_types_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_products_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE bl_dm.fct_sales
        ENABLE CONSTRAINT sales_stores_fk'; 
        
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_coupons_fk';

     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_customers_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_dates_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_dates_fkv1';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_payment_types_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_products_fk';
    
     EXECUTE IMMEDIATE 'ALTER TABLE tmp_fct_sales
        ENABLE CONSTRAINT tmp_sales_stores_fk';  
    END;
END switch_constraints_pkg;
/