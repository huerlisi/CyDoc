class Employee < ActiveRecord::Base
  has_one :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'object_id'
  has_one :user, :foreign_key => 'object_id'
end
