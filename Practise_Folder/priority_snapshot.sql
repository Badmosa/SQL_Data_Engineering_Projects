CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.prority_lvl,
    CURRENT_TIMESTAMP
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

UPDATE main.priority_jobs_snapshot AS TGT
SET 
    priority_lvl = SRC.priority_lvl,
    updated_at = SRC.updated_at
FROM SRC_priority_jobs AS SRC
WHERE TGT.job_id = SRC.job_id
    AND TGT.priority_lvl IS DISTINCT FROM SRC.priority_lvl;



--insert into--
INSERT INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)

SELECT
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
FROM SRC_priority_jobs AS SRC
WHERE NOT EXISTS (
    SELECT 1
    FROM SRC.priority_jobs_snapshot AS TGT
    WHERE TGT.job_id = SRC.job_id
)

--Delete--

DELETE FROM main.priority_jobs_snapshot AS TGT
WHERE NOT EXISTS (
    SELECT 1
    FROM SRC_priority_jobs AS SRC
    WHERE SRC.job_id = TGT.job_id;
)