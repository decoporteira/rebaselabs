ENV['RACK_ENV'] = 'test'

require_relative '../../server'
require 'rack/test'
require 'spec_helper'

def clean_data_base
  conn = PG.connect(host: 'localhost', dbname: 'test', user: 'postgres', password: 'postgres', port: 5432)
  conn.exec('DELETE FROM exam_types')
  conn.exec('DELETE FROM exams cascade')
  conn.exec('DELETE FROM patients cascade')
  conn.exec('DELETE FROM doctors cascade')
end

RSpec.describe 'CVS Import App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'e testa o json do endpoint com todos os exames' do
    data = 'spec/assets/test_data.csv'
    post '/import', file: Rack::Test::UploadedFile.new(data, 'text/csv')

    get '/tests'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Emilly Batista Neto')
    expect(last_response.content_type).to eq('application/json')
    conn = PG.connect(host: 'localhost', dbname: 'test', user: 'postgres', password: 'postgres', port: 5432)
    result = conn.exec('SELECT COUNT(*) FROM patients')
    expect(result[0]['count'].to_i).to eq(1)

  end

  it 'Vê os resultados na página', type: :feature do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('text/html;charset=utf-8')
    expect(last_response.body).to include('Exames')
  end

  it 'e testa o json do endpoint com a pesquisa por token de exame', type: :feature do
    get '/tests/IQCZ17'
    expect(last_response).to be_ok
    response_json = JSON.parse(last_response.body)
    expect(last_response.content_type).to eq('application/json')
    expect(last_response.body).to include('Emilly Batista Neto')
  end

  it 'e testa o json do endpoint com resultado vazio', type: :feature do
    get '/tests/nonono'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq([])
  end
  clean_data_base
end
