class FileImporter

  def self.import(file)
    require 'pg'
    require 'csv'

    ENV['DB_NAME'] = 'test' if ENV['RACK_ENV'] == 'test'
    db_config = {
      host: ENV['DBHOST'] || 'localhost',
      dbname: ENV['RACK_ENV'] || 'development',
      user: 'postgres',
      password: 'postgres',
      port: 5432
    }

    conn = PG.connect(db_config)

    puts '##################### Importação Iniciada #####################'

    CSV.foreach(file, col_sep: ';', headers: true) do |row|
      insert_patient_query = <<~SQL
        INSERT INTO patients (cpf, nome_paciente, email_paciente, data_nascimento_paciente, endereco_paciente, cidade_paciente, estado_paciente)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        ON CONFLICT (cpf)
        DO NOTHING;
      SQL
      conn.exec_params(insert_patient_query, [
        row['cpf'],
        row['nome paciente'],
        row['email paciente'],
        row['data nascimento paciente'],
        row['endereço/rua paciente'],
        row['cidade paciente'],
        row['estado patiente']
      ])

      insert_doctor_query = <<~SQL
        INSERT INTO doctors (nome_medico, crm_medico, crm_medico_estado, email_medico)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (crm_medico)
        DO NOTHING;
      SQL
      conn.exec_params(insert_doctor_query, [
        row['nome médico'],
        row['crm médico'],
        row['crm médico estado'],
        row['email médico']
      ])

      patient_id = conn.exec_params("SELECT id FROM patients WHERE cpf = $1", [row['cpf']]).getvalue(0, 0)
      doctor_id = conn.exec_params("SELECT id FROM doctors WHERE crm_medico = $1", [row['crm médico']]).getvalue(0, 0)
      insert_exam_query = <<~SQL
        INSERT INTO exams (token_resultado_exame, data_exame, patient_id, doctor_id)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (token_resultado_exame)
        DO NOTHING;
      SQL
      conn.exec_params(insert_exam_query, [
        row['token resultado exame'],
        row['data exame'],
        patient_id,
        doctor_id
      ])

      exam_id = conn.exec_params("SELECT id FROM exams WHERE token_resultado_exame = $1", [row['token resultado exame']]).getvalue(0, 0)

      insert_exam_types_query = <<~SQL
        INSERT INTO exam_types (tipo_exame, limites_tipo_exame, resultado_tipo_exame, exam_id)
        VALUES ($1, $2, $3, $4)
      SQL
        conn.exec_params(insert_exam_types_query, [
          row['tipo exame'],
          row['limites tipo exame'],
          row['resultado tipo exame'],
          exam_id
        ])
    end
    conn.close
  end
end
