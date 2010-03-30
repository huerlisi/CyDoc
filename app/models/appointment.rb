class Appointment < ActiveRecord::Base
  # Associations
  belongs_to :patient
  has_one :recall
  
  # Validations
  validates_presence_of :date, :patient
  
  # State Machine
  include AASM
  aasm_column :state
  
  aasm_initial_state :scheduled

  aasm_state :proposed
  aasm_state :scheduled
  aasm_state :canceled
  named_scope :open, :conditions => {:state => ['proposed', 'scheduled']}

  aasm_event :accept do
    transitions :to => :scheduled, :from => :proposed
  end
  aasm_event :cancel do
    transitions :to => :canceled
  end
end
