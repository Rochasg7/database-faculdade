create schema portal_estudantil;

create table usuario(
	codUsuario int comment "identificador do usuario",
	login varchar(255) comment "login do usuario",
	senha varchar(255) comment "senha do usuario",
	cargo varchar(255) comment "cargo do usuario",
	primary key(codUsuario)
);

create table aluno(
	codAluno int comment "identificador do aluno",
	matriculaAluno int comment "matricula do aluno",
	cpf varchar(20) comment "cpf do aluno",
	dataNasc date comment "nascimento do aluno",
	nome varchar(255) comment "nome do aluno",
	codUsuario int comment "codigo do usuário do aluno",
	primary key(codAluno)
);

create table curso(
	codCurso int comment "identificador do curso",
	nome varchar(255) comment "nome do curso",
	codAluno int comment "identificador do aluno",
	codProfessor int comment "identificador do professor",
	codMateria int comment "identificador da Materia",
	primary key(codCurso)
);

create table professor(
	codProfessor int comment "identificador do professor",
	dataNasc date comment "data de nascimento do professor",
	matriculaProfessor int comment "matricula do professor",
	cpf varchar(20) comment "cpf do professor",
	nome varchar(255) comment "nome do professor",
	codUsuario int comment "identificador do usuario",
	primary key(codProfessor)
);

create table materia(
	codMateria int comment "identificador da materia",
	horario time comment "horario da aula da materia",
	nome varchar(255) comment "nome da materia",
	sala varchar(255) comment "sala da materia",
	codProfessor int comment "identificador do professor",
	primary key(codMateria)
);

create table professorCurso(
	codProfessorCurso int comment "identificador do ProfessorCurso",
	codProfessor int comment "identificador do professor",
	codCurso int comment "identificador do curso", 
	primary key(codProfessorCurso)
);

create table cursoMateria(
	codCursoMateria int comment "identificador do CursoMateria",
	codMateria int comment "identificador da materia",
	codCurso int comment "identificador do curso",
	primary key(codCursoMateria)
);

ALTER TABLE aluno
	ADD CONSTRAINT FOREIGN key(codUsuario)
	REFERENCES usuario(codUsuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professor
	ADD CONSTRAINT FOREIGN key(codUsuario)
	REFERENCES usuario(codUsuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professorCurso
	ADD CONSTRAINT FOREIGN key(codProfessor)
	REFERENCES professor(codProfessor)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE professorCurso
	ADD CONSTRAINT FOREIGN key(codCurso)
	REFERENCES curso(codCurso)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE cursoMateria
	ADD CONSTRAINT FOREIGN key(codMateria)
	REFERENCES materia(codMateria)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE cursoMateria
	ADD CONSTRAINT FOREIGN key(codCurso)
	REFERENCES curso(codCurso)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

ALTER TABLE curso
	ADD CONSTRAINT FOREIGN key(codAluno)
	REFERENCES aluno(codAluno)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

insert into usuario
	(codUsuario,login,senha,cargo)
	VALUES(1, "Otavio", 1234, "Aluno"),
	(2, "Gustavo", 1234, "Professor");

insert into aluno
	(codAluno,matriculaAluno,cpf,dataNasc,nome,codUsuario)
	values(1, 1, "111111111", '2005-04-04', "Otavio", 1);

insert into professor
	(codProfessor,dataNasc,matriculaProfessor,cpf,nome,codUsuario) 
	values(1, '2000-01-01', 1, "111111111", "Gustavo", 2);

insert into materia
	(codMateria,horario,nome,sala,codProfessor) 
	values(1, '20:00:00', "SQL", "Sala 05", 1);

insert into curso
	(codCurso,nome,codAluno,codProfessor,codMateria) 
	values(1, "Sistemas", 1, 1, 1);

insert into professorcurso
	(codProfessorCurso,codProfessor,codCurso) 
	values(1, 1, 1);

insert into cursomateria
	(codCursoMateria,codMateria,codCurso) 
	values(1, 1, 1);

select usuario.cargo, aluno.nome from usuario inner join aluno on usuario.codUsuario = aluno.codAluno;

update aluno set nome = "Otávio" where codAluno = 1;

	
