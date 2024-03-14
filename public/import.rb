require 'pg'
require 'csv'
require_relative 'file_importer'

file = './data/data.csv'
FileImporter.import(file)
