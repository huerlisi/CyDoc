# -*- encoding : utf-8 -*-
class FreeTariffItem < TariffItem
  def self.tariff_type
    999
  end
  
  def unit_mt
    1.0
  end

  def unit_tt
    1.0
  end
end
