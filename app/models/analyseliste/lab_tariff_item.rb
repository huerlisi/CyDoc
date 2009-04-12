module Analyseliste
  class LabTariffItem < Base
    def self.import_record(ext_record)
      raise SkipException if ext_record[2].nil?
      
      int_record = int_class.new(
              :code => ext_record[2],
              :amount_tt => ext_record[4],
              :remark => ext_record[5]
      )
    
      return int_record
    end
  end
end
