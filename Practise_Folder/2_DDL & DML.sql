-- SQLBook: Code
--SELECT current_database();

--switching database;
--USE jobs_mart;
--SHOW DATABASES;


CREATE OR REPLACE TABLE jobs_mart.staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.main.job_postings_fact AS jpf
LEFT JOIN data_jobs.main.company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT *
FROM staging.job_postings_flat
LIMIT 10;




CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
SELECT
    jpf.*
FROM staging.job_postings_flat AS jpf
JOIN staging.priority_role AS r
    ON jpf.job_title_short = r.role_name
WHERE r.priority_lvl = 1;

-- Updating priority_lvl--
UPDATE staging.priority_role
SET priority_lvl = 1
WHERE role_id = 1;

UPDATE staging.priority_role
SET priority_lvl = 2
WHERE role_id = 2;

UPDATE staging.priority_role
SET priority_lvl = 3
WHERE role_id = 3;

--Updating typo---
UPDATE staging.priority_role
SET role_name = 'Senior Data Engineer'
WHERE role_id = 2;

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer'
LIMIT 10;


SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp
GROUP BY job_title_short
ORDER BY job_count DESC;

--DELETE--
SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

--TRUNCATE--
TRUNCATE TABLE staging.job_postings_flat;

SELECT *
FROM staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.main.job_postings_fact AS jpf
LEFT JOIN data_jobs.main.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date < '2024-01-01';


SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

