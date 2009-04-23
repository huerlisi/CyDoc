require "importer"

module Praxistar
  class Base < ActiveRecord::Base
    include Importer
    use_db :prefix => "praxis_"

    def self.import_old(mandant_id = nil, search_options = {})
      search_options.merge!({:conditions => {'Mandant_ID' => mandant_id}}) if mandant_id
      search_options.merge!({:order => "#{primary_key} DESC"})

      records = find(:all, search_options)
      
      for praxistar_record in records
        begin
          attributes = import_attributes(praxistar_record)

          if int_class.exists?(praxistar_record.id)
            int_class.update(praxistar_record.id, attributes)
          else
            hozr_record = int_class.new(attributes)
            hozr_record.id = praxistar_record.id
            hozr_record.save
            logger.info "Imported #{praxistar_record.id}\n"
          end
          
        rescue Exception => ex
          print "ID: #{praxistar_record.id} => #{ex.message}\n\n"
          logger.info "ID: #{praxistar_record.id} => #{ex.message}\n\n"
          logger.info ex.backtrace.join("\n\t")
          logger.info "\n"
        end
      end
    end
  end
end
