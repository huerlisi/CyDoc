# -*- encoding : utf-8 -*-
module Importer
  class SkipException < StandardError
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def clean(klass = int_class)
        puts "  Deleting all #{klass.count} #{klass.name.humanize} records..."
        klass.delete_all
        puts "  Done."
    end

    def import(do_clean = false, options = {})
#      search_options.merge!({:conditions => {'Mandant_ID' => mandant_id}}) if mandant_id
#      search_options.merge!({:order => "#{primary_key} DESC"})

      puts "Importing #{self.name}..."

      # Clear all entries if demanded
      clean if do_clean

      # Prepare counter variables
      success = 0
      skipped = 0
      errors = 0

      # Assure our data is loaded
      ext_records = self.all(options)

      puts "  Importing #{ext_records.count} records..."
      for ext_record in ext_records
        begin
          # Do the actual import as specified by sub-classes
          int_record = self.import_record(ext_record, options)

          # Save new record
          int_record.save!
          int_record.reload

          puts "    " + int_record.to_s
          success += 1

        # If something goes wrong...
        rescue Importer::SkipException => ex
          puts "  Skip #{ext_record[5]}"
          skipped += 1

        # If something goes wrong...
        rescue Exception => ex
          puts "Error (#{ext_record.inspect}): #{ex.message}"
          puts ex.backtrace.join("\n\t")
          errors += 1
        end
      end

      puts
      puts "  Success: #{success}; skipped: #{skipped}; errors: #{errors}"
      puts "Import done."
    end

    def int_class
      ("Kernel::" + self.name.demodulize).constantize
    end
  end
end

class Importer::Data

  @@data = nil

  # Abstract methods
  def self.import_all(do_clean = false)
  end

  def self.load
  end


  def self.data
    @@data || self.load
  end

  def self.all
    data
  end
end
