# encoding: utf-8

class Doctor < ActiveRecord::Base
  # Settings
  has_settings
  def self.settings
    doctor = Doctor.find(Thread.current["doctor_id"]) if Doctor.exists?(Thread.current["doctor_id"])

    doctor.present? ? doctor.settings : Settings
  end

  has_vcards

  # Accounts
  has_accounts
  belongs_to :esr_account, :class_name => 'BankAccount'

  has_many :patients

  has_and_belongs_to_many :offices

  def to_s
    [vcard.honorific_prefix, vcard.given_name, vcard.family_name].compact.select{|f| not f.empty?}.join(" ")
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
    return [] if query.nil? or query.empty?
    
    query_params = {}
    query_params[:query] = "%#{query}%"

    vcard_condition = "(vcards.given_name LIKE :query) OR (vcards.family_name LIKE :query) OR (vcards.full_name LIKE :query)"

    find(:all, :include => [:vcard], :conditions => ["#{vcard_condition}", query_params], :order => 'full_name, family_name, given_name')
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
