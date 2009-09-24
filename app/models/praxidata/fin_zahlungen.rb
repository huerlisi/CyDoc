module Praxidata
  class FinZahlungen < Base
    set_table_name "TFinZahlungen"
    set_primary_key "IDZahlung"

    belongs_to :beleg, :class_name => 'BelBelege', :foreign_key => 'inBelegID'
    belongs_to :debitor, :class_name => 'BelDebitoren', :foreign_key => 'inDebitorID'

    # inRate: 0 => alle
  end
end
