module Medindex
  class Substance < Base
    def self.import
      for ext_record in self.all
        int_record = Kernel::DrugSubstance.new
        
        int_record.id = ext_record.field('SUBNO')
        int_record.name = ext_record.field('NAMD')

        puts int_record.to_s
        
        int_record.save!
      end
    end
  end
end

