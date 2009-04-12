module Analyseliste
  class LabTariffItem < Base
    def self.import(clean = false)
      puts "Importing Analyseliste..."
      
      int_class = ("Kernel::" + self.name.demodulize).constantize
      
      int_class.delete_all if clean

      success = 0
      errors = 0
      for ext_record in self.all
        begin
          int_record = int_class.new(
                  :code => ext_record[2],
                  :amount_tt => ext_record[4],
                  :remark => ext_record[5]
          )
        
          puts "  " + int_record.to_s

          int_record.save!
          success += 1
        rescue
          errors += 1
        end
      end
      
      puts
      puts "  Success: #{success}, errors: #{errors}"
      puts "Import done."
    end
  end
end
