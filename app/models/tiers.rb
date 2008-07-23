class Tiers < ActiveRecord::Base
  has_one :invoice
  
  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :insurance
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :employer, :class_name => 'Patient' # TODO: not really patient

  def name
    type.to_s.gsub(/[a-z]/, '')
  end
end
