CREATE TABLE funcionarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE historico_carreira (
    id SERIAL PRIMARY KEY,
    funcionario_id INT NOT NULL,
    cargo_antigo VARCHAR(50),
    cargo_novo VARCHAR(50),
    salario_antigo NUMERIC(10, 2),
    salario_novo NUMERIC(10, 2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



create or replace function fn_alteracao_carreira()
returns trigger as $$
begin
	if old.cargo is distinct from new.cargo or old.salario is distinct from new.salario then
		INSERT INTO historico_carreira (funcionario_id, cargo_antigo, cargo_novo, salario_antigo, salario_novo)
        VALUES (OLD.id, OLD.cargo, NEW.cargo, OLD.salario, NEW.salario);
	end if;
return new;
end;
$$ language plpgsql;

create trigger trg_alteracao_carreira
after update on funcionarios
for each row execute
	function fn_alteracao_carreira()