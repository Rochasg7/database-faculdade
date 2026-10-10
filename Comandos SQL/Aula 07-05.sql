-- =====================================================================
-- Aula 07/05 | Modelagem de ordens de serviço (schema "ordens_servico")
-- ATENÇÃO: recria o schema "ordens_servico" do zero a cada execução.
-- O script Aula 13-05.sql usa as tabelas criadas aqui.
--
-- Regras de integridade
--   * ordem_servico -> cliente e tecnico: RESTRICT (não apagar quem tem OS).
--   * ordem_servico -> finalizacao: SET NULL (apagar o fechamento não apaga
--     a ordem de serviço).
--   * ordem_servico_item: CASCADE do lado da ordem; RESTRICT do lado do
--     serviço (um serviço já executado não pode ser apagado).
-- =====================================================================

DROP SCHEMA IF EXISTS ordens_servico;
CREATE SCHEMA ordens_servico DEFAULT CHARACTER SET utf8mb4;
USE ordens_servico;

CREATE TABLE servico (
	cod_servico INT AUTO_INCREMENT,
	atividade   VARCHAR(255) NOT NULL,
	PRIMARY KEY (cod_servico)
);

CREATE TABLE cliente (
	cod_cliente INT AUTO_INCREMENT,
	nome        VARCHAR(100) NOT NULL,
	empresa     VARCHAR(255),
	telefone    VARCHAR(20),
	PRIMARY KEY (cod_cliente)
);

CREATE TABLE tecnico (
	cod_tecnico INT AUTO_INCREMENT,
	nome        VARCHAR(100) NOT NULL,
	PRIMARY KEY (cod_tecnico)
);

CREATE TABLE finalizacao (
	cod_final    INT AUTO_INCREMENT,
	valor_total  DECIMAL(10,2) NOT NULL COMMENT 'valor total em reais, com centavos',
	data         DATETIME COMMENT 'data de entrada do equipamento',
	data_entrega DATETIME COMMENT 'data de entrega ao cliente',
	PRIMARY KEY (cod_final)
);

CREATE TABLE ordem_servico (
	cod_ordem   INT AUTO_INCREMENT,
	data        DATETIME,
	defeito     VARCHAR(255),
	equipamento VARCHAR(255) NOT NULL,
	cod_cliente INT NOT NULL,
	cod_tecnico INT NOT NULL,
	cod_final   INT,
	PRIMARY KEY (cod_ordem),
	CONSTRAINT fk_os_cliente FOREIGN KEY (cod_cliente)
		REFERENCES cliente (cod_cliente)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_os_tecnico FOREIGN KEY (cod_tecnico)
		REFERENCES tecnico (cod_tecnico)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_os_finalizacao FOREIGN KEY (cod_final)
		REFERENCES finalizacao (cod_final)
		ON DELETE SET NULL ON UPDATE CASCADE
);

-- N:N entre ordem de serviço e serviço
CREATE TABLE ordem_servico_item (
	cod_ordem   INT NOT NULL,
	cod_servico INT NOT NULL,
	PRIMARY KEY (cod_ordem, cod_servico),
	CONSTRAINT fk_osi_ordem FOREIGN KEY (cod_ordem)
		REFERENCES ordem_servico (cod_ordem)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_osi_servico FOREIGN KEY (cod_servico)
		REFERENCES servico (cod_servico)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- Dados de exemplo (todos fictícios)
-- ---------------------------------------------------------------------

INSERT INTO cliente (cod_cliente, nome, empresa, telefone) VALUES
	(1, 'Pedro Alves',  'Univas', '35999990001'),
	(2, 'Ana Lima',     'Univas', '35999990002'),
	(3, 'Giulia Costa', 'Univas', '35999990003');

INSERT INTO finalizacao (cod_final, valor_total) VALUES
	(1, 50.00),
	(2, 45.00),
	(3, 65.00);

INSERT INTO servico (cod_servico, atividade) VALUES
	(1, 'Formatação'),
	(2, 'Troca de peça'),
	(3, 'Limpeza e manutenção');

INSERT INTO tecnico (cod_tecnico, nome) VALUES
	(1, 'Marcos Pereira'),
	(2, 'Juliana Martins'),
	(3, 'Rafael Nunes');

INSERT INTO ordem_servico (cod_ordem, defeito, equipamento, cod_cliente, cod_tecnico, cod_final) VALUES
	(1, 'Não puxa o papel',      'Impressora',       1, 1, 1),
	(2, 'Não lê o chip',         'Leitor de cartão', 2, 2, 2),
	(3, 'Motor não funciona',    'Carrinho',         3, 3, 3);

INSERT INTO ordem_servico_item (cod_ordem, cod_servico) VALUES
	(1, 1),
	(2, 2),
	(3, 3);

-- Consultas de exemplo
SELECT nome, telefone FROM cliente;

-- Data de entrega de cada fechamento (UPDATE sempre com WHERE)
UPDATE finalizacao SET data_entrega = '2026-05-12 17:00:00' WHERE cod_final = 1;
UPDATE finalizacao SET data_entrega = '2026-05-15 17:00:00' WHERE cod_final = 2;
UPDATE finalizacao SET data_entrega = '2026-05-20 17:00:00' WHERE cod_final = 3;

-- Ordens de serviço com cliente, técnico e serviço executado
SELECT os.cod_ordem, os.equipamento, c.nome AS cliente,
       t.nome AS tecnico, s.atividade, f.valor_total
FROM ordem_servico os
INNER JOIN cliente c            ON c.cod_cliente = os.cod_cliente
INNER JOIN tecnico t            ON t.cod_tecnico = os.cod_tecnico
INNER JOIN ordem_servico_item i ON i.cod_ordem = os.cod_ordem
INNER JOIN servico s            ON s.cod_servico = i.cod_servico
LEFT JOIN  finalizacao f        ON f.cod_final = os.cod_final;
