class Patient < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :doctor

  has_many :vcards, :class_name => 'Vcards::Vcard', :as => 'object'
  # FIX: This buggily needs this :select hack
  named_scope :by_name, lambda {|name| {:select => '*, patients.id', :joins => :vcards, :conditions => Vcards::Vcard.by_name_conditions(name)}}
  named_scope :by_date, lambda {|date| {:conditions => ['birth_date LIKE ?', Date.parse_europe(date).strftime('%%%y-%m-%d')] }}

#  belongs_to :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'vcard_id'
  def vcard
    vcards.build if vcards.active.first.nil?
    vcards.active.first
  end
  def vcard=(value)
    vcards << value
  end

  delegate :full_name, :full_name=, :to => :vcard
  delegate :street_address=, :to => :vcard

  belongs_to :billing_vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'billing_vcard_id'
        
  has_many :cases, :order => 'id DESC'

  # Medical history
  has_many :medical_cases, :order => 'duration_to DESC'

  # Services
  has_many :service_records, :order => 'date DESC', :before_add => :before_add_service_record

  # Proxy accessors
#  def name
#    if vcard.nil?
#      ""
#    else
#      vcard.full_name || ""
#    end
#  end
#
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

  # Authorization
  # =============
  def self.find(*args)
    with_scope(:find => {:conditions => {:doctor_id => Thread.current["doctor_ids"]}}) do
      super
    end
  end

  def self.create(attributes = nil, &block)
    with_scope(:create => {:doctor_id => Thread.current["doctor_id"]}) do
      super
    end
  end

  # Search
  # ======
  def self.clever_find(query, doctor_ids)
    return [] if query.nil? or query.empty?
    
    case get_query_type(query)
    when "date"
      query = Date.parse_europe(query).strftime('%%%y-%m-%d')
      patient_condition = "(patients.birth_date LIKE :query)"
    when "entry_nr"
      patient_condition = "(patients.doctor_patient_nr = :query)"
    when "text"
      query = "%#{query}%"
      patient_condition = "(vcards.given_name LIKE :query) OR (vcards.family_name LIKE :query) OR (vcards.full_name LIKE :query)"
    end
    return find(:all, :include => [:vcards ], :conditions => ["(#{patient_condition})", {:query => query}], :limit => 100)
  end

  private
  def self.get_query_type(value)
    if value.match(/([[:digit:]]{1,2}\.){2}/)
      return "date"
    elsif value.match(/^([[:digit:]]{0,2}\/)?[[:digit:]]*$/)
      return "entry_nr"
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
