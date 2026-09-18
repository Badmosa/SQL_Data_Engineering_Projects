--duckdb dw_marts.duckdb -c ".read Build_DW_Marts.sql"


--Data Warehouse: create star schema tables--
.read DW_Tables.sql

--Data Warehouse: load data from CSV files into tables--
.read DW_Load_schema.sql

--Mart: Create Flat_Marts--
.read Flat_Marts.sql

--Mart: Create Skills Demand Mart
.read Skills_Mart.sql

--Mart: Create Priority Mart--
.read Create_Priority_Mart.sql

--Mart: Update Priority Mart--
.read Create_Priority_Mart.sql

--Duckdb: Database Access Link--Motherduck--
-- ATTACH 'md:_share/dw_marts/1f6c6935-d6d9-40e5-a7b1-2b71319b8ab1'
