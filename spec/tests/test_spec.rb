ENV['RACK_ENV'] = 'test'

require_relative '../../server'
require 'rack/test'
require 'spec_helper'

expected =
  {
    "token_resultado_exame" => "IQCZ17",
    "id" => "1",
    "data_exame" => "2021-08-05",
    "cpf" => "048.973.170-88",
    "nome_paciente" => "Emilly Batista Neto",
    "email_paciente" => "gerald.crona@ebert-quigley.com",
    "data_nascimento_paciente" => "2001-03-11",
    "endereco_paciente" => "165 Rua Rafaela",
    "cidade_paciente" => "Ituverava",
    "estado_paciente" => "Alagoas",
    "doctor" => {
      "nome_medico" => "Maria Luiza Pires",
      "crm_medico" => "B000BJ20J4",
      "crm_medico_estado" => "PI",
      "email_medico" => "denna@wisozk.biz"
    },
    "tests" => [
      {"tipo_exame" => "hemácias", "limites_tipo_exame" => "45-52", "resultado_tipo_exame" => "97"},
      {"tipo_exame" => "leucócitos", "limites_tipo_exame" => "9-61", "resultado_tipo_exame" => "89"},
      {"tipo_exame" => "plaquetas", "limites_tipo_exame" => "11-93", "resultado_tipo_exame" => "97"},
      {"tipo_exame" => "hdl", "limites_tipo_exame" => "19-75", "resultado_tipo_exame" => "0"},
      {"tipo_exame" => "ldl", "limites_tipo_exame" => "45-54", "resultado_tipo_exame" => "80"},
      {"tipo_exame" => "vldl", "limites_tipo_exame" => "48-72", "resultado_tipo_exame" => "82"},
      {"tipo_exame" => "glicemia", "limites_tipo_exame" => "25-83", "resultado_tipo_exame" => "98"},
      {"tipo_exame" => "tgo", "limites_tipo_exame" => "50-84", "resultado_tipo_exame" => "87"},
      {"tipo_exame" => "tgp", "limites_tipo_exame" => "38-63", "resultado_tipo_exame" => "9"},
      {"tipo_exame" => "eletrólitos", "limites_tipo_exame" => "2-68", "resultado_tipo_exame" => "85"},
      {"tipo_exame" => "tsh", "limites_tipo_exame" => "25-80", "resultado_tipo_exame" => "65"},
      {"tipo_exame" => "t4-livre", "limites_tipo_exame" => "34-60", "resultado_tipo_exame" => "94"},
      {"tipo_exame" => "ácido úrico", "limites_tipo_exame" => "15-61", "resultado_tipo_exame" => "2"}
    ]
  }


RSpec.describe 'CVS Import App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'testa o json' do
    get '/tests'
    expect(last_response).to be_ok
    response_json = JSON.parse(last_response.body)
    expect(response_json).to include(expected)
    expect(last_response.body).to include('Emilly Batista Neto')
    expect(last_response.content_type).to eq('application/json')
  end

  it 'Vê os resultados na página', type: :feature do
    get '/home'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('text/html;charset=utf-8')
    expect(last_response.body).to include('Exames')
  end
end
