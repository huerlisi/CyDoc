module Analyseliste
  class LabTariffItem < Base
    def self.import
      for ext_record in self.all
        int_record = Kernel::LabTariffItem.new(
		:code => ext_record[2],
		:amount_tt => ext_record[4],
		:remark => ext_record[5]
        )
        
        puts int_record.remark
        
        int_record.save!
      end
    end
  end
end
