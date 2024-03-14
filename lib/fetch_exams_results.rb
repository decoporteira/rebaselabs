require 'pg'

def fetch_exams_results
  db_config = {
    host: ENV['DBHOST'] || 'localhost',
    dbname: ENV['RACK_ENV'] || 'development',
    user: 'postgres',
    password: 'postgres',
    port: 5432
  }

  conn = PG.connect(db_config)

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

  exam_types = conn.exec(select_types_sql)
  conn.close
  exam_types
end