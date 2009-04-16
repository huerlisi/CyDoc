class Insurance < ActiveRecord::Base
  has_one :vcard, :class_name => 'Vcards::Vcard', :as => 'object'
  has_many :vcards, :class_name => 'Vcards::Vcard', :as => 'object'

  named_scope :by_name, lambda {|name| {:include => :vcard, :order => 'full_name', :conditions => Vcards::Vcard.by_name_conditions(name)}}
  delegate :full_name, :full_name=, :to => :vcard
  delegate :family_name, :family_name=, :to => :vcard
  delegate :given_name, :given_name=, :to => :vcard
  delegate :street_address, :street_address=, :to => :vcard
  delegate :extended_address, :extended_address=, :to => :vcard
  delegate :postal_code, :postal_code=, :to => :vcard
  delegate :locality, :locality=, :to => :vcard
  delegate :honorific_prefix, :honorific_prefix=, :to => :vcard

  def to_s
    [vcard.full_name, vcard.locality].compact.join(', ')
  end

  def name
    vcard.full_name
  end

  # Override
  def role
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
