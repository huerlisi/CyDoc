class TariffItemGroup < TariffItem
  has_many :service_items, :order => 'position'

  def to_s
    group_s = super
    group_s + " (#{service_items.count} pos.):\n" + service_items.map{|item| "      " + item.to_s}.join("\n")
  end

  def create_service_record
    service_items.collect{|item|
      item.create_service_record
    }
  end
end
