class RecordTarmed < ActiveRecord::Base
  belongs_to :tarmed_leistung, :class_name => 'Tarmed::Leistung', :foreign_key => :code

  # Lookup values from Tarmed DB when assigning code
  def code=(code)
    leistung = Tarmed::Leistung.find(code)
    
    write_attribute(:code, code)
    
    self.amount_mt = leistung.amount_mt || 0.0
    self.unit_factor_mt = leistung.unit_factor_mt
    self.amount_tt = leistung.amount_tt || 0.0
    self.unit_factor_tt = leistung.unit_factor_tt
  end

  # "Constant" fields
  def unit_mt
    0.89
  end

  def unit_tt
    0.89
  end

  # Calculated field
  def amount
    self.quantity * ((self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt))
  end

  def text
    tarmed_leistung.name
  end
end
