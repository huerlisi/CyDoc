require 'service_record'

module Praxidata
  module ServiceRecord
    def import(import_record)
      self.attributes = {
        :tariff_type => import_record.txTariftyp,
        :code   => import_record.txTarifZiffer,
        :ref_code => import_record.txBezugsZiffer.blank? ? nil : import_record.txBezugsZiffer,
        :quantity => import_record.snAnzahl.round(2),
        :date => import_record.sitzung.dtSitzung, # not proviced, as session provides it
        :provider_id => import_record['inAusführenderArztID'],
        :responsible_id => import_record.inVerantwortlicherArztID,
        # :location_id not needed, session
        :billing_role => import_record['shVerantwortlicherArztAbrechRolle'],
        :medical_role => import_record['shMedRolleAusführenderArzt'],
        :body_location => import_record.shSeite,
        :unit_factor_mt => 1.0, # Lookup somewhere
        :scale_factor_mt => 1.0, # import_record.snSkalierungsfaktorInternAL.round(2),
        :external_factor_mt => 1.0, # import_record.snSkalierungsfaktorExternAL.round(2),
        :amount_mt => import_record.snTPAL.nil? ? 0.0 : import_record.snTPAL.round(2),
        :unit_factor_tt => 1.0, # Lookup somewhere
        :scale_factor_tt => 1.0, #import_record.snSkalierungsfaktorInternTL.round(2),
        :external_factor_tt => 1.0, #import_record.snSkalierungsfaktorExternTL.round(2),
        :amount_tt => import_record.snTPTL.nil? ? 0.0 : import_record.snTPTL.round(2),
        :vat_rate => import_record.snMwStSatz,
        # :splitting_factor => ?
        :validate => import_record.tfValidate,
        :obligation => import_record.tfPflicht,
        # :section_code => ?
        :remark => import_record.txPositionstext || '',
        :unit_mt => import_record.snTPWAL.nil? ? 1.0 : import_record.snTPWAL.round(2), # using 1.0 should fix medis
        :unit_tt => import_record.snTPWTL.nil? ? 1.0 : import_record.snTPWTL.round(2) # using 1.0 should fix medis
        # :vat_class_id lookup from shMwStTyp
      }
      self.save

      return self
    end
  end
end

ServiceRecord.send :include, Praxidata::Import, Praxidata::ServiceRecord
