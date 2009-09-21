module Praxidata
  class SysKantonbezeichnungen < Base
    set_table_name "TsysKantonbezeichnungen"

    belongs_to :kanton, :class_name => 'SysKantone', :foreign_key => 'inKantonID'
  end
end
