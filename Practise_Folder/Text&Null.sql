--lenght & count--
WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

    SELECT
        job_title,
        CASE 
            WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
            WHEN job_title_clean LIKE '%data%' 
            AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
            WHEN job_title_clean LIKE '%data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
            ELSE 'other'
        END AS job_title_category
    FROM title_lower
    ORDER BY RANDOM()
    LIMIT 30;


--NULL FUNCTION--
SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR  salary_year_avg  IS NOT NULL
LIMIT 10;


-------------------
SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR  salary_year_avg  IS NOT NULL
ORDER BY salary_hour_avg
LIMIT 10;




--Coalesce--
SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2000)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR  salary_year_avg  IS NOT NULL
LIMIT 10;