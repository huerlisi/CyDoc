class TariffItemGroup < TariffItem
  has_and_belongs_to_many :tariff_items, :join_table => 'tariff_items_tariff_items'

  def to_s
    group_s = super
    group_s + " (#{tariff_items.count} pos.):\n" + tariff_items.map{|item| "      " + item.to_s}.join("\n")
  end

  def create_service_record(patient, provider, responsible = nil)
    tariff_items.collect{|i| i.create_service_record(patient, provider, responsible)}
  end
end
