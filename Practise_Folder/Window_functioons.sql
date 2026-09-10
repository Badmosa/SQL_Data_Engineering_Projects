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

--partition by--
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

--partition by and order by--
 SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY
    job_title_short,
    job_posted_date
LIMIT 10;

--partition by and order by--
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    MAX(salary_hour_avg) OVER(
        PARTITION BY 
            job_title_short
        ORDER BY
            job_posted_date
    ) AS running_avg_hour_by_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL  AND
    job_title_short = 'Data Engineer'
ORDER BY
    salary_hour_avg,
    job_title_short
LIMIT 10;

--Row & Rank Fuuction--
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(
        ORDER BY
            salary_hour_avg
    ) AS rank_hourly_avg
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg
LIMIT 140;

--Row_Number--
SELECT
    *,
    ROW_NUMBER() OVER(
        ORDER BY 
            job_posted_date
    )
FROM
    job_postings_fact
ORDER BY
    job_posted_date
LIMIT 20;

--Navigation Function--
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_postinigs_salary,
        salary_year_avg -   LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;

--LEAD--
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_postinigs_salary,
        salary_year_avg -   LEAD(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;