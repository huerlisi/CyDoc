# -*- encoding : utf-8 -*-
class TarmedTariffItem < TariffItem
  def unit_mt
    case reason
    when 'Unfall'
      0.92
    else
      0.89
    end
  end

  def unit_tt
    case reason
    when 'Unfall'
      0.92
    else
      0.89
    end
  end

  def self.tariff_type
    "001"
  end
end
