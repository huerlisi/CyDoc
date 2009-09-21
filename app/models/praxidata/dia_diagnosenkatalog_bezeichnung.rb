module Praxidata
  class DiaDiagnosenkatalogBezeichnung < Base
    set_table_name "TdiaDiagnosenkatalogBezeichnung"
    set_primary_key "IDDiagnosenkatalogBezeichnung"

    belongs_to :diagnosenkatalog, :class_name => 'TdiaDiagnosenkatalog', :foreign_key => 'inDiagnosenkatalogID'
  end
end
