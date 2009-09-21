module Praxidata
  class BelFaelle < Base
    set_table_name "TbelFaelle"
    set_primary_key "IDFall"

    has_many :sitzungen, :class_name => 'BelSitzungen', :foreign_key => 'inBelegID'

    def self.int_class
      ::Treatment
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :date_begin        => a.dtBeginn,
        :date_end          => a.dtEnde
        # TODO: create law record
      )

      int_record.imported_id = a.id

      return int_record
    end
  end
end
