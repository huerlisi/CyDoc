module Medindex
  class Base
    @@xml = nil
    
    def self.load
      path = File.join(RAILS_ROOT, 'test', 'fixtures', 'medindex', "DownloadMedindex#{self.name.demodulize}_out.xml")
      @@xml = REXML::Document.new(File.new(path))
    end

    def self.xml
      @@xml || self.load
    end

    def self.all
      xml.root.elements
    end

    def self.int_class
      ("Kernel::" + self.name.demodulize).constantize
    end

    def self.import(do_clean = false)
      puts "Importing #{self.name}..."

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
          int_record = self.import_record(ext_record)

          puts "    " + int_record.to_s
          
          int_record.save!
          success += 1
        rescue Exception => ex
          puts "Error: #{ex.message}"
          
          errors += 1
        end
      end
      
      puts
      puts "  Success: #{success}; skipped: #{skipped}; errors: #{errors}"
      puts "Import done."
    end

    def self.import_all(do_clean = false)
      Medindex::Insurance.import(do_clean)
      Medindex::Substance.import(do_clean)
    end
  end
end

class REXML::Element
  def field(selector)
    elements[selector + '/text()'].to_s
  end
end
