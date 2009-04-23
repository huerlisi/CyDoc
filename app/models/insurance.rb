class Insurance < ActiveRecord::Base
  # Vcards
  named_scope :by_name, lambda {|name| {:include => :vcard, :order => 'full_name', :conditions => Vcards::Vcard.by_name_conditions(name)}}

  has_one :vcard, :class_name => 'Vcards::Vcard', :as => 'object'
  has_many :vcards, :class_name => 'Vcards::Vcard', :as => 'object'

  delegate :full_name, :full_name=, :to => :vcard
  delegate :family_name, :family_name=, :to => :vcard
  delegate :given_name, :given_name=, :to => :vcard
  delegate :street_address, :street_address=, :to => :vcard
  delegate :extended_address, :extended_address=, :to => :vcard
  delegate :postal_code, :postal_code=, :to => :vcard
  delegate :locality, :locality=, :to => :vcard
  delegate :honorific_prefix, :honorific_prefix=, :to => :vcard
  delegate :phone_number, :phone_number, :to => :vcard
  delegate :fax_number, :fax_number, :to => :vcard
  delegate :mobile_number, :mobile_number, :to => :vcard
  
  named_scope :health_care, :conditions => {:role => 'H'}
  named_scope :accident, :conditions => {:role => 'A'}
  
  def to_s
    [vcard.full_name, vcard.locality].compact.join(', ')
  end

  def name
    vcard.full_name
  end

  # Overrides
  def role_code
    case read_attribute(:role)
      when 'H': "KVG"
      when 'A': "UVG"
    end
  end

  def role
    # TODO: should support multiple formats.
    # TODO: should probably use Law model.
    case read_attribute(:role)
      when 'H': "Krankenversicherung (KVG)"
      when 'A': "Unfallversicherung (UVG)"
    end
  end

  # Group
  def members
    Insurance.find(:all, :conditions => {:group_ean_party => ean_party})
  end
  
  def group
    Insurance.find(:first, :conditions => {:ean_party => group_ean_party})
  end
end
