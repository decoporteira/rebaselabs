require 'pg'
require 'csv'

db_config = {
  host: 'dataBaseContainer',
  dbname: 'data_base',
  user: 'postgres',
  password: '123456',
  port: 5432
}

conn = PG.connect(db_config)

create_table_sql = <<~SQL
  CREATE TABLE IF NOT EXISTS exams_result (
    id SERIAL,
    cpf VARCHAR(14),
    nome_paciente VARCHAR(255),
    email_paciente VARCHAR(255),
    data_nascimento_paciente DATE,
    endereco_paciente VARCHAR(255),
    cidade_paciente VARCHAR(100),
    estado_paciente VARCHAR(50),
    crm_medico VARCHAR(20),
    crm_medico_estado VARCHAR(50),
    nome_medico VARCHAR(255),
    email_medico VARCHAR(255),
    token_resultado_exame VARCHAR(100),
    data_exame DATE,
    tipo_exame VARCHAR(100),
    limites_tipo_exame VARCHAR(255),
    resultado_tipo_exame VARCHAR(255)
  );
SQL

conn.exec(create_table_sql)

puts '##################### Importação Iniciada #####################'

insert_query = <<~SQL
  INSERT INTO exams_result (cpf, nome_paciente, email_paciente, data_nascimento_paciente, endereco_paciente, cidade_paciente, estado_paciente, crm_medico, crm_medico_estado, nome_medico, email_medico, token_resultado_exame, data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame)
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
SQL
CSV.foreach("./data/data.csv", col_sep: ';', headers: true) do |row|
  conn.exec_params(insert_query, row.fields)
end

conn.close
