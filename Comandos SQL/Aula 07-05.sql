create table servico(
	cod_servico int,
	atividade varchar(255),
	primary key(cod_servico)
);

create table `ordem de servico`(
	cod_ordem int,
	data datetime,
	defeito varchar(255),
	equipamento varchar(255),
	cod_cliente int,
	cod_tecnico int, 
	cod_final int,
	primary key(cod_ordem)
);

create table finalizacao(
	cod_final int,
	valor_total numeric,
	data datetime,
	data_entrega datetime,
	primary key(cod_final)
);

create table cliente(
	cod_cliente int,
	nome varchar(30),
	empresa varchar(255),
	telefone varchar(30),
	primary key(cod_cliente)
);

create table tecnico(
	cod_tecnico int primary key,
	nome varchar(30)
);

create table relacao_3(
	cod_ordem int,
	cod_servico int,
	constraint foreign key(cod_ordem)
	references `ordem de servico`(cod_ordem)
	on delete cascade
	on update cascade
);

alter table `ordem de servico` add constraint foreign key(cod_cliente)
	references cliente(cod_cliente)
	on delete cascade
	on update cascade;


alter table `ordem de servico` add constraint foreign key(cod_tecnico)
	references tecnico(cod_tecnico)
	on delete cascade
	on update cascade;


alter table `ordem de servico` add constraint foreign key(cod_final)
	references finalizacao(cod_final)
	on delete cascade
	on update cascade;

insert into cliente(cod_cliente, nome, empresa, telefone) 
	values(1, "Pedro", "Univas", "654654654564648"),
	(2, "Ana", "Univas", "654654654654"),
	(3, "Giulia", "Univas", "654564648");

insert into finalizacao(cod_final, valor_total)
	values(1, 50.00),
	(2, 45.00),
	(3, 65.00);

insert into servico(cod_servico, atividade)
	values(1, "Trabalhar"),
	(2, "Programar"),
	(3, "Executar");

insert into tecnico(cod_tecnico, nome)
	values(1, "Pedro"),
	(2, "Giulia"),
	(3, "Ana");

insert into `ordem de servico`(cod_ordem, equipamento, cod_cliente, cod_tecnico, cod_final)
values(1, "Impressora", 1, 1, 1),
	(2,"Leitor de cartão", 2, 2, 2),
	(3, "Carrinho", 3, 3, 3);

insert into relacao_3(cod_ordem, cod_servico)
	values(1, 1),
	(2, 2),
	(3, 3);

select nome,telefone from cliente;

update finalizacao set data_entrega = '1899-12-31';