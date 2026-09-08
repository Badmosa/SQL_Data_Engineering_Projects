--bUCKET SARARY--
SELECT
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg < 25 THEN 'LOW'
        WHEN salary_hour_avg < 50 THEN 'MEDIAN'
        ELSE 'HIGH'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

-- Handling missing values--
SELECT
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg < 25 THEN 'LOW'
        WHEN salary_hour_avg < 50 THEN 'MEDIAN'
        ELSE 'HIGH'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;

--Standardizing Catgorical Values--
SELECT
    job_title,
    CASE 
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'other'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

