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
  delegate :full_name, :full_name=, :to => :vcard
  delegate :street_address=, :to => :vcard

  belongs_to :billing_vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'billing_vcard_id'
        
  has_many :cases, :order => 'id DESC'

  # Medical history
  has_many :medical_cases, :order => 'duration_to DESC'

  # Services
  has_many :record_tarmeds, :order => 'date DESC'

  # Proxy accessors
  def name
    if vcard.nil?
      ""
    else
      vcard.full_name || ""
    end
  end

  def name=(value)
    if v = vcards.active.first
      v.full_name = value
      v.save
    end
  end

  def sex
    case read_attribute(:sex)
      when 1: "M"
      when 2: "F"
      else "unbekannt"
    end
  end
end
