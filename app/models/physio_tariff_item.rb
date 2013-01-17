# -*- encoding : utf-8 -*-
class PhysioTariffItem < TariffItem
  def unit_mt
    case reason
    when "Unfall"
      1.0
    else
      1.03
    end
  end

  def unit_tt
    case reason
    when "Unfall"
      1.0
    else
      1.03
    end
  end

  def self.tariff_type
    "311"
  end
end
