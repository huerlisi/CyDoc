module Praxidata
  class BelTarife < Base
    set_table_name "TbelTarife"
    set_primary_key "IDBelTarif"

    belongs_to :beleg, :class_name => 'TbelBelege', :foreign_key => 'inBelegID'
    belongs_to :tarif, :class_name => 'TbelBelege', :foreign_key => 'inBelegID'
  end
end
