require 'sidekiq'
require './class/file_importer'

class ImportJob
  include Sidekiq::Job
  include Sidekiq::Worker

  def perform(file)
    FileImporter.import(file)

    after_perform do |job|
      FileUtils.rm_rf(Dir.glob('data/temp/*'))
    end
  end
end
