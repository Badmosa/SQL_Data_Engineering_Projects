--count rows -- aggregation only

SELECT
    count(*)
FROM 
    job_postings_fact;

--window funcion--
SELECT 
    job_id,
    count(*) OVER()
FROM
    job_postings_fact;

------------------------
SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    )
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM()
LIMIT 10;

--ORDER BY--
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY
            salary_hour_avg
    ) AS rank_hourly_avg
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg
LIMIT 10;