require "importer"

module Praxistar
  class Base < ActiveRecord::Base
    include Importer
    use_db :prefix => "praxis_"

    def self.import_all(do_clean, options = {})
      # Adresses
      AdressenVersicherungen.import(do_clean, options)
      AdressenBanken.import(do_clean, options)
      AdressenAerzte.import(do_clean, options)
      AdressenPersonal.import(do_clean, options)
      
      # Patients
      PatientenPersonalien.import(do_clean, options)
    end
  end
end
