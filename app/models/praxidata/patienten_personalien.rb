class Praxidata::PatientenPersonalien < Praxidata::Base
  set_table_name "cyPatient"
  set_primary_key "IDStamm"
  
  def self.hozr_model
    Patient
  end
  
  def self.import_attributes(a)
    {
      :vcard => Vcards::Vcard.new(
        :locality => a.txOrt,
        :postal_code => a.txPLZ,
        :street_address => a.txAdresse1,
        :family_name => a.txName1,
        :given_name => a.txName2,
#        :honorific_prefix => [a.txAnrede, a.txTitel].join(' ')
        :honorific_prefix => a.txAnrede
        
      ),
# I have not yet found out how Triamun handles billing addresses
#      :billing_vcard => Vcards::Vcard.new(
#        :locality => a.tx_fakt_Ort,
#        :postal_code => a.tx_fakt_PLZ,
#        :street_address => a.tx_fakt_Strasse,
#        :family_name => a.tx_fakt_Name,
#        :given_name => a.tx_fakt_Vorname,
#        :extended_address => a.tx_fakt_ZuHanden,
#        :honorific_prefix => [a.tx_fakt_Anrede, a.tx_fakt_Titel].join('')
#      ),


      :insurance_id => a.inVersicherungID,        # inVersicherungID links to IDStamm of insurance
      :insurance_nr => a.txVersichertenNummer, # we will have to check if the join clause is correct
#      :doctor_id => a.ZuwArzt_ID,
      :birth_date => a.dtGeburtstag,
      :created_at => a.dtAufnahmedatum,
      :remarks => a.moBemerkungen,
      :sex => a.shSexID,
      :dunning_stop => a.tfMahnSperre,
#      :use_billing_address => a.tf_fakt_Aktiv,  # have not yet found the billing-address information
      :deceased => a.dtExitus, #Attention in Triamun it is a date not boolean
    }
  end
  
  def self.import(selection = :all)
    records = find(selection, :order => "#{primary_key} DESC")
    
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
