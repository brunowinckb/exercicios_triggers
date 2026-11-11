CREATE TABLE estoque (
    id serial PRIMARY key,
    nome_item VARCHAR(100) NOT NULL,
    quantidade INT not null DEFAULT 0
)



create or replace function fn_valida_menorq0()
returns trigger as $$
begin
	if new.quantidade <0 then
		raise exception 'Operação cancelada! O item "%" não pode ter estoque negativo', new.nome_item;
	end if;
return new;
end;
$$ language plpgsql;

create trigger trg_valida_estoque
before insert or update on estoque
for each row execute 
	function fn_valida_menorq0();