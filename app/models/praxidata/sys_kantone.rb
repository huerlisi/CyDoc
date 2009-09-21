module Praxidata
  class SysKantone < Base
    set_table_name "TsysKantone"
    set_primary_key "IDKanton"

    # Select shSpracheID = 1, german
    has_one :bezeichnung, :class_name => 'SysKantonbezeichnungen', :foreign_key => 'inKantonID', :conditions => 'shSpracheID = 1'

    def to_s
      bezeichnung.txKanton
    end
  end
end
