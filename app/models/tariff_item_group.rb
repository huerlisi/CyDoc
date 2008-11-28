class TariffItemGroup < ActiveRecord::Base
  has_and_belongs_to_many :tariff_items, :join_table => 'tariff_item_groups_tariff_items', :class_name => 'Tarmed::Leistung', :foreign_key => :code
end
