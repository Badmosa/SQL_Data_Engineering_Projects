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