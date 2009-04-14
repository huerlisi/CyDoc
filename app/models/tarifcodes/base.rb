require 'fastercsv'

module Tarifcodes
  class Base < Importer
    def self.path
      case ENV['RAILS_ENV']
        when 'production': File.join(RAILS_ROOT, 'data', 'tarifcodes.csv')
        when 'development', 'test': File.join(RAILS_ROOT, 'test', 'fixtures', 'tarifcodes', 'tarifcodes.csv')
      end
    end

    def self.header_rows
      2
    end
    
    def self.footer_rows
      0
    end
    
    def self.load
      # Sheets are seperated using form feed (\f) by xls2csv
      sheets = File.read(path).split("\f")
      
      # Subclasses shall define @@sheet_number
      sheet = sheets[sheet_number]
      
      # Strip headers
      data = FasterCSV.parse(sheet)
      @@data = data[header_rows..-(1+footer_rows)]
    end

    def self.import_all(do_clean = false)
      TariffCode.import(do_clean)
    end
  end
end
