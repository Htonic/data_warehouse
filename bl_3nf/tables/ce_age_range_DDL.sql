CREATE TABLE ce_age_range (
    age_range_id  INTEGER NOT NULL,
    age_range     NVARCHAR(8) NOT NULL,
    update_dt     DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_age_range(age_range_id, age_range) VALUES
(-1, 'N/A');
COMMIT;