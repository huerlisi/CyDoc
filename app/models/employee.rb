class Employee < ActiveRecord::Base
  has_one :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'object_id'
  belongs_to :user
end
