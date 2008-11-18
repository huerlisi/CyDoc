class Insurance < ActiveRecord::Base
  belongs_to :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'vcard_id'
  named_scope :by_name, lambda {|name| {:select => '*, insurances.id', :joins => :vcard, :conditions => Vcards::Vcard.by_name_conditions(name)}}
end
