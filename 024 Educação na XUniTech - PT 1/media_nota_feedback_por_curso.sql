SELECT
    c.titulo,
    ROUND(AVG(f.nota), 2) AS media_nota
FROM Feedbacks f
LEFT JOIN Cursos c 
    ON f.curso_id = c.curso_id
GROUP BY c.titulo
ORDER BY media_nota DESC;