class Insurance < ActiveRecord::Base
  belongs_to :vcard, :class_name => 'Vcards::Vcard', :foreign_key => 'vcard_id'
end
