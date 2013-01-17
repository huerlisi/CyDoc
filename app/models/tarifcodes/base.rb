# -*- encoding : utf-8 -*-
require 'fastercsv'

module Tarifcodes
  class Base
    include Importer

    def self.path
      case env['Rails.env']
        when 'production'
          File.join(Rails.root, 'data', 'tarifcodes.csv')
        when 'development', 'test'
          File.join(Rails.root, 'test', 'fixtures', 'tarifcodes', 'tarifcodes.csv')
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

      # Subclasses shall define sheet_number
      selected_sheets = sheets[sheet_range]

      # Dirty hack... Should probably some heuristics
      rows = [2..-5, 2..-1, 2..-1, 2..-1, 2..-1]

      @@data = []
      selected_sheets.each_with_index{|sheet, i|
        # Strip headers
        data = FasterCSV.parse(sheet)

        puts "  Importing #{data[0][0]}"
        @@data += data[rows[i]]
      }
    end

    def self.import_all(do_clean = false)
      TariffCode.import(do_clean)
    end
  end
end
