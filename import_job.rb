require 'sidekiq'
require './class/file_importer'

class ImportJob
  include Sidekiq::Job

  def perform(file)
    FileImporter.import(file)
    File.delete(file)
  end
end
