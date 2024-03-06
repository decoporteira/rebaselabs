require_relative '../../server'
require 'rack/test'

RSpec.describe 'CVS Import App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'testa o json' do
    get '/tests'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Emilly Batista Neto')
    expect(last_response.content_type).to eq('application/json')
  end

  it 'Vê os resultados na página' do
    get '/home'
    expect(last_response.body).to include('Emilly Batista Neto')
  end
end
