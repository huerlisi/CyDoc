module Praxistar
  class AdressenBanken < Base
    set_table_name "Adressen_Banken"
    set_primary_key "ID_Bank"

    def self.int_class
      Accounting::Bank
    end

    def self.import_attributes(a)
      {
        :vcard => Vcards::Vcard.new(
  #        :phone_number => a.tx_Telefon,
          :locality => a.tx_Ort,
  #        :fax_number => a.tx_FAX,
          :extended_address => a.tx_ZuHanden,
          :postal_code => a.tx_PLZ,
          :street_address => a.tx_Strasse,
          :full_name => a.tx_Bank
        )
     }
    end

    def self.export_attributes(hozr_record, new_record)
      {
        :tx_Telefon => hozr_record.phone_number,
        :tx_Ort => hozr_record.locality,
        :tx_FAX => hozr_record.fax_number,
        :tx_ZuHanden => hozr_record.extended_address,
        :tx_PLZ => hozr_record.postal_code,
        :tx_Strasse => hozr_record.street_address,
        :tx_Bank => hozr_record.name
      }
    end
  end
end
