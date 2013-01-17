# -*- encoding : utf-8 -*-
module Tarifcodes
  class TariffCode < Base
    def self.sheet_range
      0..3
    end

    def self.footer_rows
      6
    end

    def self.import_record(ext_record)
      raise SkipException if ext_record[0].nil?
      
      int_record = int_class.new(
              :tariff_code => ext_record[0],
              :record_type_v4 => ext_record[1],
              :record_type_v5 => ext_record[2],
              :description => ext_record[3],
              :valid_from => ext_record[4],
              :valid_to => ext_record[5],
              :updated_at => ext_record[6]
      )
    
      return int_record
    end
  end
end
