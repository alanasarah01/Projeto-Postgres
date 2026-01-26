-- =========================================================
-- GABARITO COMENTADO – MÓDULO 3
-- =========================================================


-- =========================================================
-- TESTE 1
-- Traga clientes que NÃO têm pedidos
-- =========================================================

SELECT c.full_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- EXPLICAÇÃO:
-- LEFT JOIN mantém todos os clientes
-- Quando não há pedido, colunas de orders ficam NULL
-- Filtrar por o.order_id IS NULL retorna apenas quem não tem pedido


-- =========================================================
-- TESTE 2
-- Traga clientes com mais de 3 pedidos
-- =========================================================

SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING COUNT(o.order_id) > 3;

-- EXPLICAÇÃO:
-- GROUP BY agrupa por cliente
-- COUNT conta pedidos por cliente
-- HAVING filtra após agregação


-- =========================================================
-- TESTE 3
-- Traga o cliente que mais gastou
-- =========================================================

SELECT c.full_name, SUM(o.amount) AS total_gasto
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_gasto DESC
LIMIT 1;

-- EXPLICAÇÃO:
-- Soma os valores por cliente
-- ORDER BY DESC traz o maior primeiro
-- LIMIT 1 retorna apenas o top 1


-- =========================================================
-- TESTE 4
-- Traga clientes cujo total gasto é maior que a média
-- =========================================================

SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(amount)
  FROM orders
);

-- EXPLICAÇÃO:
-- Subquery calcula média geral de gastos
-- HAVING compara o total do cliente com essa média


-- =========================================================
-- TESTE 5
-- Traga quantidade de pedidos por status,
-- ordenando do maior para o menor
-- =========================================================

SELECT status, COUNT(*) AS total_pedidos
FROM orders
GROUP BY status
ORDER BY total_pedidos DESC;

-- EXPLICAÇÃO:
-- GROUP BY status agrupa pedidos
-- COUNT conta pedidos por grupo
-- ORDER BY ordena resultado final


-- =========================================================
-- ACHE O ERRO – GABARITO COMENTADO
-- =========================================================

-- ERRO 1
SELECT customer_id, amount, SUM(amount)
FROM orders
GROUP BY customer_id;

-- PROBLEMA:
-- amount não está agregado nem no GROUP BY

-- CORRETO:
SELECT customer_id, SUM(amount)
FROM orders
GROUP BY customer_id;


-- =========================================================

-- ERRO 2
SELECT *
FROM customers
WHERE email = NULL;

-- PROBLEMA:
-- NULL não se compara com '='

-- CORRETO:
SELECT *
FROM customers
WHERE email IS NULL;


-- =========================================================

-- ERRO 3
SELECT c.full_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > 50;

-- PROBLEMA:
-- WHERE filtra após o JOIN
-- Isso transforma LEFT JOIN em INNER JOIN

-- CORRETO:
SELECT c.full_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
 AND o.amount > 50;


-- =========================================================

-- ERRO 4
SELECT COUNT(status)
FROM orders;

-- PERGUNTA:
-- Essa query conta o quê?

-- RESPOSTA:
-- Conta apenas linhas onde status NÃO é NULL
-- Não conta todas as linhas

-- Se a intenção for contar pedidos:
SELECT COUNT(*)
FROM orders;


-- =========================================================
-- COMO RESPONDER ISSO EM ENTREVISTA (FALA IDEAL)
-- =========================================================
-- "COUNT(coluna) ignora NULL, então uso quando isso é intencional.
-- Caso contrário, uso COUNT(*) para contar linhas."
