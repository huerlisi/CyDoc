# -*- encoding : utf-8 -*-
module DiagnosisCodes
  class ByContractCode < Base
    def self.int_class
      DiagnosisByContract
    end

    def self.import_record(ext_record, options)
      raise SkipException if ext_record[0].nil?

      int_record = int_class.new(
        :code => ext_record[0],
        :text => ext_record[1]
      )

      return int_record
    end
  end
end
