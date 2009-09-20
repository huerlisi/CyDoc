module Praxidata
  class Praxidata::BelFaelle < Base
    set_table_name "TbelFaelle"
    set_primary_key "IDFall"

    def self.int_class
      ::Treatment
    end

    def self.import_record(a, options)
      int_record = int_class.new(
        :date_begin        => a.dtBeginn,
        :date_end          => a.dtEnde
        # TODO: create law record
      )

      return int_record
    end
  end
end
