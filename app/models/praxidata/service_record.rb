module Praxidata
  module ServiceRecord
    def import(import_record)
      self.attributes = {
        :tariff_type => import_record.txTariftyp,
        :code   => import_record.txTarifZiffer,
        :ref_code => import_record.txBezugsZiffer.blank? ? nil : import_record.txBezugsZiffer,
        :quantity => import_record.snAnzahl,
        :date => import_record.sitzung.dtSitzung, # not proviced, as session provides it
        :provider_id => import_record['inAusführenderArztID'],
        :responsible_id => import_record.inVerantwortlicherArztID,
        # :location_id not needed, session
        :billing_role => import_record['shVerantwortlicherArztAbrechRolle'],
        :medical_role => import_record['shMedRolleAusführenderArzt'],
        :body_location => import_record.shSeite,
        :unit_factor_mt => 1.0, # Lookup somewhere
        :scale_factor_mt => import_record.snSkalierungsfaktorInternAL,
        :external_factor_mt => import_record.snSkalierungsfaktorExternAL,
        :amount_mt => import_record.snTPAL,
        :unit_factor_tt => 1.0, # Lookup somewhere
        :scale_factor_tt => import_record.snSkalierungsfaktorInternTL,
        :external_factor_tt => import_record.snSkalierungsfaktorExternTL,
        :amount_tt => import_record.snTPAL,
        :vat_rate => import_record.snMwStSatz,
        # :splitting_factor => ?
        :validate => import_record.tfValidate,
        :obligation => import_record.tfPflicht,
        # :section_code => ?
        :remark => import_record.txPositionstext || '',
        :unit_mt => 0.9, # should lookup somewhere
        :unit_tt => 0.9 # should lookup
        # :vat_class_id lookup from shMwStTyp
      }
      self.save

      return self
    end
  end
end

ServiceRecord.send :include, Praxidata::Import, Praxidata::ServiceRecord
