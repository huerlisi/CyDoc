# -*- encoding : utf-8 -*-
class ServiceRecord < ActiveRecord::Base
  # Access restrictions
  attr_accessible :quantity, :code, :ref_code, :remark, :amount

  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :responsible, :class_name => 'Doctor'

  scope :by_tariff_type, lambda {|tariff_type|
    if tariff_type
      {:conditions => {:tariff_type => tariff_type}}
    end
  }
  scope :obligate, :conditions => {:obligation => true}

  belongs_to :vat_class
  scope :full_vat, :conditions => {:vat_class_id => VatClass.full}
  scope :reduced_vat, :conditions => {:vat_class_id => VatClass.reduced}
  scope :excluded_vat, :conditions => {:vat_class_id => VatClass.excluded}

  belongs_to :patient

  has_and_belongs_to_many :invoices
  has_and_belongs_to_many :sessions, :after_add => :touch_sessions, :after_remove => :touch_sessions
  after_save(:touch_sessions)

  def touch_sessions(session = nil)
    if session
      session.touch
    else
      sessions.reload
      sessions.map{|session| session.touch}
    end
  end

  # Validation
  validates_presence_of :date, :code, :tariff_type, :session, :quantity, :unit_tt, :unit_mt, :unit_factor_tt, :unit_factor_mt

  def validate_for_invoice(invoice)
    if invoice.settings['validation.tarmed']
      errors.add(:base, "Position '#{code}' verlangt Referenzcode") unless valid_ref_code?
    end
  end

  def valid_for_invoice?(invoice)
    valid?
    validate_for_invoice(invoice)

    errors.empty?
  end

  def to_s(format = :default)
    case format
    when :stats
      "#{date.strftime('%d.%m.%Y')}: #{quantity}x #{code} #{!ref_code.nil? ? '(' + ref_code + ') ' : ''}- #{text}"
    else
      "#{sprintf('%03i', tariff_type)} - #{quantity}x #{code} #{!ref_code.nil? ? '(' + ref_code + ') ' : ''}- #{text}"
    end
  end

  # TODO: lookup in tarmed db
  def needs_ref_code?
    text.starts_with?('+')
  end

  def valid_ref_code?
    not (needs_ref_code? and read_attribute(:ref_code).blank?)
  end

  def ref_code
    valid_ref_code? ? read_attribute(:ref_code) : "Fehlende Referenz"
  end

  # Calculated field
  def amount
    self.quantity * ((self.amount_mt * self.unit_factor_mt * self.unit_mt).round(2) + (self.amount_tt * self.unit_factor_tt * self.unit_tt).round(2))
  end

  def tax_points_mt
    self.quantity * self.amount_mt
  end

  def tax_points_tt
    self.quantity * self.amount_tt
  end

  def tax_points
    tax_points_mt + tax_points_tt
  end

  def text
    remark
  end
end
