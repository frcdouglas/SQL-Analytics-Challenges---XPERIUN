# 🎓 Desafio SQL 024 — Xperiun | Educação na XUniTech

![SQL](https://img.shields.io/badge/SQL-Analysis-blue)
![Status](https://img.shields.io/badge/status-concluído-success)
![Portfólio](https://img.shields.io/badge/portfolio-data%20analytics-orange)
![Projeto](https://img.shields.io/badge/projeto-business%20insights-purple)

---

## 📌 Sobre o projeto

A **XCorp** está expandindo sua atuação na área de Educação com o lançamento da **XUniTech**, uma iniciativa voltada para cursos avançados de tecnologia.

Neste desafio, o objetivo é utilizar **SQL** para transformar dados brutos em **insights estratégicos**, apoiando a área de Educação na análise de desempenho da nova plataforma.

Este projeto simula situações reais de negócio, como:

- análise de matrículas;
- avaliação da qualidade dos cursos;
- identificação de feedbacks negativos;
- reconhecimento de alunos mais satisfeitos.

---

## 🎯 Objetivo

A proposta deste desafio é responder perguntas de negócio relevantes para a área de Educação da **XUniTech**, utilizando consultas SQL para gerar informações que apoiem a tomada de decisão.

As análises foram desenvolvidas com foco em:

- **demanda por cursos**;
- **qualidade percebida pelos alunos**;
- **monitoramento da satisfação**;
- **identificação de padrões de comportamento**.

---

## 🗂️ Estrutura das tabelas

### **Alunos**
| Coluna | Descrição |
|---|---|
| `aluno_id` | Identificador do aluno |
| `nome` | Nome do aluno |
| `email` | E-mail do aluno |
| `data_criacao` | Data de cadastro |

### **Cursos**
| Coluna | Descrição |
|---|---|
| `curso_id` | Identificador do curso |
| `titulo` | Título do curso |
| `descricao` | Descrição do curso |
| `data_inicio` | Data de início |
| `data_fim` | Data de término |

### **Matriculas**
| Coluna | Descrição |
|---|---|
| `matricula_id` | Identificador da matrícula |
| `aluno_id` | ID do aluno |
| `curso_id` | ID do curso |
| `data_matricula` | Data da matrícula |

### **Aulas**
| Coluna | Descrição |
|---|---|
| `aula_id` | Identificador da aula |
| `curso_id` | ID do curso |
| `titulo` | Título da aula |
| `descricao` | Descrição da aula |
| `data_publicacao` | Data de publicação |

### **Feedbacks**
| Coluna | Descrição |
|---|---|
| `feedback_id` | Identificador do feedback |
| `aluno_id` | ID do aluno |
| `curso_id` | ID do curso |
| `comentario` | Comentário do aluno |
| `nota` | Nota atribuída ao curso |

---

## 🧠 Estratégia analítica

As consultas foram construídas para responder perguntas-chave relacionadas ao desempenho da plataforma educacional.

Ao longo do desafio, foram utilizados conceitos importantes de SQL, como:

- junções entre tabelas;
- agregações;
- ordenações;
- filtros condicionais;
- subqueries;
- métricas percentuais.

A proposta foi transformar dados operacionais em **informações úteis para o negócio**.

---

# 📊 Análises realizadas

---

## 1️⃣ Total de alunos matriculados por curso

### 🎯 Pergunta de negócio
Quantos alunos estão matriculados em cada curso?

### 📌 Objetivo da análise
Entender melhor a **demanda por cada área de estudo** e identificar cursos com maior ou menor adesão.

### 🧠 Lógica aplicada
Foi utilizado um `LEFT JOIN` entre **Cursos** e **Matriculas** para garantir que **todos os cursos apareçam no resultado**, inclusive aqueles que ainda **não possuem matrículas**.

### 💻 Query SQL

```sql
SELECT 
    c.titulo,
    COUNT(m.matricula_id) AS total_alunos
FROM Cursos c
LEFT JOIN Matriculas m 
    ON c.curso_id = m.curso_id
GROUP BY c.titulo
ORDER BY COUNT(m.matricula_id) DESC;
```
---

## 2️⃣ Média de notas por curso

### 🎯 Pergunta de negócio

**Qual é a média das notas atribuídas pelos alunos em cada curso?**

### 📌 Objetivo da análise

Avaliar a **qualidade percebida do ensino** com base nas notas dadas pelos alunos.

### 🧠 Lógica aplicada

Foi utilizada a função `AVG()` para calcular a média das notas e `ROUND()` para limitar o resultado a **2 casas decimais**.

### 💻 Query SQL

```sql
SELECT
    c.titulo,
    ROUND(AVG(f.nota), 2) AS media_nota
FROM Feedbacks f
LEFT JOIN Cursos c 
    ON f.curso_id = c.curso_id
GROUP BY c.titulo
ORDER BY media_nota DESC;
```

### 📈 Insight de negócio

Essa análise permite:

- comparar a performance dos cursos;
- identificar cursos mais bem avaliados;
- detectar conteúdos com melhor aceitação;
- apoiar decisões sobre melhorias didáticas e pedagógicas.

---

## 3️⃣ Percentual de feedbacks negativos por curso

### 🎯 Pergunta de negócio

**Quais cursos receberam feedbacks negativos e qual o percentual dessas avaliações?**

### 📌 Objetivo da análise

Identificar cursos com maior nível de **insatisfação**, considerando como feedback negativo as avaliações com **nota menor que 3**.

### 🧠 Lógica aplicada

A query utiliza:

- `CASE WHEN` para classificar feedbacks negativos;
- `COUNT()` para calcular o total de feedbacks;
- `SUM()` para contar as avaliações negativas;
- `HAVING` para filtrar apenas cursos com pelo menos **1 feedback negativo**.

### 💻 Query SQL

```sql
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
```

### 📈 Insight de negócio

Essa análise ajuda a:

- localizar cursos com maior índice de insatisfação;
- priorizar ações do time de qualidade;
- investigar problemas de conteúdo, didática ou experiência do aluno;
- monitorar a reputação dos cursos.

### 📝 Observação

Alguns cursos não tiveram avaliações negativas.  
Por isso, foi utilizado o `HAVING`, que permite filtrar os dados **após a agregação**.

---

## 4️⃣ Alunos com média de avaliação acima da média geral

### 🎯 Pergunta de negócio

**Quais alunos possuem média de avaliação acima da média geral da plataforma?**

### 📌 Objetivo da análise

Identificar alunos mais satisfeitos com os cursos da plataforma, permitindo comparações com perfis menos satisfeitos.

### 🧠 Lógica aplicada

Foi utilizada uma **subquery** para calcular a média geral das notas e compará-la com a média individual de cada aluno.

### 💻 Query SQL

```sql
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
```

### 📈 Insight de negócio

Essa análise permite:

- identificar alunos mais satisfeitos;
- mapear perfis com percepção mais positiva;
- apoiar ações de retenção, relacionamento e engajamento.

### 📝 Observação

Aqui foi utilizada uma **subquery** para retornar o valor da média geral de feedbacks da plataforma.

---

## 🛠️ Conceitos SQL aplicados

Durante este desafio, foram utilizados os seguintes recursos:

- `SELECT`
- `LEFT JOIN`
- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `COUNT()`
- `AVG()`
- `ROUND()`
- `SUM()`
- `CASE WHEN`
- `HAVING`
- `Subqueries`

---

## 📌 Principais aprendizados

Este desafio permitiu praticar habilidades essenciais em análise de dados com SQL, como:

- transformar perguntas de negócio em consultas;
- trabalhar com relacionamentos entre tabelas;
- aplicar funções de agregação;
- interpretar indicadores de desempenho;
- gerar insights com foco em tomada de decisão.

Além da parte técnica, o exercício também reforça a importância de analisar dados com uma visão de **produto**, **qualidade** e **experiência do usuário**.
