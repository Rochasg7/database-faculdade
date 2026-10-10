-- =====================================================================
-- Aula 13/05 | SELECT com filtros, ordenação e apelidos
-- PRÉ-REQUISITO: executar antes o script Aula 07-05.sql, que cria o
-- schema "ordens_servico" com as tabelas cliente e finalizacao.
-- =====================================================================

USE ordens_servico;

-- Registra a data de entrada (preenchida antes das consultas por data;
-- sem isso a coluna fica NULL e o BETWEEN abaixo não retorna nada)
UPDATE finalizacao SET data = '2026-05-01';                      -- sem WHERE: todas as linhas
UPDATE finalizacao SET data = '2026-05-10' WHERE cod_final = 2;
UPDATE finalizacao SET data = '2026-05-05' WHERE cod_final = 3;

-- Todas as colunas e filtro por chave
SELECT * FROM cliente;
SELECT * FROM cliente WHERE cod_cliente = 1;

-- IN: lista de valores
SELECT nome FROM cliente WHERE cod_cliente IN (1, 3);

-- BETWEEN: intervalo de datas
SELECT cod_final, data, data_entrega
FROM finalizacao
WHERE data BETWEEN '2026-05-01' AND '2026-05-30';

-- LIKE: nomes que começam com G
SELECT nome FROM cliente WHERE nome LIKE 'G%';

SELECT data FROM finalizacao;
SELECT * FROM finalizacao;

-- ORDER BY: crescente (padrão) e decrescente
SELECT * FROM cliente ORDER BY cod_cliente;
SELECT * FROM cliente ORDER BY cod_cliente DESC;

-- Empresa e telefone dos clientes de uma empresa
SELECT empresa, telefone FROM cliente WHERE empresa = 'Univas';

-- Apelidos (AS) para colunas e tabela
SELECT f.data AS `Data Entrada`, f.data_entrega AS `Data Entrega`
FROM finalizacao AS f;
