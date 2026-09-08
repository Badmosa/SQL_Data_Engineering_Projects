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