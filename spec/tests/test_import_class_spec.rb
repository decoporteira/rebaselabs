require 'spec_helper'
require_relative '../../class/file_importer'

def clean_data_base
  conn.exec('DELETE FROM exam_types')
  conn.exec('DELETE FROM exams cascade')
  conn.exec('DELETE FROM patients cascade')
  conn.exec('DELETE FROM doctors cascade')
end

RSpec.describe 'Testa classe FileImporter' do
 

  it 'com sucesso' do
    conn = PG.connect(host: 'localhost', dbname: 'test', user: 'postgres', password: 'postgres', port: 5432)
    
    data = 'spec/assets/data_test.csv'

    FileImporter.import(data)

    result = conn.exec('SELECT COUNT(*) FROM patients')
    expect(result[0]['count'].to_i).to eq(1)
    conn.exec('DELETE FROM exam_types')
    conn.exec('DELETE FROM exams cascade')
    conn.exec('DELETE FROM patients cascade')
    conn.exec('DELETE FROM doctors cascade')
    conn.close
  end
end


