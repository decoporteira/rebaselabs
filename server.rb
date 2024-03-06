require 'sinatra'
require 'pg'

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
    dbname: 'data_base',
    user: 'postgres',
    password: '123456',
    port: 5432
  }

  conn = PG.connect(db_config)
  select_data_sql = 'SELECT * FROM exams_result;'
  result = conn.exec(select_data_sql)
  content_type :json
  result.to_a.to_json
end
