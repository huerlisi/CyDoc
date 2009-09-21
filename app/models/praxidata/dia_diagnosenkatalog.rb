module Praxidata
  class DiaDiagnosenkatalog < Base
    set_table_name "TdiaDiagnosenkatalog"
    set_primary_key "IDDiagnosenkatalog"

    has_many :positionen, :class_name => 'DiaPositionen', :foreign_key => 'inDiagnosenkatalogID'

    # Select shSpracheID = 1, german
    has_one :bezeichnung, :class_name => 'DiaDiagnosenkatalogBezeichnung', :foreign_key => 'inDiagnosenkatalogID', :conditions => 'shSpracheID = 1'

    def to_s
      bezeichnung.txBezeichnung
    end
  end
end
