# Information about invoice batch printing jobs.
class InvoiceBatchJob < ActiveRecord::Base
  # Access Restricitons
  attr_accessible :value_date, :count, :tiers_name

  # Columns
  serialize :failed_jobs

  # Associations
  has_and_belongs_to_many :invoices

  # Calculated columns
  def failed_job_count
    failed_jobs.size
  end

  def initialize(params = {})
    super
    self.failed_jobs = []
  end

  def clean_failed_invoice_jobs
    self.failed_jobs = self.failed_jobs.reject{|job| job[:invoice_id]}
  end

  def print(printers)
    clean_failed_invoice_jobs

    invoices.each_with_index do |invoice, index|
      # Sleep for 4min every 50 treatments
      if index > 0 and index.modulo(50) == 0
        sleep 4 * 60
      end

      # Print
      begin
        invoice.print(printers[:trays][:plain], printers[:trays][:invoice])
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end

  def create_invoices(treatments, value_date, tiers_name, provider, biller)
    treatments.each do |treatment_readonly|
      treatment = Treatment.find(treatment_readonly.id)

      # Create invoice
      invoice = Invoice.create_from_treatment({:value_date => value_date}, treatment, tiers_name, provider, biller)

      if invoice.new_record?
        # Invoice was invalid in some way
        self.failed_jobs << {:treatment_id => treatment.id, :message => invoice.errors.full_messages}
      else
        # Record as belonging to this batch
        self.invoices << invoice
      end
    end
  end
end
