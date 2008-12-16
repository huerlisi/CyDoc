class TariffItemGroup < TariffItem
  has_and_belongs_to_many :tariff_items, :join_table => 'tariff_items_tariff_items'

  def create_service_record(patient, provider, responsible = nil)
    tariff_items.collect{|i| i.create_service_record(patient, provider, responsible)}
  end
end
