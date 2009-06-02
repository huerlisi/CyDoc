module Praxistar
  class AdressenVersicherungen < Base
    set_table_name "Adressen_Versicherungen"
    set_primary_key "ID_Versicherung"

    def self.int_class
      Insurance
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :ean_party => a.tx_EANNr
      )

      int_record.vcards.build(
        :phone_number => a.tx_Telefon,
        :locality => a.tx_Ort,
        :fax_number => a.tx_FAX,
        :extended_address => a.tx_ZuHanden,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :full_name => a.tx_Name
      )
     
      return int_record
    end
  end
end
