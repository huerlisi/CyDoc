module Praxidata
  class TarBlockLeistung < Base
    set_table_name "TtarBlockLeistung"
    set_primary_key "IDBlockLeistung"

    belongs_to :tariff_item_group, :class_name => 'TarBloecke', :foreign_key => 'inBlockID'
  end
end
