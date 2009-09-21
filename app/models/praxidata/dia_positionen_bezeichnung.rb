module Praxidata
  class DiaPositionenBezeichnung < Base
    set_table_name "TdiaPositionenBezeichnung"
    set_primary_key "IDPositionenBezeichnung"

    belongs_to :position, :class_name => 'TdiaPositionen', :foreign_key => 'inPositionID'
  end
end
