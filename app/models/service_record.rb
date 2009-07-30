class ServiceRecord < ActiveRecord::Base
  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :responsible, :class_name => 'Doctor'

  belongs_to :vat_class
  named_scope :full_vat, :conditions => {:vat_class_id => VatClass.full}
  named_scope :reduced_vat, :conditions => {:vat_class_id => VatClass.reduced}
  named_scope :excluded_vat, :conditions => {:vat_class_id => VatClass.excluded}
  
  belongs_to :patient

  has_and_belongs_to_many :invoices
  has_and_belongs_to_many :sessions
  
  validates_presence_of :date

  def to_s
    "#{sprintf('%03i', tariff_type)} - #{quantity}x #{code} #{!ref_code.nil? ? '(' + ref_code + ') ' : ''} - #{text}"
  end
  
  # TODO: lookup in tarmed db
  def needs_ref_code?
    text.starts_with?('+')
  end
  
  def ref_code
    value = read_attribute(:ref_code)
    value = "Fehlende Referenz" if value.nil? and needs_ref_code?
    return value
  end
  
  # Calculated field
  def amount
    # TODO: round as requested by standard
    self.quantity * ((self.amount_mt * self.unit_factor_mt * self.unit_mt) + (self.amount_tt * self.unit_factor_tt * self.unit_tt))
  end

  def text
    remark
  end
end
