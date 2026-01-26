-- =========================================================
-- GABARITO COMPLETO – MODULO 4
-- =========================================================


-- =========================================================
-- EXERCÍCIOS 1–10 | SUBQUERY
-- =========================================================

-- 1) Clientes cujo total gasto é maior que a média
SELECT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(amount) FROM orders
);

-- Comentário:
-- Subquery calcula a média geral
-- HAVING compara o total de cada cliente com essa média


-- 2) Pedidos com valor maior que a média dos pedidos
SELECT *
FROM orders
WHERE amount > (
  SELECT AVG(amount) FROM orders
);


-- 3) Clientes que gastaram menos que a média
SELECT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) < (
  SELECT AVG(amount) FROM orders
);


-- 4) Pedido(s) com o maior valor existente
SELECT *
FROM orders
WHERE amount = (
  SELECT MAX(amount) FROM orders
);


-- 5) Clientes que têm pedidos acima da média
SELECT DISTINCT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > (
  SELECT AVG(amount) FROM orders
);


-- 6) Pedidos feitos no mesmo dia do maior pedido
SELECT *
FROM orders
WHERE order_date = (
  SELECT order_date
  FROM orders
  ORDER BY amount DESC
  LIMIT 1
);


-- 7) Clientes cujo total gasto é menor que o total médio por cliente
SELECT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) < (
  SELECT AVG(total_gasto)
  FROM (
    SELECT SUM(amount) AS total_gasto
    FROM orders
    GROUP BY customer_id
  ) t
);


-- 8) Pedidos cujo valor é menor que a média do próprio cliente
SELECT o.*
FROM orders o
WHERE o.amount < (
  SELECT AVG(o2.amount)
  FROM orders o2
  WHERE o2.customer_id = o.customer_id
);


-- 9) Clientes cujo total gasto é maior que (total geral / número de clientes)
SELECT c.full_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT SUM(amount) / COUNT(DISTINCT customer_id)
  FROM orders
);


-- 10) Pedidos com valor maior que a média dos últimos 30 dias
SELECT *
FROM orders
WHERE amount > (
  SELECT AVG(amount)
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
);


-- =========================================================
-- EXERCÍCIOS 11–25 | CTE (WITH)
-- =========================================================

-- 11) CTE com total gasto por cliente
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT * FROM total_por_cliente;


-- 12) Clientes acima da média (usando CTE)
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM total_por_cliente
WHERE total_gasto > (
  SELECT AVG(total_gasto) FROM total_por_cliente
);


-- 13) CTE com pedidos por status
WITH pedidos_por_status AS (
  SELECT status, COUNT(*) AS total
  FROM orders
  GROUP BY status
)
SELECT * FROM pedidos_por_status;


-- 14) Status com mais de 1 pedido
WITH pedidos_por_status AS (
  SELECT status, COUNT(*) AS total
  FROM orders
  GROUP BY status
)
SELECT *
FROM pedidos_por_status
WHERE total > 1;


-- 15) CTE com pedidos do último mês
WITH pedidos_ultimo_mes AS (
  SELECT *
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT * FROM pedidos_ultimo_mes;


-- 16) Total por cliente a partir da CTE
WITH pedidos_ultimo_mes AS (
  SELECT *
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT customer_id, SUM(amount) AS total
FROM pedidos_ultimo_mes
GROUP BY customer_id;


-- 17) CTE com clientes ativos e seus pedidos
WITH clientes_ativos_pedidos AS (
  SELECT c.customer_id, c.full_name, o.amount
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE c.is_active = true
)
SELECT * FROM clientes_ativos_pedidos;


-- 18) Contar pedidos por cliente ativo
WITH clientes_ativos_pedidos AS (
  SELECT c.customer_id, o.order_id
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  WHERE c.is_active = true
)
SELECT customer_id, COUNT(order_id) AS total_pedidos
FROM clientes_ativos_pedidos
GROUP BY customer_id;


-- 19) Duas CTEs com JOIN
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
),
qtde_por_cliente AS (
  SELECT customer_id, COUNT(*) AS total_pedidos
  FROM orders
  GROUP BY customer_id
)
SELECT t.customer_id, total_gasto, total_pedidos
FROM total_por_cliente t
JOIN qtde_por_cliente q
  ON t.customer_id = q.customer_id;


-- 20) Subquery reescrita como CTE
WITH media_pedidos AS (
  SELECT AVG(amount) AS media FROM orders
)
SELECT *
FROM orders
WHERE amount > (SELECT media FROM media_pedidos);


-- 21) CTE para detectar pedidos inválidos
WITH pedidos_invalidos AS (
  SELECT *
  FROM orders
  WHERE amount <= 0
     OR status NOT IN ('paid','shipped','cancelled')
)
SELECT * FROM pedidos_invalidos;


-- 22) CTE para scorecard de Data Quality
WITH dq AS (
  SELECT 'orders_amount_invalid' AS issue, COUNT(*) AS total
  FROM orders WHERE amount <= 0
)
SELECT * FROM dq;


-- 23) Simplificar relatório complexo com CTE
WITH resumo AS (
  SELECT customer_id, COUNT(*) qtd, SUM(amount) total
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM resumo
WHERE total > 100;


-- 24) (Resposta teórica)
-- CTE organiza lógica intermediária e melhora leitura.


-- 25) Reescrever query longa usando CTE
WITH base AS (
  SELECT * FROM orders WHERE amount > 0
)
SELECT customer_id, SUM(amount)
FROM base
GROUP BY customer_id;


-- =========================================================
-- EXERCÍCIOS 26–40 | UNION / UNION ALL
-- =========================================================

-- 26) Relatório unificado de problemas de Data Quality
SELECT 'amount_invalid' AS issue, COUNT(*) FROM orders WHERE amount <= 0
UNION ALL
SELECT 'status_invalid', COUNT(*) FROM orders WHERE status NOT IN ('paid','shipped','cancelled');


-- 27) Clientes ativos e inativos com flag
SELECT customer_id, 'active' AS status FROM customers WHERE is_active = true
UNION ALL
SELECT customer_id, 'inactive' FROM customers WHERE is_active = false;


-- 28) Pedidos válidos e inválidos
SELECT order_id, 'valid' AS flag FROM orders WHERE amount > 0
UNION ALL
SELECT order_id, 'invalid' FROM orders WHERE amount <= 0;


-- 29) UNION com contagens diferentes
SELECT 'customers' AS tabela, COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;


-- 30) Scorecard usando UNION ALL
SELECT 'orders_future', COUNT(*) FROM orders WHERE order_date > CURRENT_DATE
UNION ALL
SELECT 'orders_no_customer', COUNT(*)
FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 31) Combinar dados em saída padrão
SELECT customer_id, 'customer' AS origem FROM customers
UNION ALL
SELECT customer_id, 'order' FROM orders;


-- 32) UNION como log de eventos
SELECT customer_id, 'created' AS event FROM customers
UNION ALL
SELECT customer_id, 'ordered' FROM orders;


-- 33) Quando NÃO usar UNION
-- Quando você precisa relacionar dados (use JOIN)


-- 34) Relatório com UNION ALL
SELECT 'total_orders', COUNT(*) FROM orders
UNION ALL
SELECT 'total_customers', COUNT(*) FROM customers;


-- 35) Relatório final issue_type / issue_count
SELECT 'orders_invalid', COUNT(*) FROM orders WHERE amount <= 0
UNION ALL
SELECT 'customers_email_null', COUNT(*) FROM customers WHERE email IS NULL;


-- 36) Empilhar métricas
SELECT 'metric_1', 100
UNION ALL
SELECT 'metric_2', 200;


-- 37) Resultados intermediários
SELECT customer_id, SUM(amount) FROM orders GROUP BY customer_id
UNION ALL
SELECT customer_id, COUNT(*) FROM orders GROUP BY customer_id;


-- 38) Relatório executivo
SELECT 'revenue', SUM(amount) FROM orders
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;


-- 39) Agregado + não agregado
SELECT customer_id, SUM(amount) FROM orders GROUP BY customer_id
UNION ALL
SELECT customer_id, amount FROM orders;


-- 40) Diferença entre UNION e JOIN
-- UNION empilha linhas
-- JOIN relaciona colunas
