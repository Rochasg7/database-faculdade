insert into login(id, email, senha, nivel_acesso)
	values(1, 'l1@l1.com', '1234', 1);

insert into login(id, email, senha, nivel_acesso)
	values(2, 'l2@l2.com', '1234', 1),
	(3, 'l3@l3.com', '1234', 1),
	(4, 'l4@l4.com', '1234', 1),
	(5, 'l5@l5.com', '1234', 1);

select * from login;

select id,email from login;

update login set nivel_acesso = 0;

delete from login;