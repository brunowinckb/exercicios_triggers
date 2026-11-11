CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);


CREATE TABLE clientes_deletados_log (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_remocao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);




create or replace function fn_atualiza_clientes_deletados()
returns trigger as $$
begin
	INSERT INTO clientes_deletados_log (cliente_id, nome, email) VALUES 
		(OLD.id, OLD.nome, OLD.email);

	update clientes set ativo = FALSE where id = old.id;

	return null;
return new;
end;
$$ language plpgsql;

create trigger trg_atualiza_clientes_deletados
before delete on clientes
for each row execute
	function fn_atualiza_clientes_deletados()