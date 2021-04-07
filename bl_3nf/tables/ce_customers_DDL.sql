CREATE TABLE ce_customers (
    customer_id            INTEGER PRIMARY KEY,
    customer_natural_id  INTEGER NOT NULL,
    rented                 INTEGER NOT NULL,
    income_bracket         INTEGER NOT NULL,
    age_range_id           INTEGER DEFAULT -1 NOT NULL,
    marital_id             INTEGER DEFAULT -1 NOT NULL,
    family_id              INTEGER DEFAULT -1 NOT NULL,
    no_of_child_id         INTEGER DEFAULT -1 NOT NULL,
    update_dt              DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_customers(customer_id, customer_natural_id, rented, income_bracket,
age_range_id, marital_id, family_id, no_of_child_id) VALUES
(-1, -1, 0, 0,
-1, -1, -1, -1);
COMMIT;