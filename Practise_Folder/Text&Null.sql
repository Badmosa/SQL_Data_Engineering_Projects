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
