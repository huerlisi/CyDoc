module Praxidata
  module Doctor
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def import(import_record)
      self.attributes = {
        :remarks    => import_record.moBemerkungen,
        :speciality => import_record.arzt.txSpezialgebiet,
        :ean_party  => import_record.txEANNummer,
        :vcard      => Vcards::Vcard.new(
          :honorific_prefix => import_record.txAnrede,
          :family_name      => import_record.txName1,
          :given_name       => import_record.txName2,
          :street_address   => import_record.adresse.txAdresse1,
          :extended_address => import_record.adresse.txAdresse2,
          #:extended_address => import_record.adresse.txAdresse3,
          :postal_code      => import_record.adresse.plz.txPLZ,
          :locality         => import_record.adresse.plz.txOrt
        )
      }
    end
    
    module ClassMethods
      def import(import_record)
         # Try finding a previously imported record unless there's no primary key
         record = self.find_by_imported_id(import_record.id) unless import_record.id.nil?
         # Create a new one, otherwise
         record ||= self.new

         record.import(import_record)
         
         record.imported_id = import_record.id
         
         return record
      end
    end
  end
end

Doctor.send :include, Praxidata::Doctor
