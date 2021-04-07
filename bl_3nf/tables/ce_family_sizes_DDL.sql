CREATE TABLE ce_marital_statuses (
    marital_id      INTEGER NOT NULL,
    marital_status  NVARCHAR(40) NOT NULL,
    update_dt       DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_family_sizes(family_id, family_size) VALUES
(-1, 'N/A');
COMMIT;