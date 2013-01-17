# -*- encoding : utf-8 -*-
class Tiers < ActiveRecord::Base
  has_many :invoices

  belongs_to :biller, :class_name => 'Doctor'
  belongs_to :provider, :class_name => 'Doctor'
  belongs_to :insurance
  belongs_to :patient
  belongs_to :referrer, :class_name => 'Doctor'
  belongs_to :employer, :class_name => 'Patient' # TODO: not really patient

  attr_accessible :patient, :provider, :biller, :referrer

  def name
    self.class.to_s.gsub(/[a-z]/, '')
  end
end
