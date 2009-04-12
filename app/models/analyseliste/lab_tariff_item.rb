module Analyseliste
  class LabTariffItem < Base
    def self.import
      int_class = ("Kernel::" + self.name.demodulize).constantize
      
      for ext_record in self.all
        int_record = int_class.new(
		:code => ext_record[2],
		:amount_tt => ext_record[4],
		:remark => ext_record[5]
        )
        
        puts int_record.to_s
        
        int_record.save!
      end
    end
  end
end
