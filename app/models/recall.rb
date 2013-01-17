# -*- encoding : utf-8 -*-
class Recall < ActiveRecord::Base
  # Access restrictions
  attr_accessible :state, :doctor_id, :due_date, :remarks, :appointment_attributes

  # Associations
  belongs_to :patient, :touch => true
  belongs_to :doctor
  belongs_to :appointment
  accepts_nested_attributes_for :appointment

  # Validations
  validates_presence_of :patient
  validates_presence_of :doctor
  validates_date :due_date

  # State Machine
  include AASM
  aasm_column :state

  aasm_initial_state :scheduled

  aasm_state :scheduled
  aasm_state :canceled
  aasm_state :prepared
  aasm_state :sent
  aasm_state :obeyed

  aasm_event :cancel do
    transitions :to => :canceled, :from => [:scheduled, :sent]
  end
  aasm_event :prepare do
    transitions :to => :prepared, :from => :scheduled
  end
  aasm_event :send_notice do
    transitions :to => :sent, :from => [:prepared, :scheduled], :on_transition => :sending
  end
  aasm_event :obey do
    transitions :to => :obeyed, :from => :sent
  end

  # Scopes
  default_scope order("due_date DESC")
  scope :active, :conditions => {:state => ['scheduled', 'prepared', 'sent']}
  scope :queued, :conditions => {:state => ['scheduled', 'prepared']}
  scope :by_period, lambda {|from, to| { :conditions => { :due_date => from..to } } }

  private
  def assign_appointment(appointment)
    appointment.patient = self.patient
    appointment.state = 'proposed'
  end

  def sending
    self.sent_at = DateTime.now
  end

  public
  def self.filter_months(limit = nil)
    months = Recall.active.all(:select => "date_format(due_date, '%Y-%m-01') AS month, count(*) AS count", :group => "date_format(due_date, '%Y-%m-01')", :order => "due_date", :limit => limit)
    months.map{|recall|
      [Date.parse(recall.month), recall.count]
    }
  end

  def to_s
   "#{patient} #{state} #{due_date}"
  end

  # PDF/Print
  include ActsAsDocument
end
