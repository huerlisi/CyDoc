class Recall < ActiveRecord::Base
  # Associations
  belongs_to :patient

  # Validations
  validates_format_of :due_date, :with => /[0-9]{1,2}\.[0-9]{1,2}\.20[0-9]{2}/, :message => "Format DD.MM.20YY" # TODO will break in 2100:-(
  
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
