CREATE TABLE ce_age_range (
    age_range_id  INTEGER PRIMARY KEY,
    age_range     VARCHAR2(8) NOT NULL,
    update_dt     DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_age_range(age_range_id, age_range) VALUES
(-1, 'N/A');
COMMIT;