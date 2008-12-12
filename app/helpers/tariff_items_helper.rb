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
end
