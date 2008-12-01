class TariffItem < ActiveRecord::Base
  has_and_belongs_to_many :tariff_item_groups

  # "Constant" fields
  def unit_mt
    1.89
  end

  def unit_tt
    1.89
  end

  def unit_factor_mt
    1.0
  end

  def unit_factor_tt
    1.0
  end

  # Fallbacks
  def amount_mt
    read_attribute(:amount_mt) || 0
  end

  def amount_tt
    read_attribute(:amount_tt) || 0
  end

  # Calculated field
  def amount
    (self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt)
  end

end
