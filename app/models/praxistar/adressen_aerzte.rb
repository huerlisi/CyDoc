class Praxistar::AdressenAerzte < Praxistar::Base
  set_table_name "Adressen_Ärzte"
  set_primary_key "ID_Arztadresse"

  def self.import(id)
    a = find(id)

    d = Doctor.new(
      :praxis => Vcard.new(
        :locality => a.tx_Prax_Ort,
        :fax_number => a.tx_Prax_Fax,
        :phone_number => a.tx_Prax_Telefon1,
        :postal_code => a.tx_Prax_PLZ,
        :street_address => a.tx_Prax_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname
      ),
      :private => Vcard.new(
        :locality => a.tx_Priv_Ort,
        :fax_number => a.tx_Priv_Fax,
        :phone_number => a.tx_Priv_Telefon1,
        :postal_code => a.tx_Priv_PLZ,
        :street_address => a.tx_Priv_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname
      ),
      :code => a.tx_ErfassungsNr,
      :speciality => a.tx_Fachgebiet
    )
    d.id = a.ID_Arztadresse
    d.save
  end
  
  def self.import_all
    Doctor.delete_all

    for a in find_all
      import(a.id)
    end
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

  def self.hozr_model
    Doctor
  end
end
