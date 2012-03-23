require 'fastercsv'
require 'insurance'

module Insurances
  module Import
    def import(import_record)
      self.attributes = {
        :role            => 'H',
        :full_name       => import_record[2],
        :vcard           => Vcard.new(
          :street_address  => import_record[3],
          :post_office_box => import_record[4],
          :postal_code     => import_record[6],
          :locality        => import_record[7]
        ),
        :imported_id     => import_record[0]
      }
      
      self.save
      return self
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def import_all
        records = FasterCSV.parse(File.new(File.join(RAILS_ROOT, 'data', 'admin.ch', 'insurances.csv')), {:col_sep => ",", :headers => true})
        Insurance.transaction do
          for record in records
            puts Insurance.new.import(record)
          end
        end
      end
    end
  end
end

Insurance.send :include, Insurances::Import
