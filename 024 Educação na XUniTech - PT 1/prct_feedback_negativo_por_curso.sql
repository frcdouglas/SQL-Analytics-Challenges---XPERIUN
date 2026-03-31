SELECT
    c.titulo,
    SUM(CASE WHEN f.nota < 3 THEN 1 ELSE 0 END) AS feedbacks_negativos,
    COUNT(f.feedback_id) AS total_feedbacks,
    ROUND(
        1.0 * SUM(CASE WHEN f.nota < 3 THEN 1 ELSE 0 END) 
        / COUNT(f.feedback_id),
        2
    ) AS percent_feedbacks_negativos
FROM Feedbacks f
LEFT JOIN Cursos c 
    ON c.curso_id = f.curso_id
GROUP BY c.curso_id, c.titulo
HAVING SUM(CASE WHEN f.nota < 3 THEN 1 ELSE 0 END) > 0
ORDER BY percent_feedbacks_negativos DESC;