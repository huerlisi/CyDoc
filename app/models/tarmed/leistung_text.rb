# -*- encoding : utf-8 -*-
class Tarmed::LeistungText < Tarmed::Base
  set_table_name 'LEISTUNG_TEXT'
  set_primary_key "LNR"
  
  belongs_to :leistung, :class_name => 'Tarmed::Leistung', :foreign_key => 'LNR'
  has_one :digniquali, :class_name => 'LeistungDigniquali', :foreign_key => 'LNR'
end
