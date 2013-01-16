# encoding: utf-8

class Doctor < ActiveRecord::Base
  # Access restrictions
  attr_accessible :vcard, :ean_party, :zsr, :print_payment_for

  scope :active, where(:active => true)

  has_one :praxis, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'praxis'}

  # TODO support multiple vcards
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard
  attr_accessible :vcard_attributes

  has_one :private, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'private'}
  belongs_to :billing_doctor, :class_name => 'Doctor'

  # Settings
  has_settings
  def self.settings
    doctor = Doctor.find(Thread.current["doctor_id"]) if Doctor.exists?(Thread.current["doctor_id"])

    doctor.present? ? doctor.settings : Settings
  end

  has_vcards

  # Accounts
  has_many :accounts
  belongs_to :esr_account, :class_name => 'BankAccount'
  attr_accessible :esr_account_id

  has_many :patients

  has_and_belongs_to_many :offices

  # Helpers
  # =======
  def to_s
    [vcard.honorific_prefix, vcard.full_name].map(&:presence).compact.join(" ")
  end

  # Proxy accessors
  def name
    if vcard.nil?
      login
    else
      vcard.full_name
    end
  end

  def colleagues
    offices.map{|o| o.doctors}.flatten.uniq
  end

  # TODO:
  # This is kind of a primary office providing printers etc.
  # But it undermines the assumption that a doctor may belong/
  # own more than one office.
  def office
    offices.first
  end

  # ZSR sanitation
  def zsr=(value)
    value.delete!(' .') unless value.nil?

    write_attribute(:zsr, value)
  end

  # Search
  def self.clever_find(query)
    return scoped if query.blank?

    query_params = {}
    query_params[:query] = "%#{query}%"

    vcard_condition = "(vcards.given_name LIKE :query) OR (vcards.family_name LIKE :query) OR (vcards.full_name LIKE :query)"

    self.includes(:vcard).where("#{vcard_condition}", query_params).order('full_name, family_name, given_name')
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
