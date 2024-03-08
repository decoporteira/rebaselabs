require 'sinatra'
require 'pg'
require 'json'

get '/' do
  'Olá'
end

get '/home' do
  headers 'Access-Control-Allow-Origin' => '*'
  content_type 'text/html'
  File.open('index.html')
end

get '/styles.css' do
  content_type 'text/css'
  File.read('styles.css')
end

get '/tests' do
 
  db_config = {
    host: (ENV['DBHOST'] || 'localhost'),
    dbname: 'postgres',
    user: 'postgres',
    password: '123456',
    port: 5432
  }

  conn = PG.connect(db_config)
  select_data_sql = 'SELECT 
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
    FROM exams JOIN patients ON exams.patient_id = patients.id
    JOIN doctors ON exams.doctor_id = doctors.id;'

  results = conn.exec(select_data_sql)

  select_types_sql = 'SELECT 
    exams.token_resultado_exame, 
    exams.id,
    exam_types.id,
    exam_types.exam_id,
    exam_types.tipo_exame,
    exam_types.limites_tipo_exame,
    exam_types.resultado_tipo_exame
    FROM exams 
    JOIN exam_types ON exams.id = exam_types.exam_id
    WHERE exam_types.exam_id = exams.id;'

  content_type :json
  
  exam_types = conn.exec(select_types_sql)

  formatted_results = results.map do |row|
    exam_types_for_exam = exam_types.select { |exam| exam['exam_id'] == row['id'] }
    {
      "token_resultado_exame": row["token_resultado_exame"],  
      "id": row["id"],
      "data_exame": row["data_exame"],
      "cpf": row["cpf"],
      "nome_paciente": row["nome_paciente"],
      "email_paciente": row["email_paciente"],
      "data_nascimento_paciente": row["data_nascimento_paciente"],
      "endereco_paciente": row["endereco_paciente"],
      "cidade_paciente": row["cidade_paciente"],
      "estado_paciente": row["estado_paciente"],
      "doctor": {
        "nome_medico": row["nome_medico"],
        "crm_medico": row["crm_medico"],
        "crm_medico_estado": row["crm_medico_estado"],
        "email_medico": row["email_medico"]
      },
      "tests": exam_types_for_exam.map do |exam_row|
        {
          "tipo_exame": exam_row["tipo_exame"],
          "limites_tipo_exame": exam_row["limites_tipo_exame"],
          "resultado_tipo_exame": exam_row["resultado_tipo_exame"]
        }
      end
    }
  end
  formatted_results.to_json
end
