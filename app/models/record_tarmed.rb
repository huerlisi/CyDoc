class RecordTarmed < ActiveRecord::Base
  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :responsible, :class_name => 'Doctor'

  belongs_to :patient

  has_and_belongs_to_many :invoices
  
  def initialize(attributes = nil)
    super(attributes)

    self.date = Date.today
  end

  # Lookup values from Tarmed Tariff when assigning code
  def code=(code)
    leistung = TariffItem.find_by_code(code)
    
    write_attribute(:code, code)
    
    self.amount_mt = leistung.amount_mt || 0.0
    self.unit_factor_mt = leistung.unit_factor_mt
    self.amount_tt = leistung.amount_tt || 0.0
    self.unit_factor_tt = leistung.unit_factor_tt
    self.remark = leistung.remark
    self.tariff_type = leistung.tariff_type
    
    self.unit_mt = leistung.unit_mt
    self.unit_tt = leistung.unit_tt
  end

  # Calculated field
  def amount
    self.quantity * ((self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt))
  end

  def text
    remark
  end
end
