module Medindex
  class Substance < Base
    def self.int_class
      Kernel::DrugSubstance
    end

    def self.import_record(ext_record)
      int_record = Kernel::DrugSubstance.new
      
      int_record.id = ext_record.field('SUBNO')
      int_record.name = ext_record.field('NAMD')

      return int_record
    end
  end
end

