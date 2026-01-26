-- =========================================================
-- WORKBOOK – MÓDULO 5: SQL APLICADO A DATA QUALITY (PostgreSQL)
-- Versão: GABARITO DO MENTOR 
-- =========================================================
-- Contém:
-- - Ambiente + dados sujos (BLOCO 0)
-- - Respostas completas de todos os exercícios
-- - Scorecard final e desafio estilo empresa
-- =========================================================


-- =========================================================
-- BLOCO 0 – AMBIENTE + DADOS SUJOS
-- =========================================================
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name   TEXT,
  email       TEXT,
  birth_date  DATE,
  is_active   BOOLEAN
);

CREATE TABLE orders (
  order_id       BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT,
  order_date     DATE,
  status         TEXT,
  amount         NUMERIC(10,2),
  payment_method TEXT
);

INSERT INTO customers (full_name, email, birth_date, is_active) VALUES
('Ana Silva', 'ana.silva@email.com', '1995-04-10', true),
('Bruno Lima', 'BRUNO.LIMA@EMAIL.COM', '1989-02-20', true),
('   Carla   Souza  ', 'carla.souza@email.com', '1992-08-15', true),
('Diego Santos', NULL, '1990-01-01', true),
('Eva Pereira', 'eva@email.com', '2035-01-01', true),
('Carla Souza', 'carla.souza@email.com', '1992-08-15', true),
('Felipe Nunes', 'felipe.nunes@email.com', '1985-11-30', false),
('Jo', 'jo@email.com', '1998-05-05', true),
('Marcos Paulo', 'marcos.email.com', '1993-03-12', true),
('Renata Alves', ' renata@email.com ', '1991-09-09', true);

INSERT INTO orders (customer_id, order_date, status, amount, payment_method) VALUES
(1, CURRENT_DATE - 10, 'paid', 120.50, 'credit_card'),
(1, CURRENT_DATE - 5, 'PAID', 89.90, 'pix'),
(2, CURRENT_DATE - 3, 'paid', -50.00, 'credit_card'),
(999, CURRENT_DATE - 7, 'paid', 30.00, 'pix'),
(3, CURRENT_DATE + 5, 'paid', 70.00, 'pix'),
(4, CURRENT_DATE - 2, 'finished', 45.00, 'cash'),
(5, CURRENT_DATE - 1, 'paid', 150.00, 'money'),
(6, CURRENT_DATE - 4, 'cancelled', 60.00, NULL),
(7, CURRENT_DATE - 6, 'paid', 200.00, 'pix'),
(1, CURRENT_DATE - 10, 'paid', 120.50, 'credit_card');

SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM orders ORDER BY order_id;


-- =========================================================
-- BLOCO 1 – CHECKUP RÁPIDO
-- =========================================================

-- 1.1) Quais valores de status existem hoje?
SELECT DISTINCT status
FROM orders
ORDER BY status;

-- 1.2) Quais valores de payment_method existem hoje?
SELECT DISTINCT payment_method
FROM orders
ORDER BY payment_method;

-- 1.3) Quantos registros existem em cada tabela?
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;


-- =========================================================
-- BLOCO 2 – NULL (AUSÊNCIA DE DADO)
-- =========================================================

-- 2.1) Liste clientes sem email (NULL)
SELECT *
FROM customers
WHERE email IS NULL
ORDER BY customer_id;

-- 2.2) Conte quantos clientes estão sem email
SELECT COUNT(*) AS customers_email_null
FROM customers
WHERE email IS NULL;

-- 2.3) Calcule o percentual de clientes sem email
SELECT
  COUNT(*) FILTER (WHERE email IS NULL) * 100.0 / COUNT(*) AS pct_customers_email_null
FROM customers;


-- =========================================================
-- BLOCO 3 – DUPLICIDADE (DUPLICADOS)
-- =========================================================

-- 3.1) Encontre emails duplicados
SELECT email, COUNT(*) AS qtd
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY qtd DESC, email;

-- 3.2) Liste as linhas completas dos clientes duplicados por email
SELECT *
FROM customers
WHERE email IN (
  SELECT email
  FROM customers
  WHERE email IS NOT NULL
  GROUP BY email
  HAVING COUNT(*) > 1
)
ORDER BY email, customer_id;


-- =========================================================
-- BLOCO 4 – DOMÍNIO DE VALORES (VALORES INVÁLIDOS)
-- =========================================================
-- Definições:
-- status permitido: 'paid', 'shipped', 'cancelled'
-- payment_method permitido: 'pix', 'credit_card'

-- 4.1) Liste pedidos com status inválido
SELECT *
FROM orders
WHERE status NOT IN ('paid', 'shipped', 'cancelled')
ORDER BY order_id;

-- 4.2) Conte pedidos com status inválido
SELECT COUNT(*) AS orders_status_invalid
FROM orders
WHERE status NOT IN ('paid', 'shipped', 'cancelled');

-- 4.3) Liste pedidos com payment_method inválido (desconsiderando NULL)
SELECT *
FROM orders
WHERE payment_method IS NOT NULL
  AND payment_method NOT IN ('pix', 'credit_card')
ORDER BY order_id;

-- 4.4) Conte pedidos com payment_method inválido (desconsiderando NULL)
SELECT COUNT(*) AS orders_payment_invalid
FROM orders
WHERE payment_method IS NOT NULL
  AND payment_method NOT IN ('pix', 'credit_card');


-- =========================================================
-- BLOCO 5 – VALORES NUMÉRICOS INVÁLIDOS
-- =========================================================

-- 5.1) Liste pedidos com amount <= 0
SELECT *
FROM orders
WHERE amount <= 0
ORDER BY order_id;

-- 5.2) Conte pedidos com amount <= 0
SELECT COUNT(*) AS orders_amount_invalid
FROM orders
WHERE amount <= 0;


-- =========================================================
-- BLOCO 6 – DATAS INVÁLIDAS
-- =========================================================

-- 6.1) Liste pedidos no futuro
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE
ORDER BY order_id;

-- 6.2) Liste clientes com birth_date no futuro
SELECT *
FROM customers
WHERE birth_date > CURRENT_DATE
ORDER BY customer_id;


-- =========================================================
-- BLOCO 7 – INTEGRIDADE REFERENCIAL (FK QUEBRADA)
-- =========================================================

-- 7.1) Liste pedidos sem cliente correspondente
SELECT o.*
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
ORDER BY o.order_id;

-- 7.2) Conte pedidos sem cliente correspondente
SELECT COUNT(*) AS orders_without_customer
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- =========================================================
-- BLOCO 8 – TEXTO SUJO / PADRONIZAÇÃO
-- =========================================================

-- 8.1) Detecte nomes com espaços duplicados
SELECT *
FROM customers
WHERE full_name LIKE '%  %'
ORDER BY customer_id;

-- 8.2) Detecte emails com espaços nas pontas
SELECT *
FROM customers
WHERE email IS NOT NULL
  AND email <> trim(email)
ORDER BY customer_id;

-- 8.3) Detecte emails em caixa alta (ou com letras maiúsculas)
-- Observação: esta regra é simples e funciona para o caso do exercício.
SELECT *
FROM customers
WHERE email IS NOT NULL
  AND email <> lower(email)
ORDER BY customer_id;

-- 8.4) CORREÇÃO: limpar full_name (trim + regexp_replace)
UPDATE customers
SET full_name = regexp_replace(trim(full_name), '\s+', ' ', 'g')
WHERE full_name IS NOT NULL;

-- 8.5) CORREÇÃO: padronizar email (trim + lower)
UPDATE customers
SET email = lower(trim(email))
WHERE email IS NOT NULL;

-- 8.6) VALIDAÇÃO: ver customers novamente
SELECT * FROM customers ORDER BY customer_id;


-- =========================================================
-- BLOCO 9 – DUPLICIDADE “LÓGICA” EM ORDERS
-- =========================================================
-- Regra: duplicado se (customer_id, order_date, amount, status, payment_method) se repete

-- 9.1) Encontre duplicidade lógica
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
ORDER BY qtd DESC;

-- 9.2) Liste linhas completas que pertencem a um grupo duplicado lógico
-- Abordagem simples: CTE com as chaves duplicadas e join de volta
WITH dup_keys AS (
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
JOIN dup_keys d
  ON o.customer_id = d.customer_id
 AND o.order_date = d.order_date
 AND o.amount = d.amount
 AND o.status = d.status
 AND (
      (o.payment_method = d.payment_method)
      OR (o.payment_method IS NULL AND d.payment_method IS NULL)
 )
ORDER BY o.order_id;


-- =========================================================
-- BLOCO 10 – DATA QUALITY COM JOIN (RELAÇÕES)
-- =========================================================

-- 10.1) Liste clientes ativos que NÃO têm pedidos
SELECT c.full_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
  AND o.order_id IS NULL
ORDER BY c.full_name;

-- 10.2) Conte clientes ativos sem pedidos
SELECT COUNT(*) AS active_customers_without_orders
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true
  AND o.order_id IS NULL;


-- =========================================================
-- BLOCO 11 – SCORECARD DE QUALIDADE (RELATÓRIO FINAL)
-- =========================================================
-- Relatório em 1 linha, com subqueries no SELECT

SELECT
  (SELECT COUNT(*) FROM customers) AS total_customers,

  (SELECT COUNT(*) FROM customers WHERE email IS NULL) AS customers_email_null,

  -- quantos clientes estão em emails duplicados (conta linhas, não emails)
  (SELECT COUNT(*)
   FROM customers
   WHERE email IN (
     SELECT email
     FROM customers
     WHERE email IS NOT NULL
     GROUP BY email
     HAVING COUNT(*) > 1
   )
  ) AS customers_email_duplicated,

  (SELECT COUNT(*) FROM orders) AS total_orders,

  (SELECT COUNT(*)
   FROM orders
   WHERE status NOT IN ('paid', 'shipped', 'cancelled')
  ) AS orders_status_invalid,

  (SELECT COUNT(*)
   FROM orders
   WHERE amount <= 0
  ) AS orders_amount_invalid,

  (SELECT COUNT(*)
   FROM orders
   WHERE order_date > CURRENT_DATE
  ) AS orders_future,

  (SELECT COUNT(*)
   FROM orders o
   LEFT JOIN customers c
     ON o.customer_id = c.customer_id
   WHERE c.customer_id IS NULL
  ) AS orders_without_customer,

  (SELECT COUNT(*)
   FROM orders
   WHERE payment_method IS NOT NULL
     AND payment_method NOT IN ('pix', 'credit_card')
  ) AS orders_payment_invalid;


-- =========================================================
-- BLOCO 12 – DESAFIO (ESTILO EMPRESA)
-- dq_issues: issue_type, issue_count
-- =========================================================
-- Pelo menos 6 issues, via UNION ALL

SELECT 'customers_email_null' AS issue_type, COUNT(*) AS issue_count
FROM customers
WHERE email IS NULL

UNION ALL
SELECT 'customers_email_duplicated', COUNT(*)
FROM customers
WHERE email IN (
  SELECT email
  FROM customers
  WHERE email IS NOT NULL
  GROUP BY email
  HAVING COUNT(*) > 1
)

UNION ALL
SELECT 'customers_birth_date_future', COUNT(*)
FROM customers
WHERE birth_date > CURRENT_DATE

UNION ALL
SELECT 'orders_status_invalid', COUNT(*)
FROM orders
WHERE status NOT IN ('paid', 'shipped', 'cancelled')

UNION ALL
SELECT 'orders_amount_invalid', COUNT(*)
FROM orders
WHERE amount <= 0

UNION ALL
SELECT 'orders_future', COUNT(*)
FROM orders
WHERE order_date > CURRENT_DATE

UNION ALL
SELECT 'orders_without_customer', COUNT(*)
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL
SELECT 'orders_payment_invalid', COUNT(*)
FROM orders
WHERE payment_method IS NOT NULL
  AND payment_method NOT IN ('pix', 'credit_card')

ORDER BY issue_count DESC, issue_type;


-- =========================================================
-- FIM DO GABARITO
-- =========================================================
