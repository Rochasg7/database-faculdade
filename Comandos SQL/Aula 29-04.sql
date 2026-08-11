create table produto(
	cod int,
	nome varchar(20),
	id_categoria int,
	primary key(cod));

create table categoria(
	id int,
	nome varchar(20)
);

alter table categoria add primary key(id);

show tables from chaves;
show columns from chaves.categoria;
show columns from chaves.produto;

drop table categoria;

create table categoria(
	id int primary key comment "id da categoria",
	nome varchar(20) default 'NI' not null comment "nome da categoria"
);

alter table produto 
	modify nome varchar(30)
	not null
	comment "Nome do produto";


ALTER TABLE produto
	ADD CONSTRAINT FOREIGN key(id_categoria)
	REFERENCES categoria(id)
	ON DELETE CASCADE
	uo UPDATE CASCADE;