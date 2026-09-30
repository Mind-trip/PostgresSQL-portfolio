-- 1. ROW_NUMBER: нумерация по возрасту внутри профессии
SELECT
    job,
    age,
    y,
    ROW_NUMBER () OVER (PARTITION BY job ORDER BY age DESC) row_num
FROM bank_marketing


-- 2. RANK / DENSE_RANK / ROW_NUMBER: разница на одинаковых значениях
SELECT 
    y,
    duration,
    ROW_NUMBER () OVER (PARTITION BY y ORDER BY duration DESC),
    RANK () OVER (PARTITION BY y ORDER BY duration DESC),
    DENSE_RANK () OVER (PARTITION BY y ORDER BY duration DESC)
FROM bank_marketing


-- 3. LAG / LEAD: сравнение с соседними строками
SELECT 
    y,
    duration,
    lag (duration) OVER (PARTITION BY y ORDER BY duration DESC) PREV_duration,
    lead (duration) OVER (PARTITION BY y ORDER BY duration DESC),
    duration - lag (duration) OVER (PARTITION BY y ORDER BY duration DESC) deiff_with_prev
FROM bank_marketing


-- 4. SUM OVER: накопительная сумма клиентов по профессиям
SELECT 
    job,
    count (*) AS cnt,
    SUM (count (*)) OVER (ORDER BY job ) ranning_total
FROM bank_marketing
GROUP BY job


-- 5. AVG OVER: средний duration по профессии без сворачивания
SELECT 
    job,
    duration,
    ROUND (AVG (duration) OVER (PARTITION BY job), 2) AS avg_duration_by_job,
    ROUND (duration - AVG (duration) OVER (PARTITION BY job), 2) AS diff_from_avg
FROM bank_marketing