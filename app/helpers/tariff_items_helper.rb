# -*- encoding : utf-8 -*-
module TariffItemsHelper
  def duration(items)
    duration_from = items.collect {|item| item.date}.min
    duration_to = items.collect {|item| item.date}.max
    
    if duration_from.to_date == duration_to.to_date
      duration_from.strftime("%d.%m.%Y")
    else
      duration_from.strftime("%d.%m.%Y") + " - " + duration_to.strftime("%d.%m.%Y")
    end
  end

  def type_as_string_collection
    types = %w(TarmedTariffItem PhysioTariffItem LabTariffItem DrugTariffItem MigelTariffItem TariffItemGroup FreeTariffItem)
    types.map{|type| [t(type.underscore, :scope => [:activerecord, :models]), type]}
  end
end
