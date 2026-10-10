-- =====================================================================
-- Aula 06/05 | INSERT, SELECT, UPDATE e DELETE na tabela "login"
-- PRÉ-REQUISITO: executar antes o script Aula 30-04.sql, que cria o
-- schema "marmitaria" e a tabela "login".
-- =====================================================================

USE marmitaria;

-- Limpa a tabela para o script poder ser executado mais de uma vez
DELETE FROM login;

-- INSERT: um registro
INSERT INTO login (id, email, senha, nivel_acesso)
	VALUES (1, 'l1@l1.com', SHA2('1234', 256), 1);

-- INSERT: vários registros de uma vez
INSERT INTO login (id, email, senha, nivel_acesso) VALUES
	(2, 'l2@l2.com', SHA2('1234', 256), 1),
	(3, 'l3@l3.com', SHA2('1234', 256), 1),
	(4, 'l4@l4.com', SHA2('1234', 256), 1),
	(5, 'l5@l5.com', SHA2('1234', 256), 1);

-- SELECT: todas as colunas e somente algumas colunas
SELECT * FROM login;
SELECT id, email FROM login;

-- UPDATE com WHERE: altera apenas o registro 1
UPDATE login SET nivel_acesso = 2 WHERE id = 1;
SELECT id, email, nivel_acesso FROM login;

-- UPDATE sem WHERE: altera TODOS os registros da tabela
UPDATE login SET nivel_acesso = 0;
SELECT id, email, nivel_acesso FROM login;

-- DELETE com WHERE: remove apenas o registro 5
DELETE FROM login WHERE id = 5;
SELECT * FROM login;

-- DELETE sem WHERE: remove TODOS os registros da tabela
DELETE FROM login;
SELECT * FROM login;
