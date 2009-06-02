module Praxistar
  class AdressenMandanten < Base
    set_table_name "Adressen_Mandanten"
    set_primary_key "ID_Mandant"

    def self.int_class
      Doctor
    end

    def self.lookup_region(a)
      # TODO: use help table KANTON
      "ZH"
    end
    
    def self.import_record(a, options)
      raise SkipException unless a.tf_Aktiv?
      
      int_record = int_class.new(
        :speciality => a.tx_Fachgebiet,
        :remarks => a.tx_Bemerkung,
        :zsr => a.tx_ZSRNr,
        :ean_party => a.tx_EANNr
      )
      
      int_record.vcards.build(
        :locality => a.tx_Ort,
        :postal_code => a.tx_PLZ,
        :street_address => a.tx_Strasse,
        :region => lookup_region(a),
        :family_name => a.tx_Name,
        :given_name => a.tx_Vorname,
        :phone_number => a.Telefon_1,
        # TODO: tx_Telefon_2
        :mobile_number => a.Telefon_N,
        :fax_number => a.Telefax
        # TODO: eMail
      )
      
      int_record.offices.build(
        :name => a.tx_Mandant
      )
      
      return int_record
    end
  end
end
