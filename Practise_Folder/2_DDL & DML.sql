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

--Subquery and CTEs(Coment Tables Expressions)--
SELECT *
FROM (SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

--CTE--
WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries
LIMIT 10;

--SCENARIOS
--subquery in select
-- show each job salary next to  the overall market median:
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    )   AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

--stage only jobs that are remote before aggregating:
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    )   AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;

-- KEEP ONLY TITLES WHOS MEDIAN SALARY IS AVOVE THE OVERALL MEDIAN: HAVING
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    )   AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    ) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;

---CTEs(Coment Tables Expressions)--
-- Example:
--compare hoe much (or less) remote roles pay compared to onsite roles for each job title.
--Use a CTe to calculate the median salary by title and work arrangement, than compare those medians.
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg):: INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'Nigeria'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    O.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS O
    ON r.job_title_short = O.job_title_short
WHERE r.job_work_from_home  = TRUE
    AND O.job_work_from_home = FALSE;
ORDER BY rmote_premium DESC


SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;


SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;



SELECT *
FROM job_postings_fact AS TGT
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS SRC
    WHERE TGT.job_id = SRC.job_id
)
ORDER BY job_id;












------------------------------------------------------
SELECT *
FROM range(5) AS SRC(key);


SELECT *
FROM range(3) AS TGT(key);


SELECT *
FROM range(5) AS SRC(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(3) AS TGT(key)
    WHERE TGT.key = SRC.key
);







