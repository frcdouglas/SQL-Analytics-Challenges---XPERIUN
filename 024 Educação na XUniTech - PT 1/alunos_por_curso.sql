SELECT 
    c.titulo,
    COUNT(m.matricula_id) AS total_alunos
FROM Cursos c
LEFT JOIN Matriculas m 
    ON c.curso_id = m.curso_id
GROUP BY c.titulo
ORDER BY COUNT(m.matricula_id) DESC;