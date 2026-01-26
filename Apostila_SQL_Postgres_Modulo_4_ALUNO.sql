-- =========================================================
-- WORKBOOK – MÓDULO 4
-- SUBQUERY, CTE (WITH) E UNION
-- Banco: PostgreSQL
-- =========================================================
-- Objetivo:
-- Aprender a estruturar queries mais complexas
-- de forma CLARA, LEGÍVEL e PROFISSIONAL.
--
-- Esse módulo separa:
-- • quem sabe SQL básico
-- • de quem pensa SQL como engenheiro/analista
-- =========================================================


-- =========================================================
-- 1) SUBQUERY – MODELO MENTAL
-- =========================================================
-- Subquery = uma query DENTRO de outra query
--
-- Pense assim:
-- "Use o resultado dessa query aqui
--  como entrada para essa outra"
--
-- Subquery pode aparecer em:
-- • WHERE
-- • SELECT
-- • FROM
--
-- Regra mental:
-- Resolva o problema interno primeiro.


-- =========================================================
-- 2) SUBQUERY NO WHERE (CASO MAIS COMUM)
-- =========================================================
-- Exemplo:
-- Clientes que gastaram MAIS do que a média geral

SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(amount)
  FROM orders
);

-- Leia:
-- 1) Subquery calcula a média
-- 2) Query externa compara cada cliente com a média


-- =========================================================
-- 3) SUBQUERY NO SELECT (VALOR ESCALAR)
-- =========================================================
-- Exemplo:
-- Trazer total de pedidos e total geral junto

SELECT
  customer_id,
  COUNT(*) AS total_pedidos,
  (SELECT COUNT(*) FROM orders) AS total_geral_pedidos
FROM orders
GROUP BY customer_id;

-- Leia:
-- Para cada cliente, traga também um número fixo (total geral)


-- =========================================================
-- 4) SUBQUERY NO FROM (TABELA DERIVADA)
-- =========================================================
-- Aqui a subquery vira uma "tabela temporária"

SELECT *
FROM (
  SELECT
    customer_id,
    SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
) t
WHERE total_gasto > 200;

-- Leia:
-- Primeiro resumo por cliente
-- Depois filtro o resultado


-- =========================================================
-- 5) ERROS COMUNS COM SUBQUERY
-- =========================================================
-- ERRO 1: Subquery retornar mais de um valor
-- ERRO 2: Usar subquery quando JOIN é mais simples
-- ERRO 3: Não entender a ordem de execução


-- =========================================================
-- 6) EXERCÍCIOS – SUBQUERY (1–10)
-- =========================================================

-- 1) Traga clientes cujo total gasto é maior que a média

-- 2) Traga pedidos com valor maior que a média dos pedidos

-- 3) Traga clientes que gastaram menos que a média

-- 4) Traga pedidos cujo valor é igual ao maior valor existente

-- 5) Traga clientes que têm pedidos acima da média

-- 6) Traga pedidos feitos no mesmo dia do maior pedido

-- 7) Traga clientes cujo total gasto é menor que o total médio por cliente

-- 8) Traga pedidos cujo valor é menor que a média do próprio cliente

-- 9) Traga clientes cujo total gasto é maior que o total geral / número de clientes

-- 10) Traga pedidos cujo valor é maior que a média dos últimos 30 dias


-- =========================================================
-- 7) CTE (WITH) – MODELO MENTAL
-- =========================================================
-- CTE = Common Table Expression
--
-- Pense assim:
-- "Vou dar um nome para essa query intermediária"
--
-- CTE melhora:
-- • leitura
-- • manutenção
-- • explicação em entrevista
--
-- Regra:
-- CTE NÃO salva dados, só organiza lógica.


-- =========================================================
-- 8) CTE BÁSICA
-- =========================================================

WITH total_por_cliente AS (
  SELECT
    customer_id,
    SUM(amount) AS total_gasto
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM total_por_cliente
WHERE total_gasto > 200;

-- Leia:
-- 1) CTE calcula total por cliente
-- 2) Query final usa esse resultado


-- =========================================================
-- 9) CTE COM JOIN
-- =========================================================

WITH pedidos_por_cliente AS (
  SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_pedidos,
    SUM(o.amount) AS total_gasto
  FROM customers c
  JOIN orders o
    ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.full_name
)
SELECT *
FROM pedidos_por_cliente
WHERE total_pedidos > 1;


-- =========================================================
-- 10) CTE vs SUBQUERY (ENTREVISTA)
-- =========================================================
-- Pergunta comum:
-- "Quando usar CTE?"
--
-- Resposta esperada:
-- • quando a lógica é complexa
-- • quando a query cresce
-- • quando você quer legibilidade


-- =========================================================
-- 11) EXERCÍCIOS – CTE (11–25)
-- =========================================================

-- 11) Crie uma CTE com total gasto por cliente

-- 12) A partir da CTE, traga apenas clientes acima da média

-- 13) Crie uma CTE com pedidos por status

-- 14) A partir da CTE, traga apenas status com mais de 1 pedido

-- 15) Crie uma CTE com pedidos do último mês

-- 16) A partir dela, calcule o total por cliente

-- 17) Crie uma CTE com clientes ativos e seus pedidos

-- 18) A partir dela, conte pedidos por cliente

-- 19) Crie duas CTEs e junte elas (JOIN entre CTEs)

-- 20) Reescreva uma query com subquery usando CTE

-- 21) Crie uma CTE para detectar pedidos inválidos

-- 22) Crie uma CTE para scorecard de Data Quality

-- 23) Use CTE para simplificar um relatório complexo

-- 24) Explique em português o papel da CTE

-- 25) Reescreva uma query longa usando CTE


-- =========================================================
-- 12) UNION – MODELO MENTAL
-- =========================================================
-- UNION serve para EMPILHAR resultados
--
-- Pense assim:
-- "Resultado A embaixo do resultado B"
--
-- Regras importantes:
-- • Mesma quantidade de colunas
-- • Tipos compatíveis
-- • Ordem das colunas importa
--
-- UNION remove duplicados
-- UNION ALL mantém tudo


-- =========================================================
-- 13) UNION BÁSICO
-- =========================================================

SELECT customer_id, 'orders' AS origem
FROM orders

UNION ALL

SELECT customer_id, 'customers' AS origem
FROM customers;


-- =========================================================
-- 14) UNION vs UNION ALL
-- =========================================================
-- UNION     -> remove duplicados
-- UNION ALL -> mantém duplicados (mais rápido)


-- =========================================================
-- 15) EXERCÍCIOS – UNION (26–40)
-- =========================================================

-- 26) Crie um relatório unificado de problemas de Data Quality

-- 27) Una clientes ativos e inativos em uma única lista com tipo

-- 28) Una pedidos válidos e inválidos com flag

-- 29) Crie um UNION com contagens de problemas diferentes

-- 30) Recrie o scorecard do módulo 4 usando UNION ALL

-- 31) Combine dados de duas tabelas diferentes em uma saída padrão

-- 32) Crie um UNION que gere um log de eventos

-- 33) Explique quando NÃO usar UNION

-- 34) Reescreva um relatório complexo usando UNION ALL

-- 35) Crie um relatório final com issue_type e issue_count

-- 36) Use UNION para empilhar métricas

-- 37) Use UNION ALL para empilhar resultados intermediários

-- 38) Crie um relatório executivo com UNION

-- 39) Crie um UNION que misture dados agregados e não agregados

-- 40) Explique a diferença entre UNION e JOIN

-- =========================================================
-- FIM DO WORKBOOK
-- =========================================================
