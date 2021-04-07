CREATE TABLE ce_stores (
    store_id        INTEGER PRIMARY KEY,
    store_number    VARCHAR2(14) NOT NULL,
    store_name      VARCHAR2(60) NOT NULL,
    street_address  VARCHAR2(255) NOT NULL,
    phone_number    VARCHAR2(20) NOT NULL,
    city_id         INTEGER DEFAULT -1 NOT NULL,
    postcode_id     INTEGER DEFAULT -1 NOT NULL,
    update_dt      DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_stores(store_id, store_number,
    store_name,street_address,
    phone_number,city_id,postcode_id) VALUES
(-1, 'N/A', 'N/A', 'N/A', 'N/A', -1, -1);
COMMIT;