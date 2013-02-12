# -*- encoding : utf-8 -*-

class Doctor < Person
  # Access restrictions
  attr_accessible :vcard, :ean_party, :zsr

  scope :active, where(:active => true)

  # Helpers
  # =======
  def to_s
    [vcard.honorific_prefix, vcard.full_name].map(&:presence).compact.join(" ")
  end

  # Proxy accessors
  def name
    vcard.try(:full_name)
  end

  # ZSR sanitation
  def zsr=(value)
    value.delete!(' .') unless value.nil?

    write_attribute(:zsr, value)
  end

  has_many :patients

  # User
  has_one :user, :as => :object, :autosave => true
  attr_accessible :user
  def email
    vcard.contacts.where(:phone_number_type => 'E-Mail').first
  end

  # Settings
  has_settings
  def self.settings
    doctor = Doctor.find(Thread.current["doctor_id"]) if Doctor.exists?(Thread.current["doctor_id"])

    doctor.present? ? doctor.settings : Settings
  end

  # Returned invoices
  has_many :returned_invoices
  def request_all_returned_invoices
    returned_invoices.ready.map {|returned_invoice| returned_invoice.queue_request!}
  end

  # PDF/Print
  include ActsAsDocument
  def self.document_type_to_class(document_type = nil)
    Prawn::ReturnedInvoiceRequestDocument
  end
end
