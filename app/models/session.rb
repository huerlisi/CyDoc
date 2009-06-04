class Session < ActiveRecord::Base
  belongs_to :patient
  has_and_belongs_to_many :diagnoses
  has_and_belongs_to_many :service_records

  named_scope :scheduled, :conditions => "state = 'scheduled'"
  named_scope :open, :conditions => "state = 'open'"
  named_scope :closed, :conditions => "state = 'closed'"

  def self.build_from_invoice(invoice)
    session = self.new
    
    session.patient = invoice.patient
    session.duration_from = invoice.treatment.date_begin
    session.duration_to = invoice.treatment.date_end
    session.diagnoses = invoice.treatment.diagnoses
    session.service_records = invoice.service_records
    
    session.invoice = invoice
    session.state = 'closed'
    
    return session
  end
end
