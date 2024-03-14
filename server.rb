require 'sinatra'
require 'pg'
require 'json'
require 'csv'
require_relative 'import_job'
require './lib/fetch_exams_data'
require './lib/fetch_exams_results'
require './lib/format_results'
require './lib/search_exam_result'

ENV['DB_NAME'] = 'test' if ENV['RACK_ENV'] == 'test'

get '/' do
  content_type 'text/html'
  File.open('public/index.html')
end

get '/styles.css' do
  content_type 'text/css'
  File.read('styles.css')
end

get '/tests' do
  results = fetch_exams_data
  exam_types = fetch_exams_results
  content_type :json 
  format_results(results, exam_types).to_json
end

post '/tests' do
  query = params['query']
  redirect "/tests/#{query}"
end

get '/tests/:query' do
  query = params['query']
  results = search_exam_result(query)
  exam_types = fetch_exams_results

  content_type :json
  format_results(results, exam_types).to_json
end

post '/import' do
  if params['file'] && (params['file']['type'] == 'text/csv')
    file = params[:file][:tempfile]
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    random_string = SecureRandom.hex(4)

    csv_content = CSV.read(file, headers: true, col_sep: ';')

    CSV.open("data/temp/new_data#{timestamp}_#{random_string}.csv", 'w', col_sep: ';') do |csv|
      csv << csv_content.headers

      csv_content.each do |row|
        csv << row
      end
    end

    file_path = "data/temp/new_data#{timestamp}_#{random_string}.csv"
    ImportJob.perform_async(file_path)
    redirect '/'
  else
    { status: 'error', message: 'Erro: Arquivo inválido.' }.to_json
  end
end

set :port, 3000
set :bind, '0.0.0.0'
