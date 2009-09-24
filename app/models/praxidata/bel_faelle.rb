module Praxidata
  class BelFaelle < Base
    set_table_name "TbelFaelle"
    set_primary_key "IDFall"

    has_many :diagnosen, :class_name => 'BelDiagnosen', :foreign_key => 'inFallID'
    belongs_to :stamm, :class_name => 'AdrStamm', :foreign_key => 'inStammID'
    belongs_to :abrechnungsmodus, :class_name => 'ModAbrechnungsmodus', :foreign_key => 'inModusID'
    
    has_many :belege, :class_name => 'BelBelege', :foreign_key => 'inFallID'
  end
end
