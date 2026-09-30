
-- 1. NTILE: квартили по возрасту внутри y
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


-- 2. MIN/MAX OVER: границы duration по профессии
SELECT 
    job,
    duration,
    MIN(duration) OVER (PARTITION BY job),
    MAX(duration) OVER (PARTITION BY job)
FROM bank_marketing
 ORDER BY  duration DESC


-- 3. CTE: топ-3 профессии по среднему возрасту (cnt > 500)
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


-- 4. HAVING: профессии с avg_duration > 250 и cnt > 2000
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


-- 5. CASE + GROUP BY: сводная по yes/no по профессиям
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