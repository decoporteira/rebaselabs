require 'sidekiq'
require './class/file_importer'

class ImportJob
  include Sidekiq::Job

  def perform
    if params['file'] && (params['file']['type'] == 'text/csv')
      file = params[:file][:tempfile]
      FileImporter.import(file)
    else
      { status: 'error', message: 'Erro: Arquivo inválido.' }.to_json
    end
  end
end