ENV['RACK_ENV'] = 'test'

require_relative '../../server'
require 'rack/test'
require 'spec_helper'

RSpec.describe 'CVS importa dados por API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'com sucesso' do
    data = 'spec/assets/test_data.csv'

    post '/import', file: Rack::Test::UploadedFile.new(data, 'text/csv')
    
    expect(last_response).to be_ok
    expect(last_response.body).to eq('{"status":"success","message":"Importação realizada com sucesso"}')
    conn = PG.connect(host: 'localhost', dbname: 'postgres', user: 'postgres', password: '123456', port: 5432)


  result = conn.exec('SELECT COUNT(*) FROM patients')
  expect(result[0]['count'].to_i).to eq(1) # Verifica se foi inserido 1 paciente

  result = conn.exec('SELECT COUNT(*) FROM doctors')
  expect(result[0]['count'].to_i).to eq(1) # Verifica se foi inserido 1 médico

  result = conn.exec('SELECT COUNT(*) FROM exams')
  expect(result[0]['count'].to_i).to eq(1) # Verifica se foi inserido 1 exame
   
  end

end