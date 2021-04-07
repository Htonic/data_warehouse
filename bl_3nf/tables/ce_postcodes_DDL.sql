CREATE TABLE ce_postcodes (
    postcode_id  INTEGER NOT NULL,
    postcode     NVARCHAR(12) NOT NULL,
    update_dt    DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_postcodes( postcode_id, postcode) VALUES
(-1, 'N/A');
COMMIT;