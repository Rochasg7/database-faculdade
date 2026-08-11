select * from cliente;
select * from cliente where cod_cliente = 1;

select nome from cliente where cod_cliente in(1,3);

select cod_final, data, data_entrega from finalizacao where data between '1899-12-01' and '2026-05-30';

select nome from cliente where nome like "g%";

select data from finalizacao;

select * from finalizacao;

update finalizacao set data = "1899-12-01";
update finalizacao set data = "1899-12-10" where cod_final = 2;
update finalizacao set data = "1899-12-05" where cod_final = 3;
select * from cliente order by cod_cliente ;
select * from cliente order by cod_cliente  desc;

select empresa.telefone from cliente where;


select f.cod_final as "Data Entrada", f.data_entrega as "Data Entrega" from finalizacao as "f";