module Praxidata
  class BelSitzungen < Base
    set_table_name "TbelSitzungen"
    set_primary_key "IDbelSitzung"

    belongs_to :fall, :class_name => 'BelFaelle', :foreign_key => 'inBelegID'
    has_many :positionen, :class_name => 'BelPositionen', :foreign_key => 'inBelSitzungID'
    def self.int_class
      ::Session
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
