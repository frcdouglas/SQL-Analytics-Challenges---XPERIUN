SELECT
    a.nome,
    a.email
FROM Alunos a
JOIN Feedbacks f 
    ON a.aluno_id = f.aluno_id
GROUP BY a.aluno_id, a.nome, a.email
HAVING AVG(f.nota) > (
    SELECT AVG(nota)
    FROM Feedbacks
);