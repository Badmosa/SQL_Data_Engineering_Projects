--duckdb dw_marts.duckdb -c ".read Build_DW_Marts.sql"


--create star schema tables--
.read DW_Tables.sql

--load data from CSV files into tables--
.read DW_Load_schema.sql

--Create Flat_Marts--
-.read Flat_Marts.sql







------------------------------------------
-- Verify flat mart was created
SELECT 'Flat Mart Job Postings' AS table_name, COUNT(*) as record_count FROM flat_mart.job_postings;

-- Show sample data
SELECT '=== Flat Mart Sample ===' AS info;
SELECT 
    job_id,
    company_name,
    job_title_short,
    job_location,
    job_country,
    salary_year_avg,
    job_work_from_home,
    skills_and_types
FROM flat_mart.job_postings 
LIMIT 10;