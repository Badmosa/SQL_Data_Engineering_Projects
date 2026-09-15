--duckdb dw_DW_marts.duckdb -c "
--create star schema tables--
.read DW_Tables.sql

--load data from CSV files into tables
.read DW_Load_schema.sql