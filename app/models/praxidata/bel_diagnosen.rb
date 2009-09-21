module Praxidata
  class BelDiagnosen < Base
    set_table_name "TbelDiagnosen"
    set_primary_key "IDDiagnose"

    belongs_to :fall, :class_name => 'BelFaelle', :foreign_key => 'inFallID'

    def self.int_class
      ::MedicalCase
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :duration_from => a.dtSitzung,
        :duration_to   => a.dtSitzung
      )

      int_record.imported_id = a.id

      return int_record
    end
  end
end
