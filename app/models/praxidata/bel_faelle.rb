module Praxidata
  class BelFaelle < Base
    set_table_name "TbelFaelle"
    set_primary_key "IDFall"

    has_many :sitzungen, :class_name => 'BelSitzungen', :foreign_key => 'inBelegID'
    belongs_to :stamm, :class_name => 'AdrStamm', :foreign_key => 'inStammID'
  end
end
