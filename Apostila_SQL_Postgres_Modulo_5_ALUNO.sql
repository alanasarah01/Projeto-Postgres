-- =========================================================
-- WORKBOOK – MÓDULO 5: SQL APLICADO A DATA QUALITY (PostgreSQL)
-- Versão: ALUNO (sem gabarito)
-- =========================================================
-- Como usar:
-- 1) Rode o BLOCO 0 (cria tabelas + insere dados sujos)
-- 2) Depois siga os exercícios na ordem
-- 3) Rode uma query por vez e observe o resultado
-- =========================================================


-- =========================================================
-- BLOCO 0 – AMBIENTE + DADOS SUJOS (NÃO CORRIJA AINDA)
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
-- BLOCO 1 – CHECKUP RÁPIDO (OLHAR O “FORMATO” DOS DADOS)
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
-- EXERCÍCIO: complete
-- SELECT COUNT(*) FROM customers;
-- SELECT COUNT(*) FROM orders;


-- =========================================================
-- BLOCO 2 – NULL (AUSÊNCIA DE DADO)
-- =========================================================

-- 2.1) Liste clientes sem email (NULL)
-- EXERCÍCIO

-- 2.2) Conte quantos clientes estão sem email
-- EXERCÍCIO

-- 2.3) Calcule o percentual de clientes sem email
-- Dica: COUNT(*) FILTER (WHERE ...)
-- EXERCÍCIO


-- =========================================================
-- BLOCO 3 – DUPLICIDADE (DUPLICADOS)
-- =========================================================

-- 3.1) Encontre emails duplicados (email repetido)
-- Dica: GROUP BY + HAVING
-- EXERCÍCIO

-- 3.2) Liste as linhas completas dos clientes duplicados por email
-- Dica: IN (subquery)
-- EXERCÍCIO


-- =========================================================
-- BLOCO 4 – DOMÍNIO DE VALORES (VALORES INVÁLIDOS)
-- =========================================================
-- Definições (o “certo” do nosso mini-sistema):
-- status permitido: 'paid', 'shipped', 'cancelled'
-- payment_method permitido: 'pix', 'credit_card'
--
-- Tudo fora disso é inválido.

-- 4.1) Liste pedidos com status inválido
-- EXERCÍCIO

-- 4.2) Conte pedidos com status inválido
-- EXERCÍCIO

-- 4.3) Liste pedidos com payment_method inválido
-- Atenção: payment_method pode ser NULL (ausente)
-- Então: inválido = NOT IN (...) e IS NOT NULL
-- EXERCÍCIO

-- 4.4) Conte pedidos com payment_method inválido (desconsiderando NULL)
-- EXERCÍCIO


-- =========================================================
-- BLOCO 5 – VALORES NUMÉRICOS INVÁLIDOS
-- =========================================================

-- 5.1) Liste pedidos com amount <= 0
-- EXERCÍCIO

-- 5.2) Conte pedidos com amount <= 0
-- EXERCÍCIO


-- =========================================================
-- BLOCO 6 – DATAS INVÁLIDAS
-- =========================================================

-- 6.1) Liste pedidos no futuro (order_date > hoje)
-- EXERCÍCIO

-- 6.2) Liste clientes com birth_date no futuro
-- EXERCÍCIO


-- =========================================================
-- BLOCO 7 – INTEGRIDADE REFERENCIAL (FK QUEBRADA)
-- =========================================================
-- Objetivo: encontrar pedidos cujo customer_id não existe em customers

-- 7.1) Liste pedidos sem cliente correspondente
-- Dica: LEFT JOIN + WHERE c.customer_id IS NULL
-- EXERCÍCIO

-- 7.2) Conte pedidos sem cliente correspondente
-- EXERCÍCIO


-- =========================================================
-- BLOCO 8 – TEXTO SUJO / PADRONIZAÇÃO (LIMPEZA)
-- =========================================================
-- Aqui você não “apaga o problema”, você:
-- (1) detecta
-- (2) mede impacto
-- (3) corrige
-- (4) valida de novo

-- 8.1) Detecte nomes com espaços duplicados (dois espaços seguidos)
SELECT *
FROM customers
WHERE full_name LIKE '%  %';

-- 8.2) Detecte emails com espaços nas pontas (leading/trailing)
-- Dica: email <> trim(email) (e email IS NOT NULL)
-- EXERCÍCIO

-- 8.3) Detecte emails em caixa alta (ex.: BRUNO...)
-- Dica: email <> lower(email)
-- EXERCÍCIO

-- 8.4) CORREÇÃO: limpar full_name (trim + regexp_replace)
-- regexp_replace(full_name, '\s+', ' ', 'g')
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
-- Aqui o duplicado não é por PK (order_id é único),
-- mas por “regra de negócio”.
-- Vamos supor que é duplicado se:
-- (customer_id, order_date, amount, status, payment_method) se repete

-- 9.1) Encontre duplicidade lógica em orders
-- Dica: GROUP BY em várias colunas + HAVING COUNT(*) > 1
-- EXERCÍCIO

-- 9.2) Liste as linhas completas que pertencem a um grupo duplicado lógico
-- Dica: use IN com uma chave composta (uma forma simples: concat)
-- EXERCÍCIO (opcional avançado)


-- =========================================================
-- BLOCO 10 – DATA QUALITY COM JOIN (RELAÇÕES)
-- =========================================================

-- 10.1) Liste clientes ativos que NÃO têm pedidos
-- Dica: LEFT JOIN + WHERE o.order_id IS NULL
-- EXERCÍCIO

-- 10.2) Conte clientes ativos sem pedidos
-- EXERCÍCIO


-- =========================================================
-- BLOCO 11 – SCORECARD DE QUALIDADE (RELATÓRIO FINAL)
-- =========================================================
-- Você vai gerar um “placar” com contagens.
-- Isso é MUITO comum no trabalho.

-- 11.1) Faça um relatório com 1 linha e colunas:
-- - total_customers
-- - customers_email_null
-- - customers_email_duplicated (quantos clientes estão em emails duplicados)
-- - total_orders
-- - orders_status_invalid
-- - orders_amount_invalid
-- - orders_future
-- - orders_without_customer
-- - orders_payment_invalid (desconsiderando NULL)
--
-- Dica:
-- Use subqueries no SELECT.
-- Exemplo:
-- SELECT (SELECT COUNT(*) FROM customers) AS total_customers, ...

-- EXERCÍCIO


-- =========================================================
-- BLOCO 12 – DESAFIO 
-- =========================================================
-- Crie uma tabela “dq_issues” (somente via SELECT) com as colunas:
-- - issue_type (texto)
-- - issue_count (número)
--
-- E liste pelo menos 6 tipos de problemas medidos acima.
-- (pode usar UNION ALL)
--
-- Exemplo:
-- SELECT 'customers_email_null' AS issue_type, COUNT(*) AS issue_count
-- FROM customers
-- WHERE email IS NULL
-- UNION ALL
-- SELECT 'orders_future', COUNT(*) ...
--
-- EXERCÍCIO


-- =========================================================
-- FIM DO WORKBOOK
-- =========================================================
