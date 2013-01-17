# -*- encoding : utf-8 -*-
class ReturnedInvoice < ActiveRecord::Base
  # Access Restrictions
  attr_accessible :invoice_id, :state, :remarks

  # Sorting
  default_scope :order => "doctor_id, state, id"

  # String
  def to_s
    "%s: %s" % [state, invoice]
  end

  # State Machine
  include AASM
  aasm_column :state
  validates :state , :presence => true

  aasm_initial_state :ready
  aasm_state :ready
  aasm_state :request_pending
  aasm_state :resolved

  aasm_event :queue_request do
    transitions :from => :ready, :to => :request_pending
  end

  aasm_event :reactivate do
    transitions :from => [:ready, :request_pending], :to => :resolved
  end

  aasm_event :write_off do
    transitions :from => [:ready, :request_pending], :to => :resolved
  end

  scope :by_state, lambda {|value| {:conditions => {:state => value} } }
  scope :active, :conditions => {:state => ["ready", "request_pending"]}

  # Invoice
  belongs_to :invoice
  validates :invoice_id , :presence => true
  validates :invoice , :presence => {:message => 'Rechnung nicht gefunden'}
  accepts_nested_attributes_for :invoice
  attr_accessible :invoice_attributes

  def validate_on_create
    # Check if an open returned_invoice record with same invoice exists
    if ReturnedInvoice.active.count(:conditions => {:invoice_id => self.invoice_id}) > 0
      errors.add_to_base("Rechnung bereits erfasst.")
    end
  end

  def patient
    # Guard
    return unless invoice

    invoice.patient
  end

  # Doctor
  belongs_to :doctor
  scope :by_doctor_id, lambda {|doctor_id| {:conditions => {:doctor_id => doctor_id}}}
  before_save :set_doctor

private
  def set_doctor
    self.doctor = invoice.treatment.referrer
  end
end
