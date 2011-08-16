class Patient < ActiveRecord::Base
  belongs_to :doctor

  # Insurance
  has_many :insurance_policies
  accepts_nested_attributes_for :insurance_policies, :reject_if => proc { |attrs| attrs['insurance_id'].blank? }
  has_many :insurances, :through => :insurance_policies

  has_many :sessions
  has_many :recalls, :order => 'due_date', :dependent => :destroy
  has_many :appointments, :order => 'date', :dependent => :destroy

  # Vcards
  # FIX: This buggily needs this :select hack
  named_scope :by_name, lambda {|name| {:select => '*, patients.id', :joins => :vcard, :conditions => Vcard.by_name_conditions(name)}}
  has_vcards
  # Hack to use 'private' address by default
  has_one :vcard, :as => 'object', :conditions => {:vcard_type => 'private'}

  accepts_nested_attributes_for :vcard
  default_scope :include => {:vcard => :addresses}

  named_scope :by_date, lambda {|date| {:conditions => ['birth_date LIKE ?', Date.parse_europe(date).strftime('%%%y-%m-%d')] }}

  has_many :tiers
  has_many :invoices, :through => :tiers, :order => 'created_at DESC'
  
  has_many :treatments, :order => 'date_begin DESC'
      
  # Helpers
  def deletable?
    treatments.empty?
  end
  
  # Phone Numbers
  has_many :phone_numbers, :as => :object
  accepts_nested_attributes_for :phone_numbers, :reject_if => proc { |attrs| attrs['number'].blank? }
  after_update :save_phone_numbers
  
  def new_phone_number_attributes=(phone_number_attributes)
    phone_number_attributes.each do |attributes|
      phone_numbers.build(attributes) unless attributes[:number].blank?
    end 
  end
  
  private
  def save_phone_numbers
    # Delete
    phone_numbers.each do |phone_number|
      phone_number.save(false)
    end
  end
  
  public
  # Validation
  validates_presence_of :family_name, :given_name
  validates_date :birth_date

  def validate_for_invoice
    for field in [:street_address, :postal_code, :locality, :sex, :birth_date]
      errors.add(field, "für Patient nicht gesetzt") if self.send(field).blank?
    end
  end
  
  def valid_for_invoice?
    valid?
    validate_for_invoice
    
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

#  def name=(value)
#    if v = vcards.active.first
#      v.full_name = value
#      v.save
#    end
#  end

  def sex
    case read_attribute(:sex)
      when 1: "M"
      when 2: "F"
      else "unbekannt"
    end
  end

  def sex=(value)
    case value
      when "M": write_attribute(:sex, 1)
      when "F": write_attribute(:sex, 2)
      else write_attribute(:sex, nil)
    end
  end

  def sex_xml
    case read_attribute(:sex)
      when 1: "male"
      when 2: "female"
      else nil
    end
  end

  # Authorization
  # =============
#  def self.find(*args)
#    with_scope(:find => {:conditions => {:doctor_id => Thread.current["doctor_ids"]}}) do
#      super
#    end
#  end

#  def self.create(attributes = nil, &block)
#    with_scope(:create => {:doctor_id => Thread.current["doctor_id"]}) do
#      super
#    end
#  end

  # Build an invoice containing all open sessions
  def build_invoice(options)
    invoice = invoices.new(options)

    # Tiers
    # TODO: something like:
    #@tiers = @invoice.build_tiers(params[:tiers])
    @tiers = TiersGarant.new
    invoice.tiers = @tiers
    #@tiers.biller = Doctor.find(Thread.current["doctor_id"])
    #@tiers.provider = Doctor.find(Thread.current["doctor_id"])

    # Law, TODO
    #@law = Object.const_get(options[:law][:name]).new
    #@law.insured_id = @patient.insurance_nr

    #@law.save
    #invoice.law = @law
    
    # Treatment
    @treatment = invoice.build_treatment()

    # TODO make selectable
#    @treatment.canton ||= @tiers.provider.vcard.address.region

    # Services
    # TODO: only open records

    invoice.service_records = service_records
    @treatment.date_begin = service_records.minimum(:date)
    @treatment.date_end = service_records.maximum(:date)

    return invoice
  end
  
  # Search
  # ======
  def self.clever_find(query, args = {})
    return [] if query.blank?

    query.strip!
    query_params = {}
    case get_query_type(query)
    when "number"
      query_params[:query] = query
      patient_condition = "patients.doctor_patient_nr = :query"
    when "date"
      query_params[:query] = Date.parse_europe(query).strftime('%%%y-%m-%d')
      patient_condition = "(patients.birth_date LIKE :query)"
    when "text"
      query_params[:query] = "%#{query}%"
      query_params[:wildcard_value] = '%' + query.gsub(/[ -.]+/, '%') + '%'
      name_condition = "(vcards.given_name LIKE :wildcard_value) OR (vcards.family_name LIKE :wildcard_value) OR (vcards.full_name LIKE :wildcard_value)"
      given_family_condition = "( concat(vcards.given_name, ' ', vcards.family_name) LIKE :wildcard_value)"
      family_given_condition = "( concat(vcards.family_name, ' ', vcards.given_name) LIKE :wildcard_value)"

      patient_condition = "#{name_condition} OR #{given_family_condition} or #{family_given_condition}"
    end

    args.merge!(:include => [:vcard ], :conditions => ["(#{patient_condition})", query_params], :order => 'vcards.family_name, vcards.given_name')
    find(:all, args)
  end

  private
  def self.get_query_type(value)
    if value.match(/^[[:digit:]]*$/)
      return "number"
    elsif value.match(/([[:digit:]]{1,2}\.){2}/)
      return "date"
    else
      return "text"
    end
  end

  # Tarmed
  # ======
  # Association callbacks
  def before_add_service_record(service_record)
    service_record.provider ||= self.doctor
    service_record.biller ||= self.doctor
    service_record.responsible ||= self.doctor
  end
end
