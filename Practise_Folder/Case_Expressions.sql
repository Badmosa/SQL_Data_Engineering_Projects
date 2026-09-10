-- SQLBook: Code
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

-- coditliopnal aggeregation--
SELECT
    job_title_short,
    COUNT(*) AS total_postings,
    MEDIAN(
        CASE 
            WHEN salary_year_avg < 100_000 THEN salary_year_avg
            END 
    ) AS median_low_salary,
    MEDIAN(
        CASE 
            WHEN salary_year_avg >= 100_000 THEN salary_year_avg
            END 
     ) AS median_high_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short;

--conditional calculation--
 WITH salaries AS (   
    SELECT
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        CASE 
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2000 
        END AS standardized_salary
    FROM
        job_postings_fact
 )

 SELECT
    *,
    CASE
        WHEN standardized_salary IS NULL THEN  'Missing'
        WHEN standardized_salary < 75_000 THEN 'Low'
        WHEN standardized_salary < 150_000 THEN 'Median'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
LIMIT 10;