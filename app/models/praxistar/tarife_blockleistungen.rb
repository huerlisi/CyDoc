module Praxistar
  class TarifeBlockleistungen < Base
    set_table_name "Tarife_Blockleistungen"
    set_primary_key "ID_Blockleistung"

    belongs_to :group, :class_name => 'TarifeBloecke', :foreign_key => 'Block_ID'
  end
end
