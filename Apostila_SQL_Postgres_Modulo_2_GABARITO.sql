-- =========================================================
-- GABARITO OFICIAL – MÓDULO 2
-- =========================================================


-- ======================
-- BLOCO A – COUNT (1–15)
-- ======================

-- 1) Conte quantos pedidos existem na tabela orders
SELECT COUNT(*)
FROM orders;

-- 2) Conte quantos clientes existem
SELECT COUNT(*)
FROM customers;

-- 3) Conte quantos pedidos cada cliente fez
SELECT customer_id, COUNT(*) AS total_pedidos
FROM orders
GROUP BY customer_id;

-- 4) Conte quantos pedidos existem por status
SELECT status, COUNT(*) AS total_pedidos
FROM orders
GROUP BY status;

-- 5) Conte quantos pedidos existem por cliente e status
SELECT customer_id, status, COUNT(*) AS total
FROM orders
GROUP BY customer_id, status;

-- 6) Conte quantos pedidos têm payment_method preenchido
SELECT COUNT(payment_method)
FROM orders;

-- 7) Conte quantos pedidos têm payment_method NULL
SELECT COUNT(*)
FROM orders
WHERE payment_method IS NULL;

-- 8) Conte quantos clientes estão ativos
SELECT COUNT(*)
FROM customers
WHERE is_active = true;

-- 9) Conte quantos clientes estão inativos
SELECT COUNT(*)
FROM customers
WHERE is_active = false;

-- 10) Conte quantos clientes têm email preenchido
SELECT COUNT(*)
FROM customers
WHERE email IS NOT NULL;

-- 11) Conte quantos pedidos cada cliente ativo fez
SELECT c.customer_id, COUNT(o.order_id) AS total_pedidos
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
GROUP BY c.customer_id;

-- 12) Conte quantos pedidos existem com valor maior que 100
SELECT COUNT(*)
FROM orders
WHERE amount > 100;

-- 13) Conte quantos pedidos existem por dia
SELECT order_date, COUNT(*) AS total
FROM orders
GROUP BY order_date;

-- 14) Conte quantos pedidos cada cliente fez apenas com status 'paid'
SELECT customer_id, COUNT(*) AS total
FROM orders
WHERE status = 'paid'
GROUP BY customer_id;

-- 15) Conte quantos clientes fizeram pelo menos 2 pedidos
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 2;


-- ======================
-- BLOCO B – SUM (16–30)
-- ======================

-- 16) Some o valor total de todos os pedidos
SELECT SUM(amount)
FROM orders;

-- 17) Some o valor total por cliente
SELECT customer_id, SUM(amount) AS total_gasto
FROM orders
GROUP BY customer_id;

-- 18) Some o valor total apenas de pedidos pagos
SELECT SUM(amount)
FROM orders
WHERE status = 'paid';

-- 19) Some o valor total por status
SELECT status, SUM(amount) AS total
FROM orders
GROUP BY status;

-- 20) Some o valor total por cliente e status
SELECT customer_id, status, SUM(amount) AS total
FROM orders
GROUP BY customer_id, status;

-- 21) Some o valor total apenas de clientes ativos
SELECT SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true;

-- 22) Some o valor total apenas de pedidos acima de 100
SELECT SUM(amount)
FROM orders
WHERE amount > 100;

-- 23) Some o valor total por dia
SELECT order_date, SUM(amount) AS total
FROM orders
GROUP BY order_date;

-- 24) Some o valor total de pedidos com payment_method = 'pix'
SELECT SUM(amount)
FROM orders
WHERE payment_method = 'pix';

-- 25) Some o valor total de pedidos com payment_method NULL
SELECT SUM(amount)
FROM orders
WHERE payment_method IS NULL;

-- 26) Some o valor total por cliente ordenando do maior para o menor
SELECT customer_id, SUM(amount) AS total
FROM orders
GROUP BY customer_id
ORDER BY total DESC;

-- 27) Some o valor total apenas de clientes que gastaram mais de 200
SELECT customer_id, SUM(amount) AS total
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > 200;

-- 28) Some o valor total por cliente e filtre apenas quem gastou mais de 150
SELECT customer_id, SUM(amount) AS total
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > 150;

-- 29) Some o valor total de pedidos excluindo status 'cancelled'
SELECT SUM(amount)
FROM orders
WHERE status <> 'cancelled';

-- 30) Some o valor total de pedidos apenas do último mês
SELECT SUM(amount)
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '1 month';


-- ======================
-- BLOCO C – JOIN + GROUP BY (31–45)
-- ======================

-- 31) Nome do cliente e quantidade de pedidos
SELECT c.full_name, COUNT(o.order_id) AS total
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- 32) Nome do cliente e valor total gasto
SELECT c.full_name, SUM(o.amount) AS total
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- 33) Nome, quantidade de pedidos e valor total
SELECT c.full_name,
       COUNT(o.order_id) AS total_pedidos,
       SUM(o.amount) AS total_gasto
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- 34) Apenas clientes ativos com quantidade de pedidos
SELECT c.full_name, COUNT(o.order_id)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
GROUP BY c.full_name;

-- 35) Apenas clientes ativos com valor total gasto
SELECT c.full_name, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
GROUP BY c.full_name;

-- 36) Clientes com mais de 2 pedidos
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING COUNT(o.order_id) > 2;

-- 37) Clientes que gastaram mais de 300
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > 300;

-- 38) Clientes e total gasto ordenado
SELECT c.full_name, SUM(o.amount) AS total
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total DESC;

-- 39) Clientes e total gasto apenas de pedidos pagos
SELECT c.full_name, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.status = 'paid'
GROUP BY c.full_name;

-- 40) Clientes e total gasto apenas de pedidos não cancelados
SELECT c.full_name, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.status <> 'cancelled'
GROUP BY c.full_name;

-- 41) Clientes e total gasto por status
SELECT c.full_name, o.status, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name, o.status;

-- 42) Clientes e total gasto apenas com pix
SELECT c.full_name, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.payment_method = 'pix'
GROUP BY c.full_name;

-- 43) Clientes e total gasto com payment_method NULL
SELECT c.full_name, SUM(o.amount)
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.payment_method IS NULL
GROUP BY c.full_name;

-- 44) Clientes com pedidos acima da média
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > (
  SELECT AVG(amount) FROM orders
)
GROUP BY c.full_name;

-- 45) Clientes com pelo menos 1 pedido e total > 100
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > 100;


-- ======================
-- BLOCO D – DESAFIOS (46–50)
-- ======================

-- 46) Cliente ativo: nome, quantidade e total
SELECT c.full_name,
       COUNT(o.order_id),
       SUM(o.amount)
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
GROUP BY c.full_name;

-- 47) Clientes ativos com mais de 1 pedido
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
GROUP BY c.full_name
HAVING COUNT(o.order_id) > 1;

-- 48) Clientes cujo total gasto é maior que a média geral
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(amount) FROM orders
);

-- 49) Clientes com pedidos em mais de um status
SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING COUNT(DISTINCT o.status) > 1;

-- 50) Cliente que mais gastou
SELECT c.full_name, SUM(o.amount) AS total
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total DESC
LIMIT 1;
