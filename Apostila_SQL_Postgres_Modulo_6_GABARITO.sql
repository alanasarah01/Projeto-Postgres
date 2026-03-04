-- =========================================================
-- GABARITO – WORKBOOK RACIOCÍNIO ANALÍTICO COM SQL
-- Tópicos: SUBQUERY + CTE (WITH)
-- Banco: PostgreSQL
-- =========================================================
-- Observações do mentor:
-- - Existem múltiplas soluções possíveis. Aqui vai uma versão
--   clara e consistente com boas práticas.
-- - Alguns exercícios podem ser resolvidos com subquery ou CTE;
--   eu priorizei a técnica pedida no enunciado.
-- =========================================================


-- =========================================================
-- BLOCO A — SUBQUERY (1–20)
-- =========================================================

-- 1) Pedidos acima da média (média global de amount)
SELECT *
FROM orders
WHERE amount > (SELECT AVG(amount) FROM orders);

-- 2) Pedidos abaixo da média (média global de amount)
SELECT *
FROM orders
WHERE amount < (SELECT AVG(amount) FROM orders);

-- 3) Pedidos iguais ao maior valor de amount
SELECT *
FROM orders
WHERE amount = (SELECT MAX(amount) FROM orders);

-- 4) Pedidos iguais ao menor valor de amount
SELECT *
FROM orders
WHERE amount = (SELECT MIN(amount) FROM orders);

-- 5) Clientes (full_name) com pelo menos 1 pedido acima da média global
SELECT DISTINCT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > (SELECT AVG(amount) FROM orders);

-- 6) Pedidos com amount maior que a média do mês atual
SELECT *
FROM orders
WHERE date_trunc('month', order_date) = date_trunc('month', CURRENT_DATE)
  AND amount > (
    SELECT AVG(o2.amount)
    FROM orders o2
    WHERE date_trunc('month', o2.order_date) = date_trunc('month', CURRENT_DATE)
  );

-- 7) Pedidos com amount maior que a média do próprio cliente (correlacionada)
SELECT o.*
FROM orders o
WHERE o.amount > (
  SELECT AVG(o2.amount)
  FROM orders o2
  WHERE o2.customer_id = o.customer_id
);

-- 8) Clientes cujo TOTAL gasto é maior que a média global de amount
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (SELECT AVG(amount) FROM orders);

-- 9) Pedidos com amount maior que a média dos últimos 30 dias
SELECT *
FROM orders
WHERE amount > (
  SELECT AVG(amount)
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
);

-- 10) Clientes cujo TOTAL gasto é maior que o MAIOR pedido da tabela
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (SELECT MAX(amount) FROM orders);

-- 11) Pedidos com amount maior que a média do próprio DIA (correlacionada por order_date)
SELECT o.*
FROM orders o
WHERE o.amount > (
  SELECT AVG(o2.amount)
  FROM orders o2
  WHERE o2.order_date = o.order_date
);

-- 12) Pedidos com amount menor que a média do próprio cliente
SELECT o.*
FROM orders o
WHERE o.amount < (
  SELECT AVG(o2.amount)
  FROM orders o2
  WHERE o2.customer_id = o.customer_id
);

-- 13) Clientes cujo TOTAL gasto é menor que a média global de amount
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) < (SELECT AVG(amount) FROM orders);

-- 14) Pedidos que são o MAIOR pedido de cada cliente
SELECT o.*
FROM orders o
WHERE o.amount = (
  SELECT MAX(o2.amount)
  FROM orders o2
  WHERE o2.customer_id = o.customer_id
);

-- 15) Clientes cujo TOTAL gasto é maior que a média do TOTAL gasto por cliente
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(total_gasto)
  FROM (
    SELECT customer_id, SUM(amount) AS total_gasto
    FROM orders
    GROUP BY customer_id
  ) t
);

-- 16) Pedidos com amount maior que a média de pedidos APENAS de clientes ativos
SELECT o.*
FROM orders o
WHERE o.amount > (
  SELECT AVG(o2.amount)
  FROM orders o2
  JOIN customers c2
    ON c2.customer_id = o2.customer_id
  WHERE c2.is_active = true
);

-- 17) Pedidos com amount maior que o MAIOR pedido de ontem
SELECT *
FROM orders
WHERE amount > (
  SELECT MAX(amount)
  FROM orders
  WHERE order_date = CURRENT_DATE - INTERVAL '1 day'
);

-- 18) Clientes cujo TOTAL gasto é maior que a média do TOTAL gasto de clientes ativos
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(total_gasto)
  FROM (
    SELECT o2.customer_id, SUM(o2.amount) AS total_gasto
    FROM orders o2
    JOIN customers c2
      ON c2.customer_id = o2.customer_id
    WHERE c2.is_active = true
    GROUP BY o2.customer_id
  ) t
);

-- 19) Pedidos com amount maior que o MENOR pedido do próprio cliente
SELECT o.*
FROM orders o
WHERE o.amount > (
  SELECT MIN(o2.amount)
  FROM orders o2
  WHERE o2.customer_id = o.customer_id
);

-- 20) Clientes cujo TOTAL gasto é maior que (total geral / número de clientes com pedidos)
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT SUM(amount) / COUNT(DISTINCT customer_id)
  FROM orders
);


-- =========================================================
-- BLOCO B — CTE (21–40)
-- =========================================================

-- 21) CTE total_por_cliente e selecionar tudo
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM total_por_cliente
ORDER BY customer_id;

-- 22) Clientes com total_gasto > 200 (usando a CTE)
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM total_por_cliente
WHERE total_gasto > 200
ORDER BY total_gasto DESC;

-- 23) CTE pedidos_por_status
WITH pedidos_por_status AS (
  SELECT status, COUNT(*) AS total_pedidos
  FROM orders
  GROUP BY status
)
SELECT *
FROM pedidos_por_status
ORDER BY total_pedidos DESC, status;

-- 24) Status com total_pedidos > 3
WITH pedidos_por_status AS (
  SELECT status, COUNT(*) AS total_pedidos
  FROM orders
  GROUP BY status
)
SELECT *
FROM pedidos_por_status
WHERE total_pedidos > 3
ORDER BY total_pedidos DESC;

-- 25) CTE pedidos_ultimo_mes (últimos 30 dias)
WITH pedidos_ultimo_mes AS (
  SELECT *
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT *
FROM pedidos_ultimo_mes
ORDER BY order_date DESC, order_id DESC;

-- 26) Total gasto por cliente a partir da CTE pedidos_ultimo_mes
WITH pedidos_ultimo_mes AS (
  SELECT *
  FROM orders
  WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT customer_id, SUM(amount) AS total_gasto_30d
FROM pedidos_ultimo_mes
GROUP BY customer_id
ORDER BY total_gasto_30d DESC;

-- 27) CTE clientes_ativos
WITH clientes_ativos AS (
  SELECT customer_id, full_name
  FROM customers
  WHERE is_active = true
)
SELECT *
FROM clientes_ativos
ORDER BY customer_id;

-- 28) Clientes ativos + orders: full_name, order_id, amount, order_date
WITH clientes_ativos AS (
  SELECT customer_id, full_name
  FROM customers
  WHERE is_active = true
)
SELECT
  ca.full_name,
  o.order_id,
  o.amount,
  o.order_date
FROM clientes_ativos ca
JOIN orders o
  ON o.customer_id = ca.customer_id
ORDER BY ca.full_name, o.order_date, o.order_id;

-- 29) Total gasto por cliente ativo (full_name)
WITH clientes_ativos AS (
  SELECT customer_id, full_name
  FROM customers
  WHERE is_active = true
),
pedidos_ativos AS (
  SELECT ca.full_name, o.amount
  FROM clientes_ativos ca
  JOIN orders o
    ON o.customer_id = ca.customer_id
)
SELECT full_name, SUM(amount) AS total_gasto
FROM pedidos_ativos
GROUP BY full_name
ORDER BY total_gasto DESC;

-- 30) CTE pedidos_invalidos
WITH pedidos_invalidos AS (
  SELECT *
  FROM orders
  WHERE amount <= 0
     OR status NOT IN ('paid','shipped','cancelled')
)
SELECT *
FROM pedidos_invalidos
ORDER BY order_id;

-- 31) Contar pedidos inválidos (usando pedidos_invalidos)
WITH pedidos_invalidos AS (
  SELECT *
  FROM orders
  WHERE amount <= 0
     OR status NOT IN ('paid','shipped','cancelled')
)
SELECT COUNT(*) AS total_invalidos
FROM pedidos_invalidos;

-- 32) CTE pedidos_futuros
WITH pedidos_futuros AS (
  SELECT *
  FROM orders
  WHERE order_date > CURRENT_DATE
)
SELECT *
FROM pedidos_futuros
ORDER BY order_date, order_id;

-- 33) Contar pedidos no futuro
WITH pedidos_futuros AS (
  SELECT *
  FROM orders
  WHERE order_date > CURRENT_DATE
)
SELECT COUNT(*) AS total_pedidos_futuros
FROM pedidos_futuros;

-- 34) CTE duplicados_logicos (chaves repetidas) + qtd
WITH duplicados_logicos AS (
  SELECT
    customer_id,
    order_date,
    amount,
    status,
    payment_method,
    COUNT(*) AS qtd
  FROM orders
  GROUP BY customer_id, order_date, amount, status, payment_method
  HAVING COUNT(*) > 1
)
SELECT *
FROM duplicados_logicos
ORDER BY qtd DESC;

-- 35) Listar linhas completas de orders pertencentes a duplicados_logicos
WITH duplicados_logicos AS (
  SELECT
    customer_id,
    order_date,
    amount,
    status,
    payment_method
  FROM orders
  GROUP BY customer_id, order_date, amount, status, payment_method
  HAVING COUNT(*) > 1
)
SELECT o.*
FROM orders o
JOIN duplicados_logicos d
  ON o.customer_id = d.customer_id
 AND o.order_date = d.order_date
 AND o.amount = d.amount
 AND o.status = d.status
 AND (
      (o.payment_method = d.payment_method)
      OR (o.payment_method IS NULL AND d.payment_method IS NULL)
 )
ORDER BY o.order_id;

-- 36) CTE pedidos_por_dia
WITH pedidos_por_dia AS (
  SELECT order_date, COUNT(*) AS total_pedidos
  FROM orders
  GROUP BY order_date
)
SELECT *
FROM pedidos_por_dia
ORDER BY order_date;

-- 37) Dias com total_pedidos >= 2
WITH pedidos_por_dia AS (
  SELECT order_date, COUNT(*) AS total_pedidos
  FROM orders
  GROUP BY order_date
)
SELECT *
FROM pedidos_por_dia
WHERE total_pedidos >= 2
ORDER BY total_pedidos DESC, order_date;

-- 38) Duas CTEs (SUM e COUNT) e JOIN
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
SELECT
  t.customer_id,
  t.total_gasto,
  q.total_pedidos
FROM total_por_cliente t
JOIN qtde_por_cliente q
  ON t.customer_id = q.customer_id
ORDER BY t.total_gasto DESC;

-- 39) CTE total_por_cliente com full_name e ordenar por total
WITH total_por_cliente AS (
  SELECT
    c.full_name,
    SUM(o.amount) AS total_gasto
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM total_por_cliente
ORDER BY total_gasto DESC;

-- 40) CTE resumo_cliente (pedidos, total, ticket_medio)
WITH resumo_cliente AS (
  SELECT
    c.full_name,
    COUNT(o.order_id) AS total_pedidos,
    SUM(o.amount) AS total_gasto,
    SUM(o.amount) / NULLIF(COUNT(o.order_id), 0)::numeric AS ticket_medio
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM resumo_cliente
ORDER BY total_gasto DESC;


-- =========================================================
-- BLOCO C — DESAFIOS (41–50)
-- =========================================================

-- 41) Cliente que mais gastou (top 1) usando CTE
WITH total_por_cliente AS (
  SELECT c.full_name, SUM(o.amount) AS total_gasto
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM total_por_cliente
ORDER BY total_gasto DESC
LIMIT 1;

-- 42) TOP 3 clientes que mais gastaram usando CTE
WITH total_por_cliente AS (
  SELECT c.full_name, SUM(o.amount) AS total_gasto
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM total_por_cliente
ORDER BY total_gasto DESC
LIMIT 3;

-- 43) Cliente com mais pedidos usando CTE
WITH pedidos_por_cliente AS (
  SELECT c.full_name, COUNT(o.order_id) AS total_pedidos
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM pedidos_por_cliente
ORDER BY total_pedidos DESC
LIMIT 1;

-- 44) Cliente com menor gasto (apenas quem tem pedidos)
WITH total_por_cliente AS (
  SELECT c.full_name, SUM(o.amount) AS total_gasto
  FROM customers c
  JOIN orders o
    ON o.customer_id = c.customer_id
  GROUP BY c.full_name
)
SELECT *
FROM total_por_cliente
ORDER BY total_gasto ASC
LIMIT 1;

-- 45) Média de gasto por cliente (média do total gasto por cliente)
WITH total_por_cliente AS (
  SELECT customer_id, SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT AVG(total_gasto) AS media_gasto_por_cliente
FROM total_por_cliente;

-- 46) Total de pedidos por mês
SELECT date_trunc('month', order_date) AS mes, COUNT(*) AS total_pedidos
FROM orders
GROUP BY date_trunc('month', order_date)
ORDER BY mes;

-- 47) Mês com maior faturamento e o valor
WITH faturamento_por_mes AS (
  SELECT date_trunc('month', order_date) AS mes, SUM(amount) AS faturamento
  FROM orders
  GROUP BY date_trunc('month', order_date)
)
SELECT *
FROM faturamento_por_mes
ORDER BY faturamento DESC
LIMIT 1;

-- 48) Clientes que nunca fizeram pedidos
SELECT c.*
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

-- 49) Clientes ativos sem pedidos
SELECT c.*
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
WHERE c.is_active = true
  AND o.order_id IS NULL
ORDER BY c.customer_id;

-- 50) Relatório final (1 linha por cliente) incluindo sem pedidos
-- full_name, total_pedidos, total_gasto, ticket_medio
SELECT
  c.full_name,
  COUNT(o.order_id) AS total_pedidos,
  COALESCE(SUM(o.amount), 0) AS total_gasto,
  CASE
    WHEN COUNT(o.order_id) = 0 THEN 0
    ELSE (COALESCE(SUM(o.amount), 0) / COUNT(o.order_id)::numeric)
  END AS ticket_medio
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_gasto DESC, c.full_name;