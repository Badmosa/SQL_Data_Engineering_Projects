CREATE OR REPLACE TABLE staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    prority_lvl INTEGER
);

INSERT INTO staging.priority_roles (role_id, role_name, prority_lvl)
VALUES
(1, 'Data Engineer', 2),
(2, 'Senior Data Engineer', 1),
(3, 'Softare Engineer', 3);

SELECT *
    FROM
        staging.priority_roles;
