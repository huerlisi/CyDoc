class Tarmed::LeistungText < Tarmed::Base
  set_table_name 'LEISTUNG_TEXT'

  belongs_to :leistung, :class_name => 'Tarmed::Leistung', :foreign_key => 'LNR'
end
