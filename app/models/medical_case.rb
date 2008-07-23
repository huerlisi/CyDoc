class MedicalCase < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor

  def date
    read_attribute(:duration_to)
  end
  
  def date=(value)
    write_attribute(:duration_from, value)
    write_attribute(:duration_to, value)
  end
end
