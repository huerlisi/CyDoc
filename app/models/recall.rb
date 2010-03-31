class Recall < ActiveRecord::Base
  # Associations
  belongs_to :patient
  belongs_to :appointment
  accepts_nested_attributes_for :appointment

  # Validations
  validates_presence_of :due_date, :patient
  validates_format_of :due_date, :with => /[0-9]{1,2}\.[0-9]{1,2}\.20[0-9]{2}/, :message => "Format DD.MM.20YY" # TODO will break in 2100:-(
  
  # State Machine
  include AASM
  aasm_column :state
  
  aasm_state :open
  aasm_state :canceled
  aasm_state :sent
  aasm_state :obeyed

  aasm_event :cancel do
    transitions :to => :canceled, :from => :open
  end
  aasm_event :send_notice do
    transitions :to => :sent, :from => :open, :on_transition => :sending
  end
  aasm_event :obey do
    transitions :to => :obeyed, :from => :open
  end

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
  def initialize(attributes=nil)
    super
    
    unless self.appointment
      self.build_appointment(:patient => self.patient)
    end
  end
end
