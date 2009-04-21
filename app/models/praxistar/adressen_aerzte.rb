class Praxistar::AdressenAerzte < Praxistar::Base
  set_table_name "Adressen_Ärzte"
  set_primary_key "ID_Arztadresse"

  def self.int_class
    Doctor
  end

  def self.import_attributes(a)
    {
      :praxis => Vcards::Vcard.new(
        :locality => a.tx_Prax_Ort,
#        :fax_number => a.tx_Prax_Fax,
#        :phone_number => a.tx_Prax_Telefon1,
        :postal_code => a.tx_Prax_PLZ,
        :street_address => a.tx_Prax_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname
      ),
      :private => Vcards::Vcard.new(
        :locality => a.tx_Priv_Ort,
#        :fax_number => a.tx_Priv_Fax,
#        :phone_number => a.tx_Priv_Telefon1,
        :postal_code => a.tx_Priv_PLZ,
        :street_address => a.tx_Priv_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname
      ),
      :code => a.tx_ErfassungsNr,
      :speciality => a.tx_Fachgebiet
    }
  end
end
