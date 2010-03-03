class Recall < ActiveRecord::Base
  # Associations
  belongs_to :patient

  # State Machine
  include AASM
  aasm_column :state
  
  aasm_state :open
  aasm_state :canceled
  aasm_state :obeyed

  aasm_event :cancel do
    transitions :to => :canceled, :from => :open
  end
  aasm_event :obey do
    transitions :to => :obeyed, :from => :open
  end
end
