module Praxistar
  class AdressenBanken < Base
    set_table_name "Adressen_Banken"
    set_primary_key "ID_Bank"

    def self.int_class
      Accounting::Bank
    end

    def self.import_record(a)
      int_record = int_class.new(
        :phone_number => a.tx_Telefon,
        :locality => a.tx_Ort,
        :fax_number => a.tx_Fax,
        :extended_address => a.tx_ZuHanden,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :full_name => a.tx_Bank
      )

      int_record.bank_accounts.build(
        :esr_id => a.tx_Bankreferenz_Nr,
        :pc_id  => a.tx_Konto
        # TODO: Bankzeile*, Arztzeile*
        # TODO: holder
      )

      return int_record
    end
  end
end
