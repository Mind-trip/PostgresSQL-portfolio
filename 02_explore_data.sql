-- 1. Общее количество клиентов
SELECT count(*)
FROM bank_marketing

-- 2. Статистика по возрасту
SELECT 
    MIN(b.age),
    MAX(b.age),
    AVG(b.age)
FROM bank_marketing b


-- 3. Количество клиентов по профессиям (убывание)
SELECT 
    job,
    count (*) clients_count
FROM bank_marketing 
GROUP BY job
ORDER BY clients_count DESC


-- 4. Конверсия по y (yes/no + процент)
SELECT 
    y,
    count (*) cnt,
    ROUND (count (*) * 100.0 / (SELECT count(*) FROM bank_marketing), 2) pct
FROM bank_marketing 
GROUP BY y
ORDER BY cnt DESC


-- 5. Распределение по семейному положению
SELECT 
    marital,
    count (*) cnt,
    ROUND (count (*) * 100.0 / (SELECT count(*) FROM bank_marketing), 2) pct
FROM bank_marketing 
GROUP BY marital
ORDER BY cnt DESC


-- 6. Средняя длительность звонка по y
SELECT 
    y,
    count (*),
    MIN(duration),
    MAX(duration),
    ROUND (AVG(duration), 2) avg
FROM bank_marketing
GROUP BY y
ORDER BY y ASC