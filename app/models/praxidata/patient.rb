module Praxidata
  module Patient
    def import(import_record)
      self.attributes = {
        :birth_date        => import_record.person.dtGeburtstag,
        :sex               => import_record.person.shSexID,
        # :doctor_id  => lookup,
        :remarks           => import_record.moBemerkungen,
        :dunning_stop      => import_record.patient.tfMahnSperre,
        # :use_billing_address => no billing address support for now,
        :deceased          => !(import_record.person.dtExitus.nil?), # Should be a date, not a boolean
        :doctor_patient_nr => import_record.patient_nummer.inNummer.to_s,
        :active            => !(import_record.tfInaktiv?),
        :vcard             => Vcards::Vcard.new(
          :honorific_prefix => [import_record.txAnrede, import_record.person.txTitel].compact.join(' '),
          :family_name      => import_record.txName1,
          :given_name       => import_record.txName2,
          :nickname         => import_record.person.txNickName,
          :street_address   => import_record.adresse.txAdresse1,
          :extended_address => import_record.adresse.txAdresse2,
          #:extended_address => import_record.adresse.txAdresse3,
          :postal_code      => import_record.adresse.plz.nil? ? nil : import_record.adresse.plz.txPLZ,
          :locality         => import_record.adresse.plz.nil? ? nil : import_record.adresse.plz.txOrt
        )
      }
    end
  end
end

Patient.send :include, Praxidata::Import, Praxidata::Patient
