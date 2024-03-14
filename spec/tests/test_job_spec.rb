ENV['RACK_ENV'] = 'test'

require 'spec_helper'

RSpec.describe 'CVS Import App' do
  it 'e testa o json do endpoint com todos os exames' do
    data = 'spec/assets/data_test.csv'
    spy = spy('ImportJob')
    stub_const('ImportJob', spy)

    allow(ImportJob).to receive(:perform_async).and_return(data)
    post '/import', file: Rack::Test::UploadedFile.new(data, 'text/csv')

    expect(spy).to have_received(:perform_async).once
  end
end
