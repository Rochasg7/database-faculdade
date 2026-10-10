-- =====================================================================
-- Aula 29/04 | Chaves primárias e estrangeiras (schema "chaves")
-- ATENÇÃO: recria o schema "chaves" do zero a cada execução.
-- =====================================================================

DROP SCHEMA IF EXISTS chaves;
CREATE SCHEMA chaves DEFAULT CHARACTER SET utf8mb4;
USE chaves;

-- 1) Primeira versão: categoria nasce sem chave primária e ela é
--    adicionada depois com ALTER TABLE.
CREATE TABLE produto (
	cod          INT,
	nome         VARCHAR(20),
	id_categoria INT,
	PRIMARY KEY (cod)
);

CREATE TABLE categoria (
	id   INT,
	nome VARCHAR(20)
);

ALTER TABLE categoria ADD PRIMARY KEY (id);

SHOW TABLES FROM chaves;
SHOW COLUMNS FROM chaves.categoria;
SHOW COLUMNS FROM chaves.produto;

-- 2) Segunda versão: recria categoria com PK, valor padrão e comentários.
DROP TABLE categoria;

CREATE TABLE categoria (
	id   INT PRIMARY KEY COMMENT 'id da categoria',
	nome VARCHAR(20) NOT NULL DEFAULT 'NI' COMMENT 'nome da categoria'
);

ALTER TABLE produto
	MODIFY nome VARCHAR(30) NOT NULL COMMENT 'Nome do produto';

-- 3) Chave estrangeira: produto.id_categoria -> categoria.id
--    (o CASCADE é o assunto da aula: apagar a categoria apaga seus produtos)
ALTER TABLE produto
	ADD CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
	REFERENCES categoria (id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- 4) Teste do comportamento do CASCADE
INSERT INTO categoria (id, nome) VALUES (1, 'Bebidas'), (2, 'Limpeza');
INSERT INTO produto (cod, nome, id_categoria) VALUES
	(1, 'Suco de laranja', 1),
	(2, 'Refrigerante', 1),
	(3, 'Detergente', 2);

SELECT p.nome AS produto, c.nome AS categoria
FROM produto p
INNER JOIN categoria c ON c.id = p.id_categoria;

-- ON UPDATE CASCADE: o id novo propaga para os produtos
UPDATE categoria SET id = 10 WHERE id = 1;
SELECT cod, nome, id_categoria FROM produto;

-- ON DELETE CASCADE: apagar a categoria 10 apaga os dois produtos dela
DELETE FROM categoria WHERE id = 10;
SELECT cod, nome, id_categoria FROM produto;
