-- =====================================================================
-- Aula 30/04 | Modelagem de uma marmitaria (schema "marmitaria")
-- ATENÇÃO: recria o schema "marmitaria" do zero a cada execução.
-- A tabela "login" criada aqui é usada pelo script Aula 06-05.sql.
--
-- Regras de integridade
--   * item_pedido: apagar o pedido remove seus itens (CASCADE); apagar uma
--     marmita que já foi vendida é bloqueado (RESTRICT).
--   * pedido: apagar um cliente com pedidos é bloqueado (RESTRICT); apagar
--     o entregador mantém o pedido, sem entregador (SET NULL).
--   * entregador: apagar uma empresa com entregadores é bloqueado.
-- =====================================================================

DROP SCHEMA IF EXISTS marmitaria;
CREATE SCHEMA marmitaria DEFAULT CHARACTER SET utf8mb4;
USE marmitaria;

CREATE TABLE login (
	id            INT AUTO_INCREMENT,
	email         VARCHAR(255) NOT NULL,
	senha         VARCHAR(255) NOT NULL COMMENT 'hash da senha (nunca texto puro)',
	nivel_acesso  INT NOT NULL DEFAULT 1,
	PRIMARY KEY (id),
	UNIQUE KEY uq_login_email (email)
);

CREATE TABLE empresa (
	id       INT AUTO_INCREMENT,
	nome     VARCHAR(255) NOT NULL,
	cnpj     VARCHAR(18)  NOT NULL,
	email    VARCHAR(255),
	telefone VARCHAR(20),
	endereco VARCHAR(255),
	PRIMARY KEY (id),
	UNIQUE KEY uq_empresa_cnpj (cnpj)
);

CREATE TABLE entregador (
	id         INT AUTO_INCREMENT,
	id_empresa INT          NOT NULL,
	nome       VARCHAR(255) NOT NULL,
	cpf        VARCHAR(14)  NOT NULL,
	rg         VARCHAR(20),
	celular    VARCHAR(20),
	PRIMARY KEY (id),
	UNIQUE KEY uq_entregador_cpf (cpf),
	CONSTRAINT fk_entregador_empresa FOREIGN KEY (id_empresa)
		REFERENCES empresa (id)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cliente (
	telefone         VARCHAR(20),
	nome             VARCHAR(255) NOT NULL,
	endereco         VARCHAR(255),
	ponto_referencia VARCHAR(255),
	nascimento       DATE,
	PRIMARY KEY (telefone)
);

CREATE TABLE marmita (
	id        INT AUTO_INCREMENT,
	nome      VARCHAR(255) NOT NULL,
	descricao MEDIUMTEXT,
	tamanho   VARCHAR(20)  NOT NULL,
	valor     DECIMAL(8,2) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE pedido (
	id               INT AUTO_INCREMENT,
	telefone_cliente VARCHAR(20) NOT NULL,
	id_entregador    INT,
	status           VARCHAR(30)  NOT NULL DEFAULT 'Recebido',
	taxa_entrega     DECIMAL(6,2) NOT NULL DEFAULT 0.00,
	data_pedido      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	CONSTRAINT fk_pedido_cliente FOREIGN KEY (telefone_cliente)
		REFERENCES cliente (telefone)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_pedido_entregador FOREIGN KEY (id_entregador)
		REFERENCES entregador (id)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE item_pedido (
	id_pedido  INT NOT NULL,
	id_marmita INT NOT NULL,
	quantidade INT NOT NULL DEFAULT 1,
	PRIMARY KEY (id_pedido, id_marmita),
	CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
	CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido)
		REFERENCES pedido (id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_item_marmita FOREIGN KEY (id_marmita)
		REFERENCES marmita (id)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- Dados de exemplo (todos fictícios)
-- ---------------------------------------------------------------------

INSERT INTO empresa (id, nome, cnpj, email, telefone, endereco) VALUES
	(1, 'Entregas Rápidas Ltda', '11.222.333/0001-81', 'contato@entregas.example', '3532220001', 'Rua das Flores, 100');

INSERT INTO entregador (id, id_empresa, nome, cpf, rg, celular) VALUES
	(1, 1, 'João Pereira', '52998224725', 'MG1234567', '35999990010');

INSERT INTO cliente (telefone, nome, endereco, ponto_referencia, nascimento) VALUES
	('35999990020', 'Ana Souza', 'Av. Central, 50', 'Em frente à padaria', '1995-07-12');

INSERT INTO marmita (id, nome, descricao, tamanho, valor) VALUES
	(1, 'Frango grelhado', 'Arroz, feijão, frango grelhado e salada', 'Média',  18.00),
	(2, 'Bife acebolado',  'Arroz, feijão, bife acebolado e batata', 'Grande', 24.50);

INSERT INTO pedido (id, telefone_cliente, id_entregador, status, taxa_entrega, data_pedido) VALUES
	(1, '35999990020', 1, 'Entregue', 5.00, '2026-05-14 12:10:00');

INSERT INTO item_pedido (id_pedido, id_marmita, quantidade) VALUES
	(1, 1, 2),
	(1, 2, 1);

-- Consulta de exemplo: total de cada pedido (itens + taxa de entrega)
SELECT p.id AS pedido,
       c.nome AS cliente,
       SUM(i.quantidade * m.valor) + p.taxa_entrega AS total
FROM pedido p
INNER JOIN cliente c     ON c.telefone = p.telefone_cliente
INNER JOIN item_pedido i ON i.id_pedido = p.id
INNER JOIN marmita m     ON m.id = i.id_marmita
GROUP BY p.id, c.nome, p.taxa_entrega;

-- ---------------------------------------------------------------------
-- Limpeza (opcional): remove as tabelas na ordem correta, das que
-- dependem de outras para as independentes. Está comentada para que
-- o script Aula 06-05.sql ainda encontre a tabela "login".
-- ---------------------------------------------------------------------
-- DROP TABLE item_pedido;
-- DROP TABLE pedido;
-- DROP TABLE marmita;
-- DROP TABLE cliente;
-- DROP TABLE entregador;
-- DROP TABLE empresa;
-- DROP TABLE login;
