module Praxidata
  class PatNummer < Base
    set_table_name "TpatNummer"
    set_primary_key "IDPatientenNummer"
    
    belongs_to :patient, :class_name => 'AdrStamm', :foreign_key => 'inPatientID'
  end
end
