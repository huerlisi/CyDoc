class Insurance < ActiveRecord::Base
  has_one :vcard, :class_name => 'Vcards::Vcard', :as => 'object'
  named_scope :by_name, lambda {|name| {:include => :vcard, :order => 'full_name', :conditions => Vcards::Vcard.by_name_conditions(name)}}

  def to_s
    [vcard.full_name, vcard.locality].compact.join(', ')
  end

  def name
    to_s
  end
end
