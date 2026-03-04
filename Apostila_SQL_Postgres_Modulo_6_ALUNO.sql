-- =========================================================
-- WORKBOOK – RACIOCÍNIO ANALÍTICO COM SQL
-- Tópicos: SUBQUERY + CTE (WITH)
-- Banco: PostgreSQL
-- =========================================================
-- Pré-requisito:
-- - Tabelas customers e orders já existem e possuem dados
--
-- Objetivo:
-- - Aprender a PENSAR em etapas antes de escrever SQL
-- - Dominar SUBQUERY e CTE como ferramentas de raciocínio
--
-- Como estudar (regra de ouro):
-- - Não escreva SQL direto.
-- - Escreva o raciocínio em português primeiro.
-- - Depois transforme cada etapa em SQL.
--
-- =========================================================
-- MÉTODO PARA RESOLVER QUALQUER PROBLEMA SQL EM 4 PASSOS
-- =========================================================
-- PASSO 1 — Entender a pergunta (o que exatamente quer retornar?)
--   Ex: "Quais clientes gastaram mais que a média?"
--
-- PASSO 2 — Identificar os cálculos intermediários (quais números preciso calcular?)
--   Ex:
--   (a) total gasto por cliente
--   (b) média desses totais
--   (c) filtrar acima da média
--
-- PASSO 3 — Transformar cada passo em uma camada SQL
--   - Se for 1 cálculo auxiliar simples → SUBQUERY
--   - Se forem vários passos / quiser legibilidade → CTE (WITH)
--
-- PASSO 4 — Montar a query final e validar
--   - Rode primeiro sem filtro
--   - Depois adicione filtro
--   - Depois ordene/limite se necessário
--
-- =========================================================
-- 5 PADRÕES MENTAIS DE SUBQUERY (APARECEM EM ENTREVISTAS)
-- =========================================================
-- PADRÃO 1) Comparar com média (AVG)
--   "acima/abaixo da média"
/*
SELECT*
FROM orders
WHERE amount>
(
SELECT AVG(amount)
FROM orders
);
*/
-- PADRÃO 2) Comparar com extremo (MAX/MIN)
--   "maior/menor valor"
/*
SELECT*
FROM orders
WHERE amount=
(
SELECT MAX(amount)
FROM orders
);
*/
-- PADRÃO 3) Filtrar baseado em grupo (GROUP BY + HAVING)
--   "clientes com > N pedidos", "status com mais ocorrências"
/*
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*)>3;
*/
-- PADRÃO 4) Subquery correlacionada (por linha)
--   "comparar com média do próprio cliente/dia"
/*
SELECT*
FROM orders o
WHERE amount>
(
SELECT AVG(amount)
FROM orders
WHERE customer_id= o.customer_id
);
*/
-- PADRÃO 5) Subquery como tabela (FROM ( ... ) t)
--   "faça um resumo e depois filtre/ordene o resumo"
/*

SELECT*
FROM
(
SELECT
customer_id,
SUM(amount)AS total
FROM orders
GROUPBY customer_id
) t
WHERE total>200;
*/
-- =========================================================
-- 7 PADRÕES DE CTE USADOS POR DATA ENGINEERS
-- =========================================================
-- PADRÃO 1) Agregação intermediária (total_por_cliente, resumo_por_dia)
/*
WITH total_por_cliente AS
(
SELECT
customer_id,
SUM(amount)AS total
FROM orders
GROUPBY customer_id
)

SELECT*
FROM total_por_cliente;
*/

-- PADRÃO 2) Camada de filtro (base limpa / base válida)
/*
WITH pedidos_validos AS
(
SELECT*
FROM orders
WHERE amount>0
)

SELECT*
FROM pedidos_validos;
*/
-- PADRÃO 3) Data Quality (invalid_records, dq_scorecard)
/*
WITH pedidos_invalidos AS
(
SELECT*
FROM orders
WHERE amount<=0
)

SELECTCOUNT(*)
FROM pedidos_invalidos;
*/
-- PADRÃO 4) CTE com JOIN (enriquecimento com dimensões)
/*
WITH pedidos_por_cliente AS
(
SELECT
c.customer_id,
c.full_name,
SUM(o.amount)AS total
FROM customers c
JOIN orders o
ON c.customer_id= o.customer_id
GROUPBY c.customer_id, c.full_name
)

SELECT*
FROM pedidos_por_cliente;
*/
-- PADRÃO 5) Múltiplas CTEs (pipeline em etapas)
/*
WITH total AS
(
SELECT customer_id, SUM(amount) total
FROM orders
GROUPBY customer_id
),

media AS
(
SELECT AVG(total) media_total
FROM total
)

SELECT*
FROM total
WHERE total> (SELECT media_total FROM media);
*/
-- PADRÃO 6) Reutilização de lógica (usar a mesma base em várias partes)
-- PADRÃO 7) Transformação em pipeline (base -> limpeza -> agregado -> final)
/* WITH base AS (
SELECT *
FROM orders
),

limpeza AS (
SELECT *
FROM base
WHERE amount>0
),

agregado AS (
SELECT
customer_id,
SUM(amount) total
FROM limpeza
GROUPBY customer_id
)

SELECT *
FROM agregado;
*/
-- =========================================================
-- EXEMPLO-ÂNCORA (LEIA ANTES DOS EXERCÍCIOS)
-- =========================================================
-- Problema: "Top 3 clientes que gastaram mais que a média"
--
-- Raciocínio:
-- 1) total por cliente
-- 2) média desses totais
-- 3) filtrar acima da média
-- 4) ordenar e pegar top 3
--
-- Exemplo de solução (não é exercício):
-- WITH total_por_cliente AS (
--   SELECT customer_id, SUM(amount) AS total
--   FROM orders
--   GROUP BY customer_id
-- )
-- SELECT *
-- FROM total_por_cliente
-- WHERE total > (SELECT AVG(total) FROM total_por_cliente)
-- ORDER BY total DESC
-- LIMIT 3;
--
-- =========================================================
-- INSTRUÇÕES DO WORKBOOK
-- =========================================================
-- - Resolva na ordem.
-- - Para cada exercício, escreva a query logo abaixo do enunciado.
-- - Sempre que possível, teste em etapas:
--   (1) rode o "miolo" (CTE/subquery) sozinho
--   (2) depois rode a query final
-- - Se travar, volte ao português:
--   "o que eu preciso calcular primeiro?"
-- =========================================================



-- =========================================================
-- BLOCO A — SUBQUERY (1–20)
-- =========================================================

-- 1) Traga pedidos acima da média (média global de amount)

-- 2) Traga pedidos abaixo da média (média global de amount)

-- 3) Traga pedidos iguais ao maior valor de amount (maior pedido)

-- 4) Traga pedidos iguais ao menor valor de amount (menor pedido)

-- 5) Traga clientes (full_name) que têm PELO MENOS 1 pedido acima da média global
-- Dica: você pode retornar DISTINCT full_name

-- 6) Traga pedidos com amount maior que a média do mês atual
-- Dica: date_trunc('month', order_date) = date_trunc('month', current_date)

-- 7) Traga pedidos com amount maior que a média do PRÓPRIO cliente (subquery correlacionada)

-- 8) Traga clientes cujo TOTAL gasto (SUM) é maior que a média global de amount
-- (regra "estranha" proposital para treinar raciocínio)

-- 9) Traga pedidos com amount maior que a média dos últimos 30 dias

-- 10) Traga clientes cujo TOTAL gasto é maior que o MAIOR pedido (MAX(amount)) da tabela

-- 11) Traga pedidos com amount maior que a média do próprio DIA (subquery correlacionada por order_date)

-- 12) Traga pedidos com amount menor que a média do próprio cliente

-- 13) Traga clientes cujo TOTAL gasto é menor que a média global de amount

-- 14) Traga pedidos que são o MAIOR pedido de cada cliente
-- Dica: subquery correlacionada com MAX por customer_id

-- 15) Traga clientes cujo TOTAL gasto é maior que a média do TOTAL gasto por cliente
-- Dica: primeiro calcule total por cliente, depois calcule AVG desses totais

-- 16) Traga pedidos com amount maior que a média de pedidos APENAS de clientes ativos
-- Dica: precisa juntar customers + orders dentro da subquery

-- 17) Traga pedidos com amount maior que o MAIOR pedido de ontem (CURRENT_DATE - 1)
-- Dica: filtrar order_date = current_date - 1 dentro da subquery

-- 18) Traga clientes cujo TOTAL gasto é maior que a média do TOTAL gasto de clientes ativos

-- 19) Traga pedidos com amount maior que o MENOR pedido do próprio cliente

-- 20) Traga clientes cujo TOTAL gasto é maior que (total geral gasto / número de clientes com pedidos)
-- Dica: SUM(amount) / COUNT(DISTINCT customer_id) em uma subquery



-- =========================================================
-- BLOCO B — CTE (21–40)
-- =========================================================

-- 21) Crie uma CTE total_por_cliente com customer_id e total_gasto (SUM(amount)).
-- Depois selecione tudo da CTE.

-- 22) Usando a CTE do exercício 21, traga apenas clientes com total_gasto > 200.

-- 23) Crie uma CTE pedidos_por_status com status e total_pedidos (COUNT(*)).
-- Depois selecione tudo.

-- 24) Usando a CTE do exercício 23, traga apenas status com total_pedidos > 3.

-- 25) Crie uma CTE pedidos_ultimo_mes com pedidos dos últimos 30 dias.
-- Depois selecione tudo.

-- 26) A partir da CTE pedidos_ultimo_mes, calcule total gasto por cliente.

-- 27) Crie uma CTE clientes_ativos com customer_id e full_name (somente is_active=true).
-- Depois selecione tudo.

-- 28) Usando clientes_ativos, junte com orders e traga:
-- full_name, order_id, amount, order_date

-- 29) Usando clientes_ativos + orders, calcule total gasto por cliente ativo (full_name).

-- 30) Crie uma CTE pedidos_invalidos onde:
-- amount <= 0 OR status NOT IN ('paid','shipped','cancelled')
-- Depois selecione tudo.

-- 31) Usando pedidos_invalidos, conte quantos pedidos inválidos existem.

-- 32) Crie uma CTE pedidos_futuros onde order_date > CURRENT_DATE.
-- Depois selecione tudo.

-- 33) Usando pedidos_futuros, conte quantos pedidos no futuro existem.

-- 34) Crie uma CTE duplicados_logicos para detectar duplicidade lógica em orders:
-- (customer_id, order_date, amount, status, payment_method) repetidos
-- Retorne essas chaves + COUNT(*) como qtd.
-- Dica: GROUP BY + HAVING COUNT(*) > 1

-- 35) Usando duplicados_logicos, liste as linhas completas de orders que pertencem aos grupos duplicados.
-- Dica: join orders com a CTE pelas colunas chave (tratar NULL em payment_method)

-- 36) Crie uma CTE pedidos_por_dia com order_date e total_pedidos (COUNT(*)).

-- 37) Usando pedidos_por_dia, traga apenas dias com total_pedidos >= 2 (ou outro limite).

-- 38) Crie DUAS CTEs:
-- (a) total_por_cliente (SUM)
-- (b) qtde_por_cliente (COUNT)
-- Depois faça JOIN entre elas e traga customer_id, total_gasto, total_pedidos.

-- 39) Crie uma CTE total_por_cliente (com full_name via JOIN) e ordene do maior para o menor total.

-- 40) Crie uma CTE resumo_cliente com:
-- full_name, total_pedidos, total_gasto, ticket_medio (total_gasto/total_pedidos)
-- Depois selecione tudo ordenando por total_gasto DESC.



-- =========================================================
-- BLOCO C — DESAFIOS (41–50)
-- =========================================================

-- 41) Encontre o cliente que mais gastou (top 1) usando CTE

-- 42) Encontre o TOP 3 clientes que mais gastaram usando CTE

-- 43) Encontre o cliente com mais pedidos usando CTE

-- 44) Encontre o cliente com menor gasto (considere apenas quem tem pedidos)

-- 45) Calcule a média de gasto por cliente (média do total gasto por cliente)

-- 46) Calcule total de pedidos por mês (date_trunc('month', order_date))

-- 47) Encontre o mês com maior faturamento (SUM(amount)) e mostre o valor

-- 48) Traga clientes que nunca fizeram pedidos (LEFT JOIN + IS NULL)

-- 49) Traga clientes ativos sem pedidos (LEFT JOIN + IS NULL + is_active=true)

-- 50) Crie um relatório final (1 linha por cliente) com:
-- full_name, total_pedidos, total_gasto, ticket_medio
-- e inclua clientes sem pedidos (total_pedidos=0, total_gasto=0)
-- Dica: LEFT JOIN + COALESCE + GROUP BY