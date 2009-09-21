module Praxidata
  class BelPositionen < Base
    set_table_name "TbelPositionen"
    set_primary_key "IDPosition"

    belongs_to :sitzung, :class_name => 'BelSitzungen', :foreign_key => 'inBelSitzungID'

    def self.int_class
      ::ServiceRecord
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :tariff_type => a.txTariftyp,
        :code   => a.txTarifZiffer,
        :ref_code => a.txBezugsZiffer.blank? ? nil : a.txBezugsZiffer,
        :quantity => a.snAnzahl,
        :date => a.sitzung.dtSitzung, # not proviced, as session provides it
        :provider_id => a['inAusführenderArztID'],
        :responsible_id => a.inVerantwortlicherArztID,
        # :location_id not needed, session
        :billing_role => a['shVerantwortlicherArztAbrechRolle'],
        :medical_role => a['shMedRolleAusführenderArzt'],
        :body_location => a.shSeite,
        :unit_factor_mt => 1.0, # Lookup somewhere
        :scale_factor_mt => a.snSkalierungsfaktorInternAL,
        :external_factor_mt => a.snSkalierungsfaktorExternAL,
        :amount_mt => a.snTPAL,
        :unit_factor_tt => 1.0, # Lookup somewhere
        :scale_factor_tt => a.snSkalierungsfaktorInternTL,
        :external_factor_tt => a.snSkalierungsfaktorExternTL,
        :amount_tt => a.snTPAL,
        :vat_rate => a.snMwStSatz,
        # :splitting_factor => ?
        :validate => a.tfValidate,
        :obligation => a.tfPflicht,
        # :section_code => ?
        :remark => a.txPositionstext,
        :unit_mt => 0.9, # should lookup somewhere
        :unit_tt => 0.9 # should lookup
        # :vat_class_id lookup from shMwStTyp
      )

      int_record.imported_id = a.id

      return int_record
    end
  end
end
