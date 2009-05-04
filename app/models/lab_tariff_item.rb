class LabTariffItem < TariffItem
  def unit_mt
    0.0
  end

  def unit_tt
    1.0
  end

  def tariff_type
    tariff_type || "317"
  end
end
