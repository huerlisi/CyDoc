module Praxistar
  class AdressenAerzte < Base
    set_table_name "Adressen_Ärzte"
    set_primary_key "ID_Arztadresse"

    def self.int_class
      Doctor
    end

    def self.import_record(a)
      int_record = int_class.new(
        :code => a.tx_ErfassungsNr,
        :speciality => a.tx_Fachgebiet,
        :remarks => a.tx_Bemerkung,
        :zsr => a.tx_ZSRNr,
        :ean_party => a.tx_EANNr
      )
      
      int_record.vcards.build(
        :locality => a.tx_Prax_Ort,
        :postal_code => a.tx_Prax_PLZ,
        :street_address => a.tx_Prax_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname,
        :phone_number => a.tx_Prax_Telefon1,
        :fax_number => a.tx_Prax_Fax
      )
      
      int_record.vcards.build(
        :locality => a.tx_Priv_Ort,
        :postal_code => a.tx_Priv_PLZ,
        :street_address => a.tx_Priv_Strasse,
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname,
        :phone_number => a.tx_Priv_Telefon1,
        :fax_number => a.tx_Priv_Fax
      )
      
      return int_record
    end
  end
end
