class MedicalCase < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
end
