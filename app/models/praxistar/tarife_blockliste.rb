class Praxistar::TarifeBlockliste < Praxistar::Base
  set_table_name "Tarife_Blockliste"
  
  belongs_to :group, :class_name => 'TariffItemGroupImporter', :foreign_key => 'Block_ID'
  belongs_to :position, :class_name => 'TariffItemImporter', :foreign_key => 'tx_Code1'
end
