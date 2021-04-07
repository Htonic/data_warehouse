CREATE TABLE ce_postcodes (
    postcode_id  INTEGER PRIMARY KEY,
    postcode     VARCHAR2(12) NOT NULL,
    update_dt    DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_postcodes( postcode_id, postcode) VALUES
(-1, 'N/A');
COMMIT;