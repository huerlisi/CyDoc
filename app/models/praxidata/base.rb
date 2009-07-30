require "importer"

include Praxidata

class Praxidata::Base < ActiveRecord::Base
  include Importer
  use_db :prefix => "praxidata_"

  def self.old_import(mandant_id, selection = :all)
    records = find(selection, :order => "#{primary_key} DESC", :conditions =>  ['Mandant_ID = ?', mandant_id])
    
    for praxistar_record in records
      begin
        attributes = import_attributes(praxistar_record)

        if hozr_model.exists?(praxistar_record.id)
          hozr_model.update(praxistar_record.id, attributes)
        else
          hozr_record = hozr_model.new(attributes)
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

  def self.import_all(do_clean, options = {})
    # Adresses
    AdressenMandanten.import(do_clean, options)
    AdressenVersicherungen.import(do_clean, options)
    AdressenBanken.import(do_clean, options)
    AdressenAerzte.import(false, options) # no clean because it would be cleaned by AdressenMandant
    AdressenPersonal.import(do_clean, options)
    
    # Patients
    PatientenPersonalien.import(do_clean, options)
    
    # Tariffs
    TarifeBloecke.import(do_clean, options)
  end
end
