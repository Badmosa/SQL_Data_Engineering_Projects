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