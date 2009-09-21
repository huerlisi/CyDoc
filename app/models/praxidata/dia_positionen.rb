module Praxidata
  class DiaPositionen < Base
    set_table_name "TdiaPositionen"
    set_primary_key "IDPosition"

    belongs_to :diagnosenkatalog, :class_name => 'DiaDiagnosenkatalog', :foreign_key => 'inDiagnosenkatalogID'
    
    # Select shSpracheID = 1, german
    has_one :bezeichnung, :class_name => 'DiaPositionenBezeichnung', :foreign_key => 'inPositionenID', :conditions => 'shSpracheID = 1'

    def to_s
      bezeichnung.txBezeichnung
    end
  end
end
