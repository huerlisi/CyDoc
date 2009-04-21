module Praxistar
  class BankAccount < Base
    set_table_name "Adressen_Banken"
    set_primary_key "ID_Bank"

    def self.int_class
      Accounting::BankAccount
    end

    def self.import_attributes(a)
      {
        :bank_id => a.id,
        :esr_id => a.tx_Bankreferenz_Nr,
        :pc_id => a.tx_Konto
        # TODO: set holder_vcard
     }
    end

    def self.export_attributes(hozr_record, new_record)
      {
        :tx_Bankreferenz_Nr => hozr_record.esr_id,
        :tx_Konto => hozr_record.pc_id
        # TODO: set Bankzeile*, Arztzeile*
      }
    end
  end
end
