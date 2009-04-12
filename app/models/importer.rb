class Importer
  @@data = nil
  
  # Abstract methods
  def self.import_all(do_clean = false)
  end

  def self.load
  end

  # Generic methods
  def self.int_class
    ("Kernel::" + self.name.demodulize).constantize
  end

  def self.data
    @@data || self.load
  end

  def self.all
    data
  end

  def self.import(do_clean = false)
    puts "Importing #{self.name}..."

    # Clear all entries if demanded
    if do_clean
      puts "  Deleting all #{int_class.count} records..."
      int_class.delete_all
      puts "  Done."
    end

    # Prepare counter variables
    success = 0
    skipped = 0
    errors = 0

    # Assure our data is loaded
    self.load
    ext_records = self.all
    
    puts "  Importing #{ext_records.count} records..."
    for ext_record in ext_records
      begin
        # Do the actual import as specified by sub-classes
        int_record = self.import_record(ext_record)

        puts "    " + int_record.to_s
        
        # Save new record
        int_record.save!
        success += 1

      # If something goes wrong...
      rescue Exception => ex
        puts "Error: #{ex.message}"
        
        errors += 1
      end
    end
    
    puts
    puts "  Success: #{success}; skipped: #{skipped}; errors: #{errors}"
    puts "Import done."
  end
end
