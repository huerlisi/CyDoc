class Praxidata::PatientenPersonalien < Praxidata::Base
  set_table_name "Patienten_Personalien"
  set_primary_key "ID_Patient"
  
  def self.hozr_model
    Patient
  end
  
  def self.import_attributes(a)
    {
      :vcard => Vcards::Vcard.new(
        :locality => a.tx_Ort,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname,
        :honorific_prefix => [a.tx_Anrede, a.tx_Titel].join(' ')
      ),
      :billing_vcard => Vcards::Vcard.new(
        :locality => a.tx_fakt_Ort,
        :postal_code => a.tx_fakt_PLZ,
        :street_address => a.tx_fakt_Strasse,
        :family_name => a.tx_fakt_Name,
        :given_name => a.tx_fakt_Vorname,
        :extended_address => a.tx_fakt_ZuHanden,
        :honorific_prefix => [a.tx_fakt_Anrede, a.tx_fakt_Titel].join('')
      ),
      :insurance_id => a.KK_Garant_ID,
      :insurance_nr => a.tx_KK_MitgliedNr,
      :doctor_id => a.ZuwArzt_ID,
      :birth_date => a.tx_Geburtsdatum,
      :created_at => a.tx_Aufnahmedatum,
      :remarks => a.mo_Bemerkung,
      :sex => a.Geschlecht_ID,
      :dunning_stop => a.tf_Mahnen,
      :use_billing_address => a.tf_fakt_Aktiv,
      :deceased => a.tf_Exitus,
    }
  end
  
  def self.import(mandant_id, selection = :all)
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
end
