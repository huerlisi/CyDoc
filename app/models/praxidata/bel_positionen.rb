module Praxidata
  class BelPositionen < Base
    set_table_name "TbelPositionen"
    set_primary_key "IDPosition"

    belongs_to :sitzung, :class_name => 'BelSitzungen', :foreign_key => 'inBelSitzungID'
  end
end
