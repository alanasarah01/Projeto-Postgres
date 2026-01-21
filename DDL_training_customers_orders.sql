-- DDL (PostgreSQL) - Projeto: Loja Online (Customers & Orders)
-- Objetivo: duas tabelas relacionadas para treinar sintaxe + data quality + join

CREATE SCHEMA IF NOT EXISTS training;
SET search_path TO training;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id   BIGSERIAL PRIMARY KEY,
  full_name     TEXT NOT NULL,
  email         TEXT,
  phone         TEXT,
  birth_date    DATE,
  created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
  is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
  order_id       BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT,
  order_date     DATE NOT NULL,
  status         TEXT NOT NULL,
  amount         NUMERIC(12,2) NOT NULL,
  payment_method TEXT,
  created_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Observação didática: por enquanto NÃO criamos FK/UNIQUE/CHECK
-- para permitir a fase de Data Quality antes de "travar" o banco com constraints.
/*2) Importar os CSVs

Opção A (DBeaver): clique com botão direito na tabela → Import Data → CSV → selecione o arquivo.

Opção B (SQL com COPY, se ela estiver no psql):

SET search_path TO training;

COPY customers(customer_id, full_name, email, phone, birth_date, created_at, is_active)
FROM '/caminho/para/customers.csv'
WITH (FORMAT csv, HEADER true);

COPY orders(order_id, customer_id, order_date, status, amount, payment_method, created_at)
FROM '/caminho/para/orders.csv'
WITH (FORMAT csv, HEADER true);