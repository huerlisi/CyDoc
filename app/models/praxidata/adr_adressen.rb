module Praxidata
  class AdrAdressen < Base
    set_table_name "TadrAdressen"
    set_primary_key "IDAdresse"

    # shAdressart: 1 => almost all, 2 => only one...
    # shZivilstandID: 1, 2, 3, 4, ''
    # KonfessionID: ''
    # shSexID: 2: female, 1: male, ''
    # shMuttersprache: ''
    belongs_to :stamm, :class_name => 'AdrStamm', :foreign_key => 'inStammID'
    belongs_to :plz, :class_name => 'SysPlz', :foreign_key => 'inPLZID'
  end
end
