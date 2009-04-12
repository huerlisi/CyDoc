module Medindex
  class Insurance < Base
    def self.import(do_clean = true)
      puts "Importing #{self.name}..."

      int_class = ("Kernel::" + self.name.demodulize).constantize

      if do_clean
        puts "  Deleting all #{int_class.count} records..."
        int_class.delete_all
        puts "  Done."
      end

      success = 0
      skipped = 0
      errors = 0

      ext_records = self.all
      
      puts "  Importing #{ext_records.count} records..."
      for ext_record in self.all
        begin
          int_record = int_class.new
          
          int_record.ean_party = ext_record.field('EAN')
          int_record.vcard = Vcards::Vcard.new(
                  :full_name => ext_record.field('DESCR1'),
                  :street_address => [ext_record.field('ADDR/STREET'), ext_record.field('ADDR/STRNO')].compact.join(" "),
                  :extended_address => ext_record.field('ADDR/POBOX'),
                  :postal_code => ext_record.field('ADDR/ZIP'),
                  :locality => ext_record.field('ADDR/CITY')
          )

          puts "    " + int_record.to_s
          
          int_record.save!
          success += 1
        rescue
          errors += 1
        end
      end
      
      puts
      puts "  Success: #{success}; skipped: #{skipped}; errors: #{errors}"
      puts "Import done."
    end
  end
end
