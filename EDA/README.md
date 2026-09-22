# Exploratory Data Analysis w/ SQL: Job Market Analytics
![Project 1 Overview](../Images/1_EDA.png)

This is a SQL project that analyzes the data engineer job market using real world job posting data. It demonstrates my ability to **write production-quality analytical SQL, design efficient queries, and turn business questions into data-driven insights*.**

## Executive Summary (For Hiring Managers)


- ✅ Project scope: Built 3 analytical queries that answer key questions about the data engineer job market
- ✅ Data modeling: Used multi-table joins across fact and dimension tables to extract insights
- ✅ Analytics: Applied aggregations, filtering, and sorting to find top skills by demand, salary, and overall value
- ✅ Outcomes: Delivered actionable insights on SQL/Python dominance, cloud trends, and salary patterns

### If you only have a minute, review these:
- 1_EDA\Top_demanded_skills – demand analysis with multi-table joins
- 02_top_paying_skills.sql – salary analysis with aggregations
- 03_optimal_skills.sql – combined demand/salary optimization query


# 🧩 Problem & Context
Job market analysts need to answer questions like:

- 🎯 Most in-demand: Which skills are most in-demand for data engineers?
- 💰 Highest paid: Which skills command the highest salaries?
 - ⚖️ Best trade-off: What is the optimal skill set balancing demand and compensation?

This project analyzes a data warehouse built using a star schema design. The warehouse structure consists of:

![Project 1 Overview](../Images/Data_Warehouse.png)

- Fact Table: job_postings_fact - Central table containing job posting details (job titles, locations, salaries, dates, etc.)
Dimension Tables:
    `company_dim` - Company information linked to job postings
    `skills_dim` - Skills catalog with skill names and types
- Bridge Table: skills_job_dim - Resolves the many-to-many relationship between job postings and skills.

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.

# 🧰 Tech Stack
- 🐤 Query Engine: DuckDB for fast OLAP-style analytical queries
- 🧮 Language: SQL (ANSI-style with analytical functions)
- 📊 Data Model: Star schema with fact + dimension + bridge tables
- 🛠️ Development: VS Code for SQL editing + Terminal for DuckDB CLI
- 📦 Version Control: Git/GitHub for versioned SQL scripts

# 📂 Repository Structure
