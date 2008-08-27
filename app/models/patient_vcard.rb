class PatientVcard < ActiveRecord::Base
  belongs_to :patient
  belongs_to :vcard, :class_name => 'Vcards::Vcard'
end
