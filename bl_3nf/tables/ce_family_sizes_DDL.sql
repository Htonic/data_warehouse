CREATE TABLE ce_marital_statuses (
    marital_id      INTEGER PRIMARY KEY,
    marital_status  VARCHAR2(40) NOT NULL,
    update_dt       DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_family_sizes(family_id, family_size) VALUES
(-1, 'N/A');
COMMIT;