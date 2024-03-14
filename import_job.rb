require 'sidekiq'
require './class/file_importer'

class ImportJob
  include Sidekiq::Job
  include Sidekiq::Worker

  def perform(file)
    FileImporter.import(file)
  end
end
