# -*- encoding : utf-8 -*-
class MedicalCase < ActiveRecord::Base
  belongs_to :doctor
  belongs_to :treatment, :touch => true

  def to_s(format = :default)
    "#{code}"
  end
  
  def date
    read_attribute(:duration_to)
  end
  
  def date=(value)
    write_attribute(:duration_from, value)
    write_attribute(:duration_to, value)
  end
end
