class TariffItemGroup < TariffItem
  has_and_belongs_to_many :tariff_items, :join_table => 'tariff_items_tariff_items'
end
