class Praxistar::AdressenPersonal < Praxistar::Base
  set_table_name "Adressen_Personal"
  set_primary_key "ID_Personal"

  def self.int_class
    Employee
  end

  def self.import_attributes(a)
    vcard = Vcards::Vcard.new(
        :locality => a.tx_Ort,
#        :fax_number => a.tx_Prax_Fax,
#        :phone_number => a.tx_Prax_Telefon1,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname
    )
    vcard.save!
    
    user = User.new(
        :login => a.tx_User,
        :password => a.tx_Kennwort,
        :password_confirmation => a.tx_Kennwort,
        :name => [a.tx_Vorname, a.tx_Name].compact.join(' '),
        :state => 'active',
        # TODO: don't hardcode domain
        :email => a.tx_User + '@zytolabor.ch'
      )
    user.save!
    
    {
      :vcard => vcard,
      :user => user,
      :active => a.tf_Aktiv?,
      :born_on => a.dt_Geburtsdatum
    }
  end
  
  def self.export_attributes(hozr_record, new_record)
    {
        :tx_Prax_Ort => hozr_record.praxis.locality,
        :tx_Prax_Fax => hozr_record.praxis.fax_number,
        :tx_Prax_Telefon1 => hozr_record.praxis.phone_number,
        :tx_Prax_PLZ => hozr_record.praxis.postal_code,
        :tx_Prax_Strasse => hozr_record.praxis.street_address,
        :tx_Priv_Ort => hozr_record.private.locality,
        :tx_Priv_Fax => hozr_record.private.fax_number,
        :tx_Priv_Telefon1 => hozr_record.private.phone_number,
        :tx_Priv_PLZ => hozr_record.private.postal_code,
        :tx_Priv_Strasse => hozr_record.private.street_address,
        :tx_Name => hozr_record.praxis.family_name,
        :tx_Vorname => hozr_record.praxis.given_name,
        :tx_ErfassungsNr => hozr_record.code,
        :tx_Fachgebiet => hozr_record.speciality,
        # const attributes
        :Mandant_ID => 1
      }
  end
end
