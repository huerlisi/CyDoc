class ServiceRecord < ActiveRecord::Base
  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :responsible, :class_name => 'Doctor'

  belongs_to :patient

  has_and_belongs_to_many :invoices
  has_and_belongs_to_many :sessions
  
  # Calculated field
  def amount
    # TODO: round as requested by standard
    self.quantity * ((self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt))
  end

  def text
    remark
  end
end
