module Praxistar
  class Importer
    def self.import(mandant_id)
      # Addresses
      AdressenAerzte.import(mandant_id)
      AdressenVersicherungen.import(mandant_id)
      AdressenBanken.import(mandant_id)

      # Patienten
      PatientenPersonalien.import(mandant_id)
      
      # Accounting
      BankAccount.import(mandant_id)
    end
  end
end
