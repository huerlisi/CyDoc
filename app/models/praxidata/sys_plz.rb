module Praxidata
  class SysPlz < Base
    set_table_name "TsysPLZ"
    set_primary_key "IDPLZ"

    belongs_to :land, :class_name => 'SysLaender', :foreign_key => 'inLandID'
    belongs_to :kanton, :class_name => 'SysKantone', :foreign_key => 'inKantonID'
  end
end
