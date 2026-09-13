--ARRAY--
SELECT ['python', 'sql', 'r'] AS skills_array;

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
SELECT ARRAY_AGG(skills ORDER BY skills) AS skills
FROM skills
)
SELECT
    skills[1] AS first_skill,
    skills[1] AS first_skill,
    skills[1] AS first_skill
FROM
    skills_array;


--STRUCT--
SELECT { skill: 'python', type: 'programming'} AS skill_struct;

WITH skill_struct AS(
    SELECT
        STRUCT_PACK(
            skill := 'python',
            type := 'programming'
        ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;

WITH skill_table AS (
        SELECT 'python' AS skills, 'programming' AS types
        UNION ALL
        SELECT 'sql', 'query_language'
        UNION ALL
        SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;

--ARRAY OF STRUCT--
SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_query_of_structs;


WITH skill_table AS (
        SELECT 'python' AS skills, 'programming' AS types
        UNION ALL
        SELECT 'sql', 'query_language'
        UNION ALL
        SELECT 'r', 'programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) AS array_struct
        FROM skill_table
)
SELECT
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
    FROM skills_array_struct;

--MAP/OBJECT/DICTIONARY--
WITH skill_map AS (
    SELECT MAP {'skill': 'python', 'type': 'programming'}  AS skill_type
)
SELECT
    skill_type['skill'],
    skill_type['type']
FROM
    skill_map;

--JASON--
WITH raw_skill AS (
    SELECT
        '{"skill":"python", "type":"programmiing"}':: JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
         type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill;


--Arrays--
--Build a flat skiill table for co-workers to access job titles, salary info, and skills in one table--
CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- Analyze the median salary per skill--
--SELECT ['python', 'sql', 'r'] AS skills_array;
WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM
        job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary;

--Array of STRUCT--
CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

--------------
WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name AS skill_name
    FROM
        job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;



-- Step 1: Update existing priority role
-- Update Data Engineer priority level to 1
UPDATE priority_mart.priority_roles
SET priority_lvl = 1
WHERE role_name = 'Data Engineer';

-- Step 2: Insert new priority role
-- Add Data Scientist as a new priority role with level 2
INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES (4, 'Data Scientist', 2);

-- Step 3: Create temporary source table
-- This table contains the current state of priority jobs from the data warehouse
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT 
  jpf.job_id,
  jpf.job_title_short,
  cd.name AS company_name,
  jpf.job_posted_date,
  jpf.salary_year_avg,
  r.priority_lvl,
  CURRENT_TIMESTAMP AS updated_at
FROM
    job_postings_fact AS jpf                          -- updated to use main schema
LEFT JOIN company_dim AS cd                           -- updated to use main schema
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r               -- updated to use priority_mart schema
    ON jpf.job_title_short = r.role_name;

-- Step 4: MERGE operation to update snapshot
-- This MERGE statement handles:
-- - Updates when priority_lvl changes (WHEN MATCHED)
-- - Inserts for new jobs (WHEN NOT MATCHED)
-- - Deletes for jobs no longer in source (WHEN NOT MATCHED BY SOURCE)
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt     -- updated to use priority_mart schema
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES (
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Verify mart was updated
SELECT 'Priority Roles Dimension' AS table_name, COUNT(*) as record_count FROM priority_mart.priority_roles
UNION ALL
SELECT 'Priority Jobs Snapshot', COUNT(*) FROM priority_mart.priority_jobs_snapshot;

-- Show sample data from each table
SELECT '=== Priority Roles Dimension Sample ===' AS info;
SELECT * FROM priority_mart.priority_roles;

SELECT '=== Priority Jobs Snapshot Sample ===' AS info;
SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot          -- updated to use priority_mart schema
GROUP BY job_title_short
ORDER BY job_count DESC;