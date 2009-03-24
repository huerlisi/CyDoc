class Insurance < ActiveRecord::Base
  has_one :vcard, :class_name => 'Vcards::Vcard', :as => 'object'
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
    to_s
  end
end
