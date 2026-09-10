CREATE TEMP TABLE jobs_2023 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2023;

CREATE TEMP TABLE jobs_2024 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024;

--which unique jobb postings appear in either 2023 or 2024?--
SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023
UNION
SELECT 
    'jobs_2023' AS table_name,
    COUNT(*) 
FROM jobs_2024;

SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;

-- which job postings appeeared across both years, counting duplicates--
SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

-- WHICH JOB POSTIINGS APPEARE IN 2023 BUT NOT IN 2024?
SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

--which job postings from 2023 remain after subastracting matching 2024 postings, one-for-one?--
SELECT * FROM jobs_2023
EXCEPT ALL 
SELECT * FROM jobs_2024;

--WHICH JOB POSTINGS APPEAR IN BOTH 2023 AND 2024?--
SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

-- what job postings apppear in both years, preserving duplicate counts?--
SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;