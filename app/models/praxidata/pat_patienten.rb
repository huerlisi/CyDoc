module Praxidata
  class PatPatienten < Base
    set_table_name "TpatPatienten"
    
    belongs_to :stamm, :class_name => 'AdrStamm', :foreign_key => 'inStammID'
  end
end
