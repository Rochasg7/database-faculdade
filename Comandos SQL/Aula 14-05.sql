-- =====================================================================
-- Aula 14/05 | Escola: alunos, professores, cursos e matrículas
-- ATENÇÃO: recria o schema "escola" do zero a cada execução.
--
-- Regras de integridade
--   * cursos -> professores: SET NULL (apagar o professor não apaga o curso).
--   * matriculas -> alunos: CASCADE (sai o aluno, saem suas matrículas).
--   * matriculas -> cursos: RESTRICT (curso com matrícula não é apagado).
-- Todos os dados de exemplo são fictícios.
-- =====================================================================

DROP SCHEMA IF EXISTS escola;
CREATE SCHEMA escola DEFAULT CHARACTER SET utf8mb4;
USE escola;

CREATE TABLE alunos (
	id_aluno INT AUTO_INCREMENT,
	nome     VARCHAR(100) NOT NULL,
	cidade   VARCHAR(50),
	idade    INT,
	status   VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	PRIMARY KEY (id_aluno)
);

CREATE TABLE professores (
	id_professor  INT AUTO_INCREMENT,
	nome          VARCHAR(100) NOT NULL,
	especialidade VARCHAR(50),
	salario       DECIMAL(10,2),
	PRIMARY KEY (id_professor)
);

CREATE TABLE cursos (
	id_curso      INT AUTO_INCREMENT,
	nome_curso    VARCHAR(100) NOT NULL,
	carga_horaria INT NOT NULL COMMENT 'em horas',
	id_professor  INT,
	PRIMARY KEY (id_curso),
	CONSTRAINT fk_cursos_professor FOREIGN KEY (id_professor)
		REFERENCES professores (id_professor)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE matriculas (
	id_matricula   INT AUTO_INCREMENT,
	id_aluno       INT NOT NULL,
	id_curso       INT NOT NULL,
	data_matricula DATE NOT NULL,
	situacao       VARCHAR(20) NOT NULL,
	PRIMARY KEY (id_matricula),
	CONSTRAINT fk_matriculas_aluno FOREIGN KEY (id_aluno)
		REFERENCES alunos (id_aluno)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_matriculas_curso FOREIGN KEY (id_curso)
		REFERENCES cursos (id_curso)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- Dados de exemplo
-- ---------------------------------------------------------------------

INSERT INTO alunos (id_aluno, nome, cidade, idade, status) VALUES
	(1,  'João',      'Pouso Alegre', 21, 'Ativo'),
	(2,  'Ana',       'Pouso Alegre', 21, 'Inativo'),
	(3,  'Pedro',     'Pouso Alegre', 60, 'Inativo'),
	(4,  'Giulia',    'Pouso Alegre', 28, 'Inativo'),
	(5,  'Paulo',     'Pouso Alegre', 21, 'Ativo'),
	(6,  'Carlos',    'Pouso Alegre', 21, 'Ativo'),
	(7,  'Sérgio',    'Pouso Alegre', 20, 'Inativo'),
	(8,  'Bruno',     'Pouso Alegre', 45, 'Ativo'),
	(9,  'Patrícia',  'Pouso Alegre', 40, 'Ativo'),
	(10, 'Fernando',  'Pouso Alegre', 30, 'Ativo');

INSERT INTO professores (id_professor, nome, especialidade, salario) VALUES
	(1, 'Alex Moreira',   'Engenharia de Software', 7000.00),
	(2, 'Bernardo Reis',  'Redes de Computadores',  6500.00),
	(3, 'Renata Dias',    'Programação',           12000.00),
	(4, 'Irineu Campos',  'Algoritmos',             7000.00),
	(5, 'Cláudio Ramos',  'Matemática',             7000.00);

INSERT INTO cursos (id_curso, nome_curso, carga_horaria, id_professor) VALUES
	(1, 'Engenharia de Software', 80, 1),
	(2, 'Cálculo',                60, 5),
	(3, 'Redes de Computadores',  60, 2),
	(4, 'Estrutura de Dados',     80, 4),
	(5, 'Java',                   60, 3);

INSERT INTO matriculas (id_matricula, id_aluno, id_curso, data_matricula, situacao) VALUES
	(1,  1,  1, '2026-05-14', 'Ativo'),
	(2,  2,  2, '2026-02-14', 'Inativo'),
	(3,  3,  3, '2026-03-14', 'Ativo'),
	(4,  4,  4, '2026-01-14', 'Inativo'),
	(5,  5,  5, '2025-12-14', 'Ativo'),
	(6,  6,  3, '2025-04-20', 'Ativo'),
	(7,  7,  3, '2025-06-10', 'Inativo'),
	(8,  8,  4, '2025-05-14', 'Ativo'),
	(9,  9,  2, '2025-04-14', 'Inativo'),
	(10, 10, 1, '2022-06-06', 'Ativo'),
	(11, 10, 2, '2023-11-20', 'Ativo'),
	(12, 5,  5, '2026-05-10', 'Inativo'),
	(13, 8,  5, '2022-03-03', 'Inativo'),
	(14, 6,  5, '2020-05-20', 'Ativo'),
	(15, 2,  1, '2020-03-14', 'Inativo');

-- ---------------------------------------------------------------------
-- Consultas
-- ---------------------------------------------------------------------

-- Alunos ativos
SELECT * FROM alunos WHERE status = 'Ativo';

-- Alunos em ordem alfabética
SELECT * FROM alunos ORDER BY nome;

-- Professores do maior para o menor salário
SELECT * FROM professores ORDER BY salario DESC;

-- Cursos com mais de 60 horas, do maior para o menor
SELECT * FROM cursos WHERE carga_horaria > 60 ORDER BY carga_horaria DESC;

-- Apelidos nas colunas
SELECT nome AS aluno, cidade AS cidade_aluno, idade AS idade_aluno FROM alunos;

-- Professores com salário acima de 5000
SELECT * FROM professores WHERE salario > 5000;

-- Alunos entre 18 e 25 anos
SELECT * FROM alunos WHERE idade BETWEEN 18 AND 25;

-- Cursos cujo nome começa com E
SELECT * FROM cursos WHERE nome_curso LIKE 'E%';

-- Alunos ativos de Pouso Alegre
SELECT * FROM alunos WHERE cidade = 'Pouso Alegre' AND status = 'Ativo';

-- JOIN: aluno, curso e professor de cada matrícula ativa
SELECT a.nome AS aluno, c.nome_curso AS curso, p.nome AS professor
FROM matriculas m
INNER JOIN alunos a     ON a.id_aluno = m.id_aluno
INNER JOIN cursos c     ON c.id_curso = m.id_curso
LEFT JOIN  professores p ON p.id_professor = c.id_professor
WHERE m.situacao = 'Ativo'
ORDER BY a.nome;

-- GROUP BY: total de matrículas por curso
SELECT c.nome_curso, COUNT(m.id_matricula) AS total_matriculas
FROM cursos c
LEFT JOIN matriculas m ON m.id_curso = c.id_curso
GROUP BY c.id_curso, c.nome_curso
ORDER BY total_matriculas DESC;
