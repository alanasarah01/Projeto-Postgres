# SQL Operators – Complete Reference

Este documento reúne os principais **operadores SQL**, organizados por categoria, com exemplos práticos.
Compatível com PostgreSQL, MySQL, SQL Server, Snowflake e Oracle (salvo observações).

---

## 1️ - Operadores Aritméticos

Usados para cálculos numéricos.

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `+` | Soma | `salary + bonus` |
| `-` | Subtração | `revenue - cost` |
| `*` | Multiplicação | `price * quantity` |
| `/` | Divisão | `total / users` |
| `%` | Módulo (resto da divisão) | `id % 2` |

---

## 2️ - Operadores de Comparação

Usados principalmente em `WHERE`, `JOIN` e `CASE`.

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `=` | Igual | `status = 'ACTIVE'` |
| `!=` ou `<>` | Diferente | `country <> 'BR'` |
| `>` | Maior que | `age > 18` |
| `<` | Menor que | `score < 50` |
| `>=` | Maior ou igual | `price >= 100` |
| `<=` | Menor ou igual | `quantity <= 10` |

---

## 3️ - Operadores Lógicos

Combinam múltiplas condições.

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `AND` | Todas as condições verdadeiras | `age > 18 AND active = true` |
| `OR` | Pelo menos uma condição verdadeira | `country = 'BR' OR country = 'US'` |
| `NOT` | Negação | `NOT status = 'CANCELLED'` |

---

## 4️ - Operadores de Intervalo e Conjunto

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `IN` | Está dentro de um conjunto | `id IN (1,2,3)` |
| `NOT IN` | Não está no conjunto | `status NOT IN ('A','B')` |
| `BETWEEN` | Intervalo inclusivo | `date BETWEEN '2024-01-01' AND '2024-12-31'` |
| `NOT BETWEEN` | Fora do intervalo | `price NOT BETWEEN 10 AND 50` |

---

## 5️ - Operadores de Nulos

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `IS NULL` | Valor nulo | `deleted_at IS NULL` |
| `IS NOT NULL` | Valor não nulo | `email IS NOT NULL` |

---

## 6️ - Operadores de String

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `LIKE` | Correspondência por padrão | `name LIKE 'Ana%'` |
| `NOT LIKE` | Não corresponde ao padrão | `email NOT LIKE '%@gmail.com'` |
| `||` | Concatenação (ANSI / PostgreSQL / Snowflake) | `first_name || ' ' || last_name` |
| `+` | Concatenação (SQL Server) | `first_name + ' ' + last_name` |

---

## 7️ - Operadores de Padrão Avançado (Regex)

| Operador | Banco | Descrição | Exemplo |
|--------|------|----------|--------|
| `SIMILAR TO` | PostgreSQL | Padrão tipo regex | `name SIMILAR TO '(Ana|João)%'` |
| `~` | PostgreSQL | Regex case-sensitive | `name ~ '^A'` |
| `~*` | PostgreSQL | Regex case-insensitive | `name ~* 'ana'` |
| `REGEXP_LIKE()` | Oracle / Snowflake | Regex | `REGEXP_LIKE(email, 'gmail')` |

---

## 8️ - Operadores Condicionais

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `CASE WHEN` | Lógica condicional | `CASE WHEN score > 90 THEN 'A' END` |
| `COALESCE` | Primeiro valor não nulo | `COALESCE(phone, mobile)` |
| `NULLIF` | Retorna NULL se valores forem iguais | `NULLIF(a, b)` |

---

## 9️ - Operadores de Agregação

Usados com `GROUP BY`.

| Função | Descrição | Exemplo |
|------|----------|--------|
| `COUNT()` | Contagem | `COUNT(*)` |
| `SUM()` | Soma | `SUM(amount)` |
| `AVG()` | Média | `AVG(score)` |
| `MIN()` | Mínimo | `MIN(price)` |
| `MAX()` | Máximo | `MAX(date)` |

---

## 10 - Operadores de Ordenação e Limite

| Operador | Descrição | Exemplo |
|--------|----------|--------|
| `ORDER BY` | Ordenação | `ORDER BY created_at DESC` |
| `LIMIT` | Limita linhas | `LIMIT 10` |
| `OFFSET` | Pula linhas | `OFFSET 20` |
| `FETCH FIRST` | Padrão ANSI SQL | `FETCH FIRST 10 ROWS ONLY` |

---

## 1️1 - Operadores de Junção (JOIN)

| Tipo | Descrição |
|----|----------|
| `INNER JOIN` | Apenas registros correspondentes |
| `LEFT JOIN` | Todos da esquerda |
| `RIGHT JOIN` | Todos da direita |
| `FULL JOIN` | Todos os registros |
| `CROSS JOIN` | Produto cartesiano |

---

## 1️2 - Operadores de Conjunto (Set Operators)

| Operador | Descrição |
|--------|----------|
| `UNION` | Junta removendo duplicados |
| `UNION ALL` | Junta mantendo duplicados |
| `INTERSECT` | Apenas registros comuns |
| `EXCEPT` / `MINUS` | Diferença entre conjuntos |

---

📌 **Dica:** nem todos os bancos suportam todos os operadores. Sempre consulte a documentação do SGBD específico.
