CREATE TABLE ce_no_of_childs (
    no_of_child_id  INTEGER PRIMARY KEY,
    no_of_child     VARCHAR2(4) NOT NULL,
    update_dt       DATE DEFAULT CURRENT_DATE NOT NULL
);

INSERT INTO ce_no_of_childs(no_of_child_id, no_of_child) VALUES
(-1, 'N/A');
COMMIT;