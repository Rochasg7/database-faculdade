CREATE TABLE alunos (
 id_aluno INT,
 nome VARCHAR(100),
 cidade VARCHAR(50),
 idade INT,
 status VARCHAR(20)
);

CREATE TABLE professores (
 id_professor INT,
 nome VARCHAR(100),
 especialidade VARCHAR(50),
 salario DECIMAL(10,2)
);

CREATE TABLE cursos (
 id_curso INT,
 nome_curso VARCHAR(100),
 carga_horaria INT,
 id_professor INT
);

CREATE TABLE matriculas (
 id_matricula INT,
 id_aluno INT,
 id_curso INT,
 data_matricula DATE,
 situacao VARCHAR(20)
);

alter table alunos add primary key(id_aluno);

alter table professores add primary key(id_professor);

alter table cursos add primary key(id_curso);

alter table matriculas add primary key(id_matricula);

alter table cursos 
	ADD CONSTRAINT FOREIGN key(id_professor)
	REFERENCES professores(id_professor)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table matriculas 
	ADD CONSTRAINT FOREIGN key(id_aluno)
	REFERENCES alunos(id_aluno)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table matriculas 
	ADD CONSTRAINT FOREIGN key(id_curso)
	REFERENCES cursos(id_curso)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

insert into alunos(id_aluno, nome, cidade, idade, status)
	values(1, "João", "Pouso Alegre", 21, "Ativo"),
	(2, "Ana", "Pouso Alegre", 21, "Inativo"),
	(3, "Pedro", "Pouso Alegre", 60, "Inativo"),
	(4, "Giulia", "Pouso Alegre", 28, "Inativo"),
	(5, "Paulo", "Pouso Alegre", 21, "Ativo"),
	(6, "Carlos", "Pouso Alegre", 21, "Ativo"),
	(7, "Sergio", "Pouso Alegre", 20, "Inativo"),
	(8, "Careca", "Pouso Alegre", 45, "Ativo"),
	(9, "Pedra", "Pouso Alegre", 40, "Ativo"),
	(10, "Carregador", "Pouso Alegre", 30, "Ativo");

insert into professores(id_professor, nome, especialidade, salario)
	values(1, "Alex", "Colar durex", 7000),
	(2, "bernardo", "Todos precisamos", 6500),
	(3, "Nem eu", "Trabalhar", 12000),
	(4, "Irineu", "Você não sabe", 7000),
	(5, "Calvo", "Careca", 7000);

insert into cursos(id_curso, nome_curso, carga_horaria, id_professor)
	values(1, "Engenharia da Pesca", 5, 1),
	(2, "Coçar isso", 5, 5),
	(3, "UNA", 5, 2),
	(4, "Encher a cara", 5, 4),
	(5, "Java", 5, 3);

insert into matriculas(id_matricula, id_aluno, id_curso, data_matricula, situacao)
	values(1, 1, 1, '2026-05-14', "Ativo"),
		(2, 2, 2, '2026-02-14', "Inativo"),
		(3, 3, 3, '2026-03-14', "Ativo"),
		(4, 4, 4, '2026-01-14', "Inativo"),
		(5, 5, 5, '2025-12-14', "Ativo"),
		(6, 6, 3, '2025-04-20', "Ativo"),
		(7, 7, 3, '2025-06-10', "Inativo"),
		(8, 8, 4, '2025-05-14', "Ativo"),
		(9, 9, 2, '2025-04-14', "Inativo"),
		(10, 10, 1, '2022-06-06;', "Ativo"),
		(11, 10, 2, '2023-11-20', "Ativo"),
		(12, 5, 5, '2026-05-10', "Inativo"),
		(13, 8, 5, '2022-03-03', "Inativo"),
		(14, 6, 5, '2020-05-20', "Ativo"),
		(15, 2, 1, '2020-03-14', "Inativo");

select * from alunos where status like "Ativo";

select * from alunos order by nome;

select * from professores order by salario desc;

select * from cursos where carga_horaria > 2 order by carga_horaria desc;

select nome as aluno, cidade as cidade_aluno, idade as idade_aluno from alunos;

select * from professores where salario > 5000;

select * from alunos where idade between 18 and 25;

select * from cursos where nome_curso like "E%";

select * from alunos where cidade like "Pouso Alegre" and status like "Ativo";
