SELECT *
FROM read_csv('http://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=true)
LIMIT 10;