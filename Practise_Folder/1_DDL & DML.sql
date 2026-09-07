-- .read 'Practise_Folder/1_DDL & DML.sql'

USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart;


CREATE DATABASE IF NOT EXISTS jobs_mart;

 SHOW DATABASES;


-- checking an existing schema if exists in the database.
SELECT *
FROM information_schema.schemata;


USE jobs_mart;

--creatging schema--
CREATE SCHEMA IF NOT EXISTS staging;

-- TABLES--
CREATE TABLE IF NOT EXISTS staging.preferred_role(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT *    
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';


--INSERT-
INSERT INTO staging.preferred_role ( role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senoir Data Engineer'),
    (3, 'Senior Software Engineer');

SELECT *
FROM staging.preferred_role;--

SELECT *
FROM staging.priority_role;

ALTER TABLE staging.preferred_role
ADD COLUMN preferred_role BOOLEAN;


UPDATE  staging.preferred_role
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;


UPDATE  staging.preferred_role
SET preferred_role = FALSE
WHERE role_id = 3;


ALTER TABLE staging.preferred_role
RENAME TO priority_role;


ALTER TABLE staging.priority_role
RENAME COLUMN preferred_role TO priority_lvl;


ALTER TABLE staging.priority_role
ALTER COLUMN priority_lvl TYPE INTEGER;


UPDATE staging.priority_role
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM staging.priority_role;


SELECT *
FROM staging.priority_role;
