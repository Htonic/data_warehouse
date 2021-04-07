INSERT INTO ce_countries(country_id, country_name) VALUES
(-1, 'N/A');

INSERT INTO ce_states(state_id, state_name, country_id) VALUES
(-1, 'N/A', -1);

INSERT INTO ce_cities(city_id, city_name, state_id) VALUES
(-1, 'N/A', -1);

INSERT INTO ce_postcodes( postcode_id, postcode) VALUES
(-1, 'N/A');

INSERT INTO ce_stores(store_id, store_number,
    store_name,street_address,
    phone_number,city_id,postcode_id) VALUES
(-1, 'N/A', 'N/A', 'N/A', 'N/A', -1, -1);


INSERT INTO ce_age_range(age_range_id, age_range) VALUES
(-1, 'N/A');

INSERT INTO ce_family_sizes(family_id, family_size, update_dt) 
VALUES
(-1, 'N/A', GETDATE());

INSERT INTO ce_marital_statuses(marital_id, marital_status) VALUES
(-1, 'N/A');

INSERT INTO ce_no_of_childs(no_of_child_id, no_of_child) VALUES
(-1, 'N/A');

INSERT INTO ce_customers(customer_id, customer_natural_id, rented, income_bracket,
	age_range_id, marital_id, family_id, no_of_child_id, update_dt) 
VALUES
	(-1, -1, 0, 0,
	-1, -1, -1, -1, GETDATE());


INSERT INTO ce_employees(employee_id, employee_natural_id, employee_name,
employee_surname, age, email, phone, update_dt) VALUES 
	 (-1, -1, 'N/A',
	 'N/A', 0, 'N/A', 'N/A', GETDATE());


INSERT INTO ce_coupons(coupon_id, coupon_natural_id, 
	coupon_desc, issued_quantity, update_dt) 
VALUES
	(-1, -1, 'N/A', 0, GETDATE());

INSERT INTO ce_payment_types(payment_type_id, payment_type_natural_id,
 payment_type_desc, update_dt) VALUES
        (-1, -1, 'N/A', GETDATE());


INSERT INTO ce_product_categories(product_category_id, product_category_desc) VALUES
(-1, 'N/A');

INSERT INTO ce_product_brand_types(brand_type_id, brand_type) VALUES
(-1, 'N/A');

INSERT INTO ce_product_brand(brand_id, brand, brand_type_id, update_dt) VALUES
        (-1, -1, -1, GETDATE());

INSERT INTO ce_products(product_id, product_natural_id, brand_id,
	product_category_id,start_date, end_date, is_active, update_dt) VALUES
	(-1,-1, -1, -1, '1970.12.12','1970.12.12', '0', GETDATE());