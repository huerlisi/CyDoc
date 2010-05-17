class Recall < ActiveRecord::Base
  # Associations
  belongs_to :patient
  belongs_to :appointment
  accepts_nested_attributes_for :appointment

  # Validations
  validates_presence_of :patient
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
    transitions :to => :sent, :from => :prepared, :on_transition => :sending
  end
  aasm_event :obey do
    transitions :to => :obeyed, :from => :sent
  end

  # Scopes
  named_scope :open, :conditions => {:state => ['scheduled', 'prepared', 'sent']}
  named_scope :queued, :conditions => {:state => ['scheduled', 'prepared']}
  named_scope :by_period, lambda {|from, to| { :conditions => { :due_date => from..to } } }
  
  private
  def assign_appointment(appointment)
    appointment.patient = self.patient
    appointment.state = 'proposed'
  end
  
  def sending
    self.sent_at = DateTime.now
  end
  
  public
  # Fix for nested attributes problem
  # See http://www.pixellatedvisions.com/2009/03/18/rails-2-3-nested-model-forms-and-nil-new-record
<<END
  def initialize(attributes=nil)
    super
    
    unless self.appointment
      self.build_appointment(:patient => self.patient)
    end
  end
END
end
