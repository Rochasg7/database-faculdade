-- =====================================================================
-- Portal Estudantil | Trabalho 02 (Banco de Dados, UNIVAS)
-- Script de criação do schema, tabelas, dados de exemplo e consultas.
-- SGBD: MySQL 8+ ou MariaDB 10.11+ (validado em MariaDB 10.11) | Cliente: DBeaver
--
-- ATENÇÃO: o script recria o schema do zero (DROP SCHEMA IF EXISTS).
-- Se já existir um schema "portal_estudantil" com dados seus, eles serão
-- apagados. Execute o arquivo inteiro (Alt+X no DBeaver).
--
-- Regras de integridade adotadas
--   * Tabelas de ligação (professor_curso, curso_materia): CASCADE nos dois
--     lados, pois só guardam o vínculo.
--   * matricula: apagar o aluno remove suas matrículas (CASCADE); apagar um
--     curso com matrículas é bloqueado (RESTRICT), para não perder histórico.
--   * usuario -> aluno/professor: RESTRICT, para não apagar o histórico
--     acadêmico por engano ao remover um login.
--   * materia -> professor: SET NULL (a matéria continua existindo sem
--     professor até alguém ser designado).
--   * ON UPDATE CASCADE em todas as chaves estrangeiras.
-- =====================================================================

DROP SCHEMA IF EXISTS portal_estudantil;
CREATE SCHEMA portal_estudantil DEFAULT CHARACTER SET utf8mb4;
USE portal_estudantil;

-- ---------------------------------------------------------------------
-- Tabelas
-- ---------------------------------------------------------------------

CREATE TABLE usuario (
	codUsuario INT AUTO_INCREMENT COMMENT 'identificador do usuario',
	login      VARCHAR(100) NOT NULL COMMENT 'login do usuario',
	senha      VARCHAR(255) NOT NULL COMMENT 'hash da senha (nunca texto puro)',
	cargo      VARCHAR(50)  NOT NULL COMMENT 'cargo do usuario: Aluno, Professor...',
	PRIMARY KEY (codUsuario),
	UNIQUE KEY uq_usuario_login (login)
);

CREATE TABLE aluno (
	codAluno       INT AUTO_INCREMENT COMMENT 'identificador do aluno',
	matriculaAluno INT          NOT NULL COMMENT 'matricula do aluno',
	cpf            VARCHAR(14)  NOT NULL COMMENT 'cpf do aluno',
	dataNasc       DATE         NOT NULL COMMENT 'nascimento do aluno',
	nome           VARCHAR(255) NOT NULL COMMENT 'nome do aluno',
	codUsuario     INT          NOT NULL COMMENT 'usuario (login) do aluno',
	PRIMARY KEY (codAluno),
	UNIQUE KEY uq_aluno_matricula (matriculaAluno),
	UNIQUE KEY uq_aluno_cpf (cpf),
	UNIQUE KEY uq_aluno_usuario (codUsuario),
	CONSTRAINT fk_aluno_usuario FOREIGN KEY (codUsuario)
		REFERENCES usuario (codUsuario)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE professor (
	codProfessor       INT AUTO_INCREMENT COMMENT 'identificador do professor',
	matriculaProfessor INT          NOT NULL COMMENT 'matricula do professor',
	cpf                VARCHAR(14)  NOT NULL COMMENT 'cpf do professor',
	dataNasc           DATE         NOT NULL COMMENT 'data de nascimento do professor',
	nome               VARCHAR(255) NOT NULL COMMENT 'nome do professor',
	codUsuario         INT          NOT NULL COMMENT 'usuario (login) do professor',
	PRIMARY KEY (codProfessor),
	UNIQUE KEY uq_professor_matricula (matriculaProfessor),
	UNIQUE KEY uq_professor_cpf (cpf),
	UNIQUE KEY uq_professor_usuario (codUsuario),
	CONSTRAINT fk_professor_usuario FOREIGN KEY (codUsuario)
		REFERENCES usuario (codUsuario)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE curso (
	codCurso INT AUTO_INCREMENT COMMENT 'identificador do curso',
	nome     VARCHAR(255) NOT NULL COMMENT 'nome do curso',
	PRIMARY KEY (codCurso),
	UNIQUE KEY uq_curso_nome (nome)
);

CREATE TABLE materia (
	codMateria   INT AUTO_INCREMENT COMMENT 'identificador da materia',
	nome         VARCHAR(255) NOT NULL COMMENT 'nome da materia',
	horario      TIME COMMENT 'horario da aula da materia',
	sala         VARCHAR(50) COMMENT 'sala da materia',
	codProfessor INT COMMENT 'professor responsavel pela materia',
	PRIMARY KEY (codMateria),
	CONSTRAINT fk_materia_professor FOREIGN KEY (codProfessor)
		REFERENCES professor (codProfessor)
		ON DELETE SET NULL ON UPDATE CASCADE
);

-- N:N entre professor e curso
CREATE TABLE professor_curso (
	codProfessorCurso INT AUTO_INCREMENT COMMENT 'identificador do vinculo',
	codProfessor      INT NOT NULL COMMENT 'identificador do professor',
	codCurso          INT NOT NULL COMMENT 'identificador do curso',
	PRIMARY KEY (codProfessorCurso),
	UNIQUE KEY uq_professor_curso (codProfessor, codCurso),
	CONSTRAINT fk_pc_professor FOREIGN KEY (codProfessor)
		REFERENCES professor (codProfessor)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_pc_curso FOREIGN KEY (codCurso)
		REFERENCES curso (codCurso)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- N:N entre curso e materia
CREATE TABLE curso_materia (
	codCursoMateria INT AUTO_INCREMENT COMMENT 'identificador do vinculo',
	codCurso        INT NOT NULL COMMENT 'identificador do curso',
	codMateria      INT NOT NULL COMMENT 'identificador da materia',
	PRIMARY KEY (codCursoMateria),
	UNIQUE KEY uq_curso_materia (codCurso, codMateria),
	CONSTRAINT fk_cm_curso FOREIGN KEY (codCurso)
		REFERENCES curso (codCurso)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_cm_materia FOREIGN KEY (codMateria)
		REFERENCES materia (codMateria)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- N:N entre aluno e curso (requisito "aluno realiza matricula em curso")
CREATE TABLE matricula (
	codMatricula  INT AUTO_INCREMENT COMMENT 'identificador da matricula',
	codAluno      INT         NOT NULL COMMENT 'identificador do aluno',
	codCurso      INT         NOT NULL COMMENT 'identificador do curso',
	dataMatricula DATE        NOT NULL COMMENT 'data em que a matricula foi feita',
	situacao      VARCHAR(20) NOT NULL DEFAULT 'Ativa' COMMENT 'Ativa, Trancada, Cancelada...',
	PRIMARY KEY (codMatricula),
	UNIQUE KEY uq_matricula_aluno_curso (codAluno, codCurso),
	CONSTRAINT fk_matricula_aluno FOREIGN KEY (codAluno)
		REFERENCES aluno (codAluno)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_matricula_curso FOREIGN KEY (codCurso)
		REFERENCES curso (codCurso)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- Dados de exemplo (todos fictícios)
-- A senha é guardada como hash SHA-256. Em uma aplicação real, o hash é
-- feito na aplicação com algoritmo próprio para senhas (bcrypt, argon2).
-- ---------------------------------------------------------------------

INSERT INTO usuario (codUsuario, login, senha, cargo) VALUES
	(1, 'maria.silva',  SHA2('senha123', 256), 'Aluno'),
	(2, 'carlos.souza', SHA2('senha123', 256), 'Professor');

INSERT INTO aluno (codAluno, matriculaAluno, cpf, dataNasc, nome, codUsuario) VALUES
	(1, 1001, '52998224725', '2005-04-04', 'Maria Silva', 1);

INSERT INTO professor (codProfessor, matriculaProfessor, cpf, dataNasc, nome, codUsuario) VALUES
	(1, 2001, '11144477735', '1980-01-01', 'Carlos Souza', 2);

INSERT INTO materia (codMateria, nome, horario, sala, codProfessor) VALUES
	(1, 'Banco de Dados', '20:00:00', 'Sala 05', 1);

INSERT INTO curso (codCurso, nome) VALUES
	(1, 'Sistemas de Informação');

INSERT INTO professor_curso (codProfessorCurso, codProfessor, codCurso) VALUES
	(1, 1, 1);

INSERT INTO curso_materia (codCursoMateria, codCurso, codMateria) VALUES
	(1, 1, 1);

INSERT INTO matricula (codMatricula, codAluno, codCurso, dataMatricula, situacao) VALUES
	(1, 1, 1, '2026-02-02', 'Ativa');

-- ---------------------------------------------------------------------
-- Consultas de exemplo
-- ---------------------------------------------------------------------

-- Alunos com seu login e cargo de acesso
SELECT a.nome AS aluno, u.login, u.cargo
FROM aluno a
INNER JOIN usuario u ON u.codUsuario = a.codUsuario;

-- Cursos, matérias e professor responsável por cada matéria
SELECT c.nome AS curso, m.nome AS materia, p.nome AS professor
FROM curso c
INNER JOIN curso_materia cm ON cm.codCurso = c.codCurso
INNER JOIN materia m        ON m.codMateria = cm.codMateria
LEFT JOIN  professor p      ON p.codProfessor = m.codProfessor;

-- Quantidade de alunos matriculados por curso
SELECT c.nome AS curso, COUNT(mt.codMatricula) AS total_matriculas
FROM curso c
LEFT JOIN matricula mt ON mt.codCurso = c.codCurso AND mt.situacao = 'Ativa'
GROUP BY c.codCurso, c.nome
ORDER BY total_matriculas DESC;

-- Atualização com WHERE: sempre filtre pela chave primária
UPDATE aluno SET nome = 'Maria Silva Souza' WHERE codAluno = 1;
