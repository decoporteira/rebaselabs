require 'pg'

def fetch_exams_data
  db_config = {
    host: ENV['DBHOST'] || 'localhost',
    dbname: ENV['RACK_ENV'] || 'development',
    user: 'postgres',
    password: 'postgres',
    port: 5432
  }

  conn = PG.connect(db_config)

  select_data_sql = <<-SQL
    SELECT 
      exams.token_resultado_exame, 
      exams.id,
      exams.data_exame,
      patients.cpf,
      patients.nome_paciente,
      patients.email_paciente ,
      patients.data_nascimento_paciente,
      patients.endereco_paciente,
      patients.cidade_paciente,
      patients.estado_paciente,
      doctors.nome_medico,
      doctors.crm_medico,
      doctors.crm_medico_estado,
      doctors.email_medico
    FROM exams 
      JOIN patients ON exams.patient_id = patients.id
      JOIN doctors ON exams.doctor_id = doctors.id;
  SQL

  results = conn.exec(select_data_sql)
  conn.close

  results
end