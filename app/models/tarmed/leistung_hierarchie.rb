class Tarmed::LeistungHierarchie < Tarmed::Base
  set_table_name "LEISTUNG_HIERARCHIE"

  belongs_to :master, :class_name => 'Leistung', :foreign_key => 'LNR_MASTER'
  belongs_to :slave, :class_name => 'Leistung', :foreign_key => 'LNR_SLAVE'
end
