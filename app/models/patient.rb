# -*- encoding : utf-8 -*-

class Patient < ActiveRecord::Base
  # Access restrictions
  attr_accessible :vcard_attributes, :dunning_stop, :birth_date, :doctor_patient_nr, :doctor_id, :insurance_policies_attributes, :use_billing_address, :billing_vcard_attributes, :remarks

  belongs_to :doctor

  # Insurance
  has_many :insurance_policies
  accepts_nested_attributes_for :insurance_policies, :reject_if => proc { |attrs| attrs['insurance_id'].blank? }
  has_many :insurances, :through => :insurance_policies

  def kvg_insurance_policy
    policy = insurance_policies.by_policy_type('KVG').first

    policy ||= insurance_policies.build(:policy_type => 'KVG')

    return policy
  end

  def insurance
    kvg_insurance_policy.insurance
  end
  def insurance=(value)
    kvg_insurance_policy.insurance = value
    kvg_insurance_policy.save
  end

  def insurance_id
    kvg_insurance_policy.insurance_id
  end
  def insurance_id=(value)
    kvg_insurance_policy.insurance_id = value
    kvg_insurance_policy.save
  end

  def insurance_nr
    kvg_insurance_policy.number
  end
  def insurance_nr=(value)
    kvg_insurance_policy.number = value
    kvg_insurance_policy.save
  end

  has_many :sessions
  has_many :recalls, :order => 'due_date', :dependent => :destroy
  has_many :appointments, :order => 'date', :dependent => :destroy

  # Vcards
  has_vcards
  # Hack to use 'private' address by default
  has_one :vcard, :as => 'object', :conditions => {:vcard_type => 'private'}
  accepts_nested_attributes_for :vcard
  has_one :billing_vcard, :class_name => 'Vcard', :as => 'object', :conditions => {:vcard_type => 'billing'}
  accepts_nested_attributes_for :billing_vcard
  def billing_vcard_with_autobuild
    billing_vcard_without_autobuild || build_billing_vcard
  end
  alias_method_chain :billing_vcard, :autobuild

  def invoice_vcard
    if use_billing_address?
      return billing_vcard
    else
      return vcard
    end
  end

  default_scope :include => {:vcard => :addresses}

  scope :by_date, lambda {|date| {:conditions => ['birth_date LIKE ?', Date.parse_europe(date).strftime('%%%y-%m-%d')] }}

  # Invoices
  scope :dunning_stopped, :conditions => {:dunning_stop => true}

  has_many :tiers
  has_many :invoices, :through => :tiers, :order => 'created_at DESC'

  has_many :treatments, :order => 'date_begin DESC'

  # Helpers
  def deletable?
    treatments.empty?
  end

  public
  # Validation
  validates_presence_of :family_name, :given_name
  validates_date :birth_date

  def validate_for_invoice(invoice)
    for field in [:sex, :birth_date]
      errors.add(field, "für Patient nicht gesetzt") if self.send(field).blank?
    end
    for field in [:postal_code, :locality]
      errors.add(field, "für Rechnungsadressat nicht gesetzt") if self.invoice_vcard.send(field).blank?
    end

    unless invoice_vcard.street_address.present? or invoice_vcard.extended_address.present? or invoice_vcard.post_office_box.present?
      errors.add(:base, "Mindestens eines der Felder 'Strasse', 'Adresszusatz' oder 'Postfach' muss gesetzt sein")
    end
  end

  def valid_for_invoice?(invoice)
    valid?
    validate_for_invoice(invoice)

    errors.empty?
  end

  def to_s(format = :default)
    ["#{name}#{(' #' + doctor_patient_nr) unless doctor_patient_nr.blank?}", (I18n.l(birth_date) if birth_date)].compact.join(', ')
  end

  def last_session
    treatments.map{|t| t.sessions}.flatten.first
  end

  # Services
  has_many :service_records, :order => 'date DESC', :before_add => :before_add_service_record

  # Proxy accessors
  def name
    if vcard.nil?
      ""
    else
      vcard.full_name || ""
    end
  end

  def sex
    case read_attribute(:sex)
      when 1
        "M"
      when 2
        "F"
      else "unbekannt"
    end
  end

  def sex=(value)
    case value
      when "M"
        write_attribute(:sex, 1)
      when "F"
        write_attribute(:sex, 2)
      else write_attribute(:sex, nil)
    end
  end

  def sex_xml
    case read_attribute(:sex)
      when 1
        "male"
      when 2
        "female"
      else nil
    end
  end

  # Sphinx Search
  # =============
  define_index do
    # Delta index
    set_property :delta => true

    indexes birth_date

    indexes vcard.full_name
    indexes vcard.nickname
    indexes vcard.family_name, :as => :family_name, :sortable => true
    indexes vcard.given_name, :as => :given_name, :sortable => true
    indexes vcard.additional_name
    indexes vcard.address.street_address
    indexes vcard.address.postal_code
    indexes vcard.address.locality
    indexes vcard.address.extended_address
    indexes vcard.address.post_office_box

    indexes billing_vcard.full_name
    indexes billing_vcard.nickname
    indexes billing_vcard.family_name
    indexes billing_vcard.given_name
    indexes billing_vcard.additional_name
    indexes billing_vcard.address.street_address
    indexes billing_vcard.address.postal_code
    indexes billing_vcard.address.locality
    indexes billing_vcard.address.extended_address
    indexes billing_vcard.address.post_office_box

    indexes doctor_patient_nr

    indexes cases.praxistar_eingangsnr
  end

  def self.by_text(query, options = {})
    options.merge!({:match_mode => :extended, :order => 'family_name ASC, given_name ASC'})

    search(build_query(query), options)
  end

  def self.quote_query(query)
    "\"#{query}\""
  end

  def self.build_query_part(part)
    case part
    when /([0-9]{1,2})\/([0-9]{1,5})/
      # Use .to_i as leading 0 let's them be interpreted as octal otherwise
      eingangs_nr = "%02i/%05i" % [$1.to_i, $2.to_i]
      quote_query(eingangs_nr)
    when /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2,4}/
      day, month, year = part.split('.').map(&:to_i)
      if year < 100
        year1900 = quote_query(Date.new(1900 + year, month, day).to_s(:db))
        year2000 = quote_query(Date.new(2000 + year, month, day).to_s(:db))
        return "(#{year1900} | #{year2000})"
      else
        return quote_query(Date.new(year, month, day).to_s(:db))
      end
    else
      return part
    end
  end

  def self.build_query(query)
    return '' unless query.present?

    parts = query.split(/ /)

    parts.map{|part| build_query_part(part)}.join(' ')
  end

  # Tarmed
  # ======
  # Association callbacks
  def before_add_service_record(service_record)
    service_record.provider ||= self.doctor
    service_record.biller ||= self.doctor
    service_record.responsible ||= self.doctor
  end

  # Covercard
  # =========
  before_save :clean_covercard_code

  def clean_covercard_code
    self[:covercard_code] = Covercard::Patient.clean_code(self.covercard_code)
  end
end
