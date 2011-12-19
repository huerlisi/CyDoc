class FreeTariffItem < TariffItem
  def self.tariff_type
    'free'
  end
  
  def unit_mt
    1.0
  end

  def unit_tt
    1.0
  end
end
