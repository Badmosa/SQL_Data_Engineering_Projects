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
        skill := 'skills',
        type := 'types'
    )
FROM skill_table;

--ARRAY OF STRUCT--
SELECT [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] AS skills_query_of_structs;