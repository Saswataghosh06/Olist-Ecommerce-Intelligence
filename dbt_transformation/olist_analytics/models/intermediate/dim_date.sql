WITH date_spine AS (
    -- Generates a row for every single day from 2016 to 2019 using Databricks sequence generation
    SELECT explode(sequence(to_date('2016-01-01'), to_date('2019-12-31'), interval 1 day)) AS date_day
)

SELECT
    date_day,
    year(date_day) AS year,
    month(date_day) AS month,
    day(date_day) AS day_of_month,
    dayofweek(date_day) AS day_of_week, -- 1 is Sunday, 7 is Saturday in Spark SQL
    CASE 
        WHEN dayofweek(date_day) IN (1, 7) THEN TRUE 
        ELSE FALSE 
    END AS is_weekend
FROM date_spine