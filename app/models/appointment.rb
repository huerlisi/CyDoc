# -*- encoding : utf-8 -*-
class Appointment < ActiveRecord::Base
  # Associations
  belongs_to :patient
  has_one :recall

  # Validations
  validates_presence_of :patient
  validates_date :date

  # State Machine
  include AASM
  aasm_column :state

  aasm_initial_state :scheduled

  aasm_state :proposed
  aasm_state :scheduled
  aasm_state :canceled
  scope :active, :conditions => {:state => ['proposed', 'scheduled']}

  aasm_event :accept do
    transitions :to => :scheduled, :from => :proposed
  end
  aasm_event :cancel do
    transitions :to => :canceled, :from => [:proposed, :scheduled]
  end

  # Scopes
  scope :by_period, lambda {|from, to| { :conditions => { :date => from..to } } }

  def from
    duration_from.try(:to_time)
  end

  def from=(value)
    self.duration_from = Time.zone.parse(value)
  end

  def to
    duration_to.try(:to_time)
  end

  def to=(value)
    self.duration_to = Time.zone.parse(value)
  end

  def to_s
    "#{date} #{[from, to].compact.join(' - ')}"
  end
end
