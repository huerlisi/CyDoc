module Praxidata
  module Doctor
    def import(import_record)
      self.attributes = {
        :remarks    => import_record.moBemerkungen,
        :active     => !(import_record.tfInaktiv?),
        :speciality => import_record.arzt.txSpezialgebiet,
        :ean_party  => import_record.txEANNummer,
        :vcard      => Vcards::Vcard.new(
          :honorific_prefix => [import_record.txAnrede, import_record.person.txTitel].compact.join(' '),
          :family_name      => import_record.txName1,
          :given_name       => import_record.txName2,
          :nickname         => import_record.person.txNickName,
          :street_address   => import_record.adresse.txAdresse1,
          :extended_address => import_record.adresse.txAdresse2,
          #:extended_address => import_record.adresse.txAdresse3,
          :postal_code      => import_record.adresse.plz.txPLZ,
          :locality         => import_record.adresse.plz.txOrt
        )
      }

      self.save
      return self
    end
  end
end

Doctor.send :include, Praxidata::Import, Praxidata::Doctor
