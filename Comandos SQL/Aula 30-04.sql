create table pedido(
	id int,
	telefone_cliente varchar(255),
	id_entregador int,
	status varchar(255),
	taxa_entrega varchar(255),
	data datetime,
	primary key(id)
);

create table item_pedido(
	id_marmita int,
	id_pedido int,
	quantidade int
);

create table entregador(
	id int,
	id_empresa int,
	nome varchar(255),
	cpf varchar(255),
	rg varchar(255),
	celular varchar(255),
	primary key(id)
);

create table login(
	id int,
	email varchar(255),
	senha varchar(255),
	nivel_acesso int, 
	primary key(id)
);

create table cliente(
	telefone varchar(255),
	nome varchar(255),
	endereco varchar(255),
	pontorecerencia varchar(255),
	nascimento date,
	primary key(telefone)
);

create table empresa(
	id int,
	nome varchar(255),
	cnpj varchar(255),
	email varchar(255),
	telefone varchar(255),
	endereco varchar(255),
	primary key(id)
);

create table marmita(
	id int,
	nome varchar(255),
	descricao mediumText,
	tamanho varchar(255),
	valor varchar(255),
	primary key(id)
);

alter table entregador 
	ADD CONSTRAINT FOREIGN key(id_empresa)
	REFERENCES empresa(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table pedido 
	ADD CONSTRAINT FOREIGN key(telefone_cliente)
	REFERENCES cliente(telefone)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table pedido 
	ADD CONSTRAINT FOREIGN key(id_entregador)
	REFERENCES entregador(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table item_pedido 
	ADD CONSTRAINT FOREIGN key(id_marmita)
	REFERENCES marmita(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

alter table item_pedido 
	ADD CONSTRAINT FOREIGN key(id_pedido)
	REFERENCES pedido(id)
	ON DELETE cascade;

drop table item_pedido;
drop table entregador;
drop table login;
drop table cliente;
drop table empresa;
drop table marmita;
drop table pedido;
	