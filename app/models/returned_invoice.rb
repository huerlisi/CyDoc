class ReturnedInvoice < ActiveRecord::Base
  # State Machine
  include AASM
  aasm_column :state
  validates_presence_of :state

  aasm_initial_state :new
  aasm_state :new
  aasm_state :request_pending
  aasm_state :resolved

  aasm_event :request do
    transitions :from => :new, :to => :request_pending
  end

  aasm_event :resolve do
    transitions :from => [:new, :request_pending], :to => :resolved
  end

  # Invoice
  belongs_to :invoice
  validates_presence_of :invoice_id
  validates_presence_of :invoice, :message => 'Rechnung nicht gefunden'
end
