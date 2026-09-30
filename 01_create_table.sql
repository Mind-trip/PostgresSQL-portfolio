CREATE TABLE bank_marketing (
    id SERIAL PRIMARY KEY,
    age INT,
    job VARCHAR(50),
    marital VARCHAR(20),
    education VARCHAR(50),
    default_flag VARCHAR(10),
    housing VARCHAR(10),
    loan VARCHAR(10),
    contact VARCHAR(20),
    month VARCHAR(10),
    day_of_week VARCHAR(10),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(20),
    emp_var_rate NUMERIC(6,2),
    cons_price_idx NUMERIC(7,3),
    cons_conf_idx NUMERIC(7,3),
    euribor3m NUMERIC(7,3),
    nr_employed NUMERIC(7,1),
    y VARCHAR(5)
);

SELECT count(*)
FROM bank_marketing

SELECT *
FROM bank_marketing
LIMIT 5

SELECT 
    MIN(b.age),
    MAX(b.age),
    AVG(b.age)
FROM bank_marketing b

SELECT 
    job,
    count (*) clients_count
FROM bank_marketing 
GROUP BY job
ORDER BY clients_count DESC

SELECT 
    y,
    count (*) cnt,
    ROUND (count (*) * 100.0 / (SELECT count(*) FROM bank_marketing), 2) pct
FROM bank_marketing 
GROUP BY y
ORDER BY y ASC

SELECT 
    marital,
    count (*) cnt,
    ROUND (count (*) * 100.0 / (SELECT count(*) FROM bank_marketing), 2) pct
FROM bank_marketing 
GROUP BY marital
ORDER BY cnt DESC

SELECT 
    y,
    count (*),
    MIN(duration),
    MAX(duration),
    ROUND (AVG(duration), 2) avg
FROM bank_marketing
GROUP BY y
ORDER BY y ASC

SELECT
    job,
    age,
    y,
    ROW_NUMBER () OVER (PARTITION BY job ORDER BY age DESC) row_num
FROM bank_marketing

SELECT 
    y,
    duration,
    ROW_NUMBER () OVER (PARTITION BY y ORDER BY duration DESC),
    RANK () OVER (PARTITION BY y ORDER BY duration DESC),
    DENSE_RANK () OVER (PARTITION BY y ORDER BY duration DESC)
FROM bank_marketing

SELECT 
    y,
    duration,
    lag (duration) OVER (PARTITION BY y ORDER BY duration DESC) PREV_duration,
    lead (duration) OVER (PARTITION BY y ORDER BY duration DESC),
    duration - lag (duration) OVER (PARTITION BY y ORDER BY duration DESC) deiff_with_prev
FROM bank_marketing

SELECT 
    job,
    count (*) AS cnt,
    SUM (count (*)) OVER (ORDER BY job ) ranning_total
FROM bank_marketing
GROUP BY job

SELECT 
    job,
    duration,
    ROUND (AVG (duration) OVER (PARTITION BY job), 2) AS avg_duration_by_job,
    ROUND (duration - AVG (duration) OVER (PARTITION BY job), 2) AS diff_from_avg
FROM bank_marketing


//новый блок

SELECT 
    y,
    age_quartile,
    count (*),
    MIN(age),
    MAX(age)
FROM (
SELECT 
    y,
    age,
    NTILE (4) OVER (PARTITION BY y ORDER BY age) AS age_quartile
FROM bank_marketing
)
GROUP BY y, age_quartile
ORDER BY y, age_quartile

SELECT 
    job,
    duration,
    MIN(duration) OVER (PARTITION BY job),
    MAX(duration) OVER (PARTITION BY job)
FROM bank_marketing
 ORDER BY  duration DESC



WITH cte 
    AS (SELECT
        job,
        ROUND (AVG(age), 2) AS avg_job,
        count(*)
    
    FROM bank_marketing
    GROUP BY job 
    )
SELECT *
FROM cte
WHERE count > 500
ORDER BY avg_job DESC
LIMIT 3


WITH cte AS (
    SELECT
        job,
        ROUND (AVG(duration), 2) AS avg_duration,
        count(*) AS cnt
    FROM bank_marketing
    GROUP BY job
    HAVING count(*) > 2000
)
SELECT *
FROM cte
WHERE avg_duration > 250
ORDER BY avg_duration DESC

WITH cte AS (
    SELECT 
        job,
        count(*),
        SUM (CASE 
            WHEN y='yes' THEN 1
            ELSE 0
        END) AS yes_cnt, 
        SUM (CASE 
            WHEN y='no' THEN 1 
            ELSE  0
        END) AS no_cnt
    FROM bank_marketing
    GROUP BY job
    ORDER BY count(*) DESC
)
SELECT *
FROM cte

