require 'fastercsv'

module Analyseliste
  class Base < Importer
    def self.path
      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', 'analyseliste.csv')
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'analyseliste', 'analyseliste.csv')
      end
    end

    def self.load
      @@data = FasterCSV.read(path, :headers => true)
    end

    def self.import_all(do_clean = false)
      LabTariffItem.import(do_clean)
    end
  end
end
