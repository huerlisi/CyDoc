# -*- encoding : utf-8 -*-
module Analyseliste
  class LabTariffItem < Base
    def self.import_record(ext_record, options)
      raise SkipException if ext_record[2].nil?

      case options[:version]
        when 'new'
          tariff_type = 317
          code = ext_record[2]
        when 'old'
          tariff_type = 316
          code = ext_record[3]
      end

      int_record = int_class.new(
              :code => code,
              :tariff_type => tariff_type,
              :amount_tt => ext_record[4],
              :remark => ext_record[5]
      )

      return int_record
    end
  end
end
