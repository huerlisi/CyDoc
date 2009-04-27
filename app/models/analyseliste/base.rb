require 'fastercsv'

module Analyseliste
  class Base
    include Importer

    def self.path
      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', 'analyseliste.csv')
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'analyseliste', 'analyseliste.csv')
      end
    end

    def self.find(selector, options = {})
      FasterCSV.read(path, :headers => true)
    end

    def self.import_all(do_clean = false, options = {})
      LabTariffItem.import(do_clean)
    end
  end
end
