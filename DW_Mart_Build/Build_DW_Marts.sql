--duckdb dw_marts.duckdb -c ".read Build_DW_Marts.sql"


--create star schema tables--
.read DW_Tables.sql

--load data from CSV files into tables
.read DW_Load_schema.sql