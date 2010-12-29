require 'fastercsv'
require 'postal_code'

module PostalCodes
  module Import
    def import(import_record)
      self.attributes = {
        :zip_type      => import_record[1],
        :zip           => import_record[2],
        :zip_extension => import_record[3],
        :locality      => import_record[4],
        :locality_long => import_record[5],
        :canton        => import_record[6],
        :imported_id   => import_record[0]
      }
      
      self.save
      return self
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def import_all
        records = FasterCSV.parse(File.new(File.join(RAILS_ROOT, 'data', 'postal_code.csv')), {:col_sep => "\t", :headers => false})
        for record in records
          import(record)
        end
      end
    end
  end
end

PostalCode.send :include, PostalCodes::Import
