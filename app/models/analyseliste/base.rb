# -*- encoding : utf-8 -*-
require 'fastercsv'

module Analyseliste
  class Base
    include Importer

    def self.import_all(do_clean = false, options = {})
      LabTariffItem.import(do_clean, options)
      LabTariffItem.import(false, options.merge({:version => 'old'}))
    end

    protected
    def self.path(options = {})
      return options[:input] if options[:input]

      options[:version] ||= 'new'
      name = (options[:version] == 'new') ? 'analyseliste.csv' : 'analyseliste_old.csv'

      case env['Rails.env']
        when 'production', 'demo'
          File.join(Rails.root, 'data', name)
        when 'development', 'test'
          File.join(Rails.root, 'test', 'fixtures', 'analyseliste', name)
      end
    end

    def self.find(selector, options = {})
      # Sheets are seperated using form feed (\f) by xls2csv
      sheets = File.read(path(options)).split("\f")

      # First sheet is german
      FasterCSV.parse(sheets[0], :headers => true)
    end
  end
end
