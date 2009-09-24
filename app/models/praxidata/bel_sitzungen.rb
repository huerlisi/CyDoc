module Praxidata
  class BelSitzungen < Base
    set_table_name "TbelSitzungen"
    set_primary_key "IDbelSitzung"

    belongs_to :beleg, :class_name => 'BelBelege', :foreign_key => 'inBelegID'
    has_many :positionen, :class_name => 'BelPositionen', :foreign_key => 'inBelSitzungID'
  end
end
