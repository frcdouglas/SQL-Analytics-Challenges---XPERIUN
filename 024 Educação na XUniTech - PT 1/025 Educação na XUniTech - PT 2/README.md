# 🎓 Desafio-SQL-024-Educacao-na-XUniTech-PT-2

![SQL](https://img.shields.io/badge/SQL-Analysis-blue)
![Status](https://img.shields.io/badge/status-concluído-success)
![Portfólio](https://img.shields.io/badge/portfolio-data%20analytics-orange)
![Projeto](https://img.shields.io/badge/projeto-business%20insights-purple)

---

## Descrição do Desafio

A XCorp está expandindo seu alcance na Educação e lançou a XUniTech, uma nova iniciativa focada em cursos avançados de tecnologia. Para garantir que essa iniciativa seja bem-sucedida, a área de Educação precisa de uma visão clara e estratégica dos seus indicadores de desempenho.

Como Analista de Dados, sua missão é ajudar a XUniTech a transformar dados brutos em insights práticos, contribuindo para a tomada de decisões informadas e o sucesso do programa.

---

## 1) Quais cursos ainda não tiveram matrículas?

O compromisso da XCorp com educação é uma premissa em todas as suas iniciativas. A equipe de gestão da XUniTech quer saber quais os cursos que não tiveram matrículas ainda.

```sql
SELECT
    c.titulo AS curso_titulo,
    COUNT(m.matricula_id) AS matriculas
FROM Cursos c
LEFT JOIN Matriculas m 
    ON m.curso_id = c.curso_id
GROUP BY c.curso_id, c.titulo
HAVING COUNT(m.matricula_id) = 0
ORDER BY c.titulo DESC;
```

---

## 2) Quais alunos estão matriculados em cursos com feedbacks altos?

A área de gestão da XUniTech deseja continuar investindo na qualidade dos cursos e, para isso, entender o feedback dos alunos matriculados é fundamental.

Você vai precisar dar um apoio ao setor administrativo que quer saber quais alunos (**nome e e-mail**) estão matriculados em cursos que receberam uma **média de feedbacks maior ou igual a 3**.

### Duas formas de escrever:

### Primeira forma

```sql
WITH cursos_bem_avaliados AS (
    SELECT
        c.curso_id
    FROM Feedbacks f
    LEFT JOIN Cursos c 
        ON c.curso_id = f.curso_id
    GROUP BY c.curso_id
    HAVING AVG(f.nota) >= 3
)

SELECT
    a.nome,
    a.email,
    c.titulo AS curso_titulo
FROM Alunos a
LEFT JOIN Matriculas m 
    ON m.aluno_id = a.aluno_id
LEFT JOIN Cursos c 
    ON c.curso_id = m.curso_id
WHERE c.curso_id IN (
    SELECT curso_id FROM cursos_bem_avaliados
);
```

### Segunda forma

```sql
SELECT 
    a.nome, 
    a.email, 
    c.titulo AS curso_titulo
FROM Cursos c
INNER JOIN Matriculas m 
    ON m.curso_id = c.curso_id
INNER JOIN Alunos a 
    ON a.aluno_id = m.aluno_id
WHERE EXISTS (
    SELECT 1 
    FROM Feedbacks f 
    WHERE f.curso_id = c.curso_id
    GROUP BY f.curso_id
    HAVING AVG(f.nota) >= 3
);
```

> Podemos ver que existem diferentes formas de se obter o mesmo resultado. O importante no final sempre vai ser o resultado, mas em grande escala a **performance** também é um ponto muito importante. Por isso, é sempre bom entender como melhorar a performance das consultas mesmo em casos mais simples como este.

---

## 3) Quais cursos receberam feedbacks positivos?

A coordenação acadêmica deseja saber quais cursos têm pelo menos um aluno que deu feedback com nota alta (**entre 4 e 5**), para reconhecer a excelência do ensino.

Você vai precisar ajudar na geração dessa listagem de cursos, com o objetivo de entender ainda mais profundamente o desempenho dos alunos nos cursos.

Feedbacks positivos são uma ótima forma de metrificar a qualidade do material gerado e toda a estrutura montada para o aproveitamento dos alunos.

A consulta deve fornecer uma lista de cursos que receberam feedbacks positivos (**nota entre 4 e 5**), além de informações sobre:

- o **total de feedbacks**
- a **média das notas**

Isso pode ajudar a coordenação acadêmica a entender melhor o desempenho dos alunos e a qualidade do material e das aulas.

```sql
SELECT
    c.titulo,
    ROUND(AVG(f.nota), 2) AS media_nota,
    COUNT(f.feedback_id) AS total_alunos_feedbacks
FROM Feedbacks f
JOIN Cursos c 
    ON c.curso_id = f.curso_id
WHERE f.nota >= 4
GROUP BY c.titulo
ORDER BY c.titulo;
```

> Aqui temos que ter cuidado porque a coordenação solicitou a **média apenas das notas iguais ou maiores que 4**, então o filtro precisa ser realizado **antes da agregação**, no `WHERE`.

### Outra forma de escrever

```sql
SELECT 
    c.titulo,
    f_stats.media_nota,
    f_stats.total_alunos_feedbacks
FROM (
    SELECT 
        curso_id,
        ROUND(AVG(nota), 2) AS media_nota,
        COUNT(feedback_id) AS total_alunos_feedbacks
    FROM Feedbacks
    WHERE nota >= 4
    GROUP BY curso_id
) f_stats
INNER JOIN Cursos c 
    ON c.curso_id = f_stats.curso_id
ORDER BY c.titulo;
```

---

## 4) Visão geral dos cursos com feedbacks e matrículas

A melhoria contínua é algo fundamental em organizações que visam o crescimento. Para a XCorp, qualidade é um requisito. E na iniciativa da XUniTech isso não seria diferente.

Sendo assim, o coordenador acadêmico deseja saber quais cursos têm o maior número de aulas para avaliar a profundidade do conteúdo e possíveis ajustes no currículo.

Manter o currículo dos cursos atualizados ajuda, e muito, no desenvolvimento e na qualificação dos alunos. E isso é especialmente importante na área de tecnologia, onde as mudanças são constantes.

Com essa consulta, o coordenador acadêmico terá uma visão mais profunda sobre cada curso, incluindo:

- o **título do curso**
- a **média das notas dos feedbacks**
- o **número total de feedbacks recebidos**
- o **total de matrículas**, que pode indicar a popularidade do curso
- as **datas de início e fim do curso**, que ajudam a contextualizar o planejamento

Isso permitirá uma análise mais abrangente e informada sobre a qualidade do ensino e a eficácia do currículo nos cursos da XUniTech.

```sql
SELECT
    c.titulo,
    ROUND(f.media_nota_feedbacks, 2) AS media_nota_feedbacks,
    COALESCE(f.total_feedbacks, 0) AS total_feedbacks,
    COALESCE(m.total_matriculas, 0) AS total_matriculas,
    c.data_inicio,
    c.data_fim
FROM Cursos c
LEFT JOIN (
    SELECT
        curso_id,
        AVG(nota) AS media_nota_feedbacks,
        COUNT(feedback_id) AS total_feedbacks
    FROM Feedbacks
    GROUP BY curso_id
) f 
    ON f.curso_id = c.curso_id
LEFT JOIN (
    SELECT
        curso_id,
        COUNT(matricula_id) AS total_matriculas
    FROM Matriculas
    GROUP BY curso_id
) m 
    ON m.curso_id = c.curso_id
ORDER BY total_feedbacks DESC;
```

---

## 5) Exemplo de forma incorreta (explicar no vídeo o motivo)

```sql
SELECT
    c.titulo,
    AVG(f.nota) AS media_nota_feedbacks,
    COUNT(f.feedback_id) AS total_feedbacks,
    COUNT(m.matricula_id) AS total_matriculas,
    c.data_inicio,
    c.data_fim
FROM Cursos c 
LEFT JOIN Matriculas m 
    ON m.curso_id = c.curso_id
LEFT JOIN Feedbacks f 
    ON f.curso_id = c.curso_id
GROUP BY c.titulo, c.data_inicio, c.data_fim
ORDER BY total_feedbacks DESC;
```

### Por que essa forma está incorreta?

Essa consulta pode gerar **duplicação de linhas** por causa do relacionamento entre:

- `Cursos`
- `Matriculas`
- `Feedbacks`

Quando um curso possui **várias matrículas** e **vários feedbacks**, o `JOIN` entre essas tabelas multiplica os registros, o que faz com que:

- o `COUNT(f.feedback_id)` fique **inflado**
- o `COUNT(m.matricula_id)` fique **inflado**
- a análise fique **incorreta**

### Exemplo do problema

Se um curso tiver:

- **3 matrículas**
- **2 feedbacks**

Ao fazer o `JOIN` direto, você pode acabar com:

- **3 × 2 = 6 linhas**

Ou seja:

- os **2 feedbacks** podem parecer **6**
- as **3 matrículas** podem parecer **6**

### Forma correta

A forma correta é **agregar primeiro** cada tabela separadamente (`Feedbacks` e `Matriculas`) e **depois** juntar os resultados com `Cursos`, como foi feito na consulta anterior.

---

## Conclusão

Essas consultas ajudam a XUniTech a responder perguntas estratégicas importantes, como:

- quais cursos ainda não atraíram alunos
- quais cursos estão sendo bem avaliados
- quais alunos estão em cursos de boa qualidade
- quais cursos têm maior engajamento e volume de feedback

Além disso, o desafio também mostra um ponto muito importante no dia a dia de quem trabalha com SQL:

> **Nem toda consulta que "roda" está correta.**

Entender **agregações**, **joins** e possíveis **duplicações de registros** é essencial para gerar análises confiáveis e úteis para o negócio.
