-- =========================================================
-- APOSTILA – MÓDULO 2
-- GROUP BY, COUNT, SUM e JOIN
-- Banco: PostgreSQL
-- =========================================================
-- Pré-requisito:
-- Saber SELECT, FROM, WHERE, operadores e JOIN básico
--
-- Objetivo:
-- Entender AGREGAÇÃO de dados (resumo)
-- =========================================================


-- =========================================================
-- 1) O QUE É GROUP BY? (MODELO MENTAL)
-- =========================================================
-- GROUP BY serve para AGRUPAR linhas
-- e aplicar funções de agregação nelas.
--
-- Pense assim:
-- "Para cada X, calcule Y"
--
-- Exemplo em português:
-- "Para cada cliente, conte quantos pedidos ele fez"


-- =========================================================
-- 2) COUNT – CONTANDO LINHAS
-- =========================================================

-- 2.1) Contar todas as linhas da tabela
SELECT COUNT(*)
FROM orders;

-- 2.2) Contar pedidos por cliente
SELECT
  customer_id,
  COUNT(*) AS total_pedidos
FROM orders
GROUP BY customer_id;

-- REGRA DE OURO:
-- Toda coluna no SELECT que NÃO é agregação
-- precisa estar no GROUP BY


-- =========================================================
-- 3) GROUP BY COM MAIS DE UMA COLUNA
-- =========================================================

SELECT
  customer_id,
  status,
  COUNT(*) AS qtd
FROM orders
GROUP BY customer_id, status;

-- Leia:
-- "Para cada cliente e status, conte pedidos"


-- =========================================================
-- 4) COUNT COM NULL (IMPORTANTE)
-- =========================================================
-- COUNT(*) conta linhas
-- COUNT(coluna) ignora NULL

SELECT COUNT(payment_method)
FROM orders;


-- =========================================================
-- 5) SUM – SOMANDO VALORES
-- =========================================================

-- 5.1) Soma total de vendas
SELECT SUM(amount)
FROM orders;

-- 5.2) Soma de vendas por cliente
SELECT
  customer_id,
  SUM(amount) AS total_gasto
FROM orders
GROUP BY customer_id;


-- =========================================================
-- 6) JOIN – JUNTANDO TABELAS 
-- =========================================================
-- JOIN é usado quando a informação que você quer
-- está espalhada em MAIS DE UMA TABELA.
--
-- Exemplo do mundo real:
-- • customers -> quem é a pessoa
-- • orders    -> o que ela comprou
--
-- Pergunta:
-- "Quais pedidos cada cliente fez?"
-- → Preciso juntar customers + orders


-- =========================================================
-- 6.1) MODELO MENTAL DO JOIN
-- =========================================================
-- JOIN = ligar tabelas por uma COLUNA EM COMUM
--
-- Essa coluna normalmente é:
-- • Primary Key em uma tabela
-- • Foreign Key na outra
--
-- No nosso caso:
-- customers.customer_id  = orders.customer_id
--
-- Leia em português:
-- "Junte customers com orders ONDE
--  o customer_id de customers é igual
--  ao customer_id de orders"


-- =========================================================
-- 6.2) SINTAXE BÁSICA DO JOIN
-- =========================================================
SELECT
  c.full_name,
  o.order_id,
  o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id;

-- Regras importantes:
-- • JOIN SEMPRE vem depois do FROM
-- • ON define COMO as tabelas se ligam
-- • Nunca use JOIN sem ON (isso gera erro ou lixo)


-- =========================================================
-- 6.3) ALIAS (APELIDOS) – OBRIGATÓRIO NA PRÁTICA
-- =========================================================
-- Alias são apelidos para tabelas
-- customers -> c
-- orders    -> o
--
-- Isso:
-- FROM customers c
--
-- Evita:
-- • nomes longos
-- • ambiguidade de coluna
-- • erros em JOIN

--  ERRO comum:
-- SELECT customer_id
-- FROM customers
-- JOIN orders
-- ON customer_id = customer_id;
--
-- (Postgres não sabe de qual tabela é a coluna)


-- =========================================================
-- 6.4) INNER JOIN (JOIN PADRÃO)
-- =========================================================
-- Quando você escreve apenas JOIN,
-- o Postgres entende como INNER JOIN.
--
-- INNER JOIN retorna SOMENTE: registros que EXISTEM nas duas tabelas

SELECT
  c.full_name,
  o.amount
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- Leia:
-- "Traga apenas clientes que têm pedidos"


-- =========================================================
-- 6.5) LEFT JOIN (MUITO IMPORTANTE)
-- =========================================================
-- LEFT JOIN retorna:
-- • TODOS os registros da tabela da ESQUERDA
-- • Mesmo que não exista correspondência na direita
--
-- customers é a esquerda
-- orders é a direita

SELECT
  c.full_name,
  o.order_id,
  o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;

-- Leia:
-- "Traga todos os clientes,
--  mesmo os que não fizeram pedidos"


-- =========================================================
-- 6.6) COMO ESCOLHER ENTRE INNER JOIN E LEFT JOIN (SEM AMBIGUIDADE)
-- =========================================================
-- Regra prática (guarde isso):
--
-- INNER JOIN:
-- • Retorna APENAS registros que existem NAS DUAS tabelas
-- • Registros sem correspondência SÃO DESCARTADOS
--
-- LEFT JOIN:
-- • Retorna TODOS os registros da tabela da ESQUERDA
-- • Mesmo que NÃO exista correspondência na tabela da DIREITA
--
-- Pense assim:
--
-- "Minha tabela principal é a da esquerda?"
-- → use LEFT JOIN
--
-- "Só me importo com registros que existem nas duas?"
-- → use INNER JOIN
--
-- Exemplos em português:
--
-- INNER JOIN:
-- "Quero apenas clientes que fizeram pedidos"
--
-- LEFT JOIN:
-- "Quero todos os clientes, mesmo os que não fizeram pedidos"


-- =========================================================
-- 6.7) JOIN + WHERE 
-- =========================================================
-- ATENÇÃO:
-- WHERE filtra DEPOIS do JOIN
--
-- Esse filtro transforma LEFT JOIN em INNER JOIN sem você perceber!

--  ERRO:
SELECT
  c.full_name,
  o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > 100;

-- Isso REMOVE clientes sem pedidos.

--  CORRETO:
SELECT
  c.full_name,
  o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
 AND o.amount > 100;

-- Leia:
-- "Traga todos os clientes,
--  e apenas pedidos acima de 100 quando existirem"


-- =========================================================
-- 6.8) JOIN + GROUP BY (CASO REAL)
-- =========================================================
SELECT
  c.full_name,
  COUNT(o.order_id) AS total_pedidos,
  SUM(o.amount)     AS total_gasto
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- Leia:
-- "Para cada cliente, conte pedidos e some valores"


-- =========================================================
-- 6.9) ERROS MAIS COMUNS COM JOIN
-- =========================================================

-- ERRO 1: JOIN sem ON
-- JOIN orders;

-- ERRO 2: Coluna errada no ON
-- ON c.customer_id = o.order_id;

-- ERRO 3: Esquecer alias
-- SELECT customer_id FROM customers JOIN orders ON ...

-- ERRO 4: Usar WHERE em coluna da tabela da direita no LEFT JOIN

-- ERRO 5: Confundir JOIN com UNION (não são a mesma coisa)


-- =========================================================
-- 6.10) EXERCÍCIOS DE JOIN (PRÁTICA)
-- =========================================================

-- 1) Traga nome do cliente e id do pedido

-- 2) Traga todos os clientes, mesmo os que não têm pedidos

-- 3) Traga apenas clientes que têm pedidos

-- 4) Traga clientes ativos e seus pedidos

-- 5) Conte quantos pedidos cada cliente fez

-- 6) Some o valor total gasto por cliente

-- 7) Traga clientes com mais de 2 pedidos

-- 8) Traga clientes que não fizeram nenhum pedido

-- 9) Traga clientes com pedidos acima de 100

-- 10) Traga nome do cliente e total gasto,
--     mesmo que ele não tenha pedido (valor 0)

-- Dica:
-- Para o exercício 10, use LEFT JOIN + COALESCE



-- =========================================================
-- 7) WHERE x HAVING (MUITO IMPORTANTE)
-- =========================================================
-- WHERE filtra linhas ANTES do GROUP BY
-- HAVING filtra resultados DEPOIS do GROUP BY

-- Exemplo:
-- clientes com mais de 2 pedidos

SELECT
  customer_id,
  COUNT(*) AS total_pedidos
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 2;


-- =========================================================
-- 8) ERROS COMUNS
-- =========================================================
-- ERRO:
-- SELECT customer_id, amount, SUM(amount)
-- FROM orders
-- GROUP BY customer_id;

-- Correto:
-- amount precisa estar no GROUP BY ou ser agregado


-- =========================================================
-- 9) EXERCÍCIOS (50 NO TOTAL)
-- =========================================================
-- Resolva na ordem. Não pule.


-- ======================
-- BLOCO A – COUNT (1–15)
-- ======================

-- 1) Conte quantos pedidos existem na tabela orders

-- 2) Conte quantos clientes existem

-- 3) Conte quantos pedidos cada cliente fez

-- 4) Conte quantos pedidos existem por status

-- 5) Conte quantos pedidos existem por cliente e status

-- 6) Conte quantos pedidos têm payment_method preenchido

-- 7) Conte quantos pedidos têm payment_method NULL

-- 8) Conte quantos clientes estão ativos

-- 9) Conte quantos clientes estão inativos

-- 10) Conte quantos clientes têm email preenchido

-- 11) Conte quantos pedidos cada cliente ativo fez

-- 12) Conte quantos pedidos existem com valor maior que 100

-- 13) Conte quantos pedidos existem por dia

-- 14) Conte quantos pedidos cada cliente fez apenas com status 'paid'

-- 15) Conte quantos clientes fizeram pelo menos 2 pedidos


-- ======================
-- BLOCO B – SUM (16–30)
-- ======================

-- 16) Some o valor total de todos os pedidos

-- 17) Some o valor total por cliente

-- 18) Some o valor total apenas de pedidos pagos

-- 19) Some o valor total por status

-- 20) Some o valor total por cliente e status

-- 21) Some o valor total apenas de clientes ativos

-- 22) Some o valor total apenas de pedidos acima de 100

-- 23) Some o valor total por dia

-- 24) Some o valor total de pedidos com payment_method = 'pix'

-- 25) Some o valor total de pedidos com payment_method NULL

-- 26) Some o valor total por cliente ordenando do maior para o menor

-- 27) Some o valor total apenas de clientes que gastaram mais de 200

-- 28) Some o valor total por cliente e filtre apenas quem gastou mais de 150

-- 29) Some o valor total de pedidos excluindo status 'cancelled'

-- 30) Some o valor total de pedidos apenas do último mês


-- ======================
-- BLOCO C – JOIN + GROUP BY (31–45)
-- ======================

-- 31) Traga nome do cliente e quantidade de pedidos

-- 32) Traga nome do cliente e valor total gasto

-- 33) Traga nome do cliente, quantidade de pedidos e valor total

-- 34) Traga apenas clientes ativos com quantidade de pedidos

-- 35) Traga apenas clientes ativos com valor total gasto

-- 36) Traga clientes com mais de 2 pedidos

-- 37) Traga clientes que gastaram mais de 300

-- 38) Traga clientes e total gasto ordenado do maior para o menor

-- 39) Traga clientes e total gasto apenas de pedidos pagos

-- 40) Traga clientes e total gasto apenas de pedidos não cancelados

-- 41) Traga clientes e total gasto por status

-- 42) Traga clientes e total gasto apenas com paymen

-- 43) Traga clientes e total gasto apenas com payment_method NULL

-- 44) Traga clientes com pedidos acima da média de valor

-- 45) Traga clientes com pelo menos 1 pedido e valor total maior que 100


-- ======================
-- BLOCO D – DESAFIOS (46–50)
-- ======================

-- 46) Para cada cliente ativo, mostre:
-- nome, quantidade de pedidos e total gasto

-- 47) Traga apenas clientes ativos que fizeram mais de 1 pedido

-- 48) Traga clientes cujo total gasto é maior que a média geral

-- 49) Traga clientes com pedidos em mais de um status diferente

-- 50) Traga o cliente que mais gastou (top 1)
