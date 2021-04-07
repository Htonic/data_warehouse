CREATE TABLE ce_no_of_childs (
    no_of_child_id  INTEGER NOT NULL,
    no_of_child     NVARCHAR(4) NOT NULL,
    update_dt       DATE DEFAULT GETDATE() NOT NULL
);

INSERT INTO ce_no_of_childs(no_of_child_id, no_of_child) VALUES
(-1, 'N/A');
COMMIT;