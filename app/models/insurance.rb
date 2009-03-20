class Insurance < ActiveRecord::Base
  belongs_to :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'vcard_id'
  named_scope :by_name, lambda {|name| {:select => '*, insurances.id', :joins => :vcard, :order => 'full_name', :conditions => Vcards::Vcard.by_name_conditions(name)}}

  def name
    [vcard.full_name, vcard.locality].compact.join(', ')
  end
end
