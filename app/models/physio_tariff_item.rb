class PhysioTariffItem < TariffItem
  def unit_mt
    if @session.nil?
      1.11
    elsif reason == "Unfall" || law.name == 'UVG' || law.name == 'IVG'
      1.0
    elsif new_reason?
      1.11
    else
      1.03
    end
  end

  def unit_tt
    if @session.nil?
      1.11
    elsif reason == "Unfall" || law.name == 'UVG' || law.name == 'IVG'
      1.0
    elsif new_reason?
      1.11
    else
      1.03
    end
  end

  def self.tariff_type
    "311"
  end
end
