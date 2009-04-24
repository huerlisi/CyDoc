require "importer"

module Praxistar
  class Base < ActiveRecord::Base
    include Importer
    use_db :prefix => "praxis_"

    def self.import_all(do_clean, options = {})
      # Adresses
      AdressenMandanten.import(do_clean, options)
      AdressenVersicherungen.import(do_clean, options)
      AdressenBanken.import(do_clean, options)
      AdressenAerzte.import(false, options) # no clean because it would be cleaned by AdressenMandant
      AdressenPersonal.import(do_clean, options)
      
      # Patients
      PatientenPersonalien.import(do_clean, options)
    end
  end
end
