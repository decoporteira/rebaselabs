ENV['RACK_ENV'] = 'test'

require_relative '../../server'
require 'rack/test'
require 'spec_helper'
require 'pg'

def clean_data_base
  conn = PG.connect(host: 'localhost', dbname: 'test', user: 'postgres', password: 'postgres', port: 5432)
  conn.exec('DELETE FROM exam_types')
  conn.exec('DELETE FROM exams cascade')
  conn.exec('DELETE FROM patients cascade')
  conn.exec('DELETE FROM doctors cascade')
end

RSpec.describe 'CVS importa dados por API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'com sucesso' do
    data = 'spec/assets/data.csv'

    post '/import', file: Rack::Test::UploadedFile.new(data, 'text/csv')

    expect(last_response).to be_ok
    conn = PG.connect(host: 'localhost', dbname: 'test', user: 'postgres', password: 'postgres', port: 5432)
    result = conn.exec('SELECT COUNT(*) FROM patients')
    expect(result[0]['count'].to_i).to eq(50)
    clean_data_base
    conn.close
  end
end

