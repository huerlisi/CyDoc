# -*- encoding : utf-8 -*-
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

  def to_s
    "Rechnungslauf vom #{value_date}"
  end

  def initialize(params = {})
    super
    self.failed_jobs = []
  end

  def clean_failed_invoice_jobs
    self.failed_jobs = self.failed_jobs.reject{|job| job[:invoice_id]}
  end

  def print(patient_letter_printer, insurance_recipe_printer)
    clean_failed_invoice_jobs

    invoices.each_with_index do |invoice, index|
      begin
        invoice.print(patient_letter_printer, insurance_recipe_printer)
      rescue RuntimeError => e
        failed_jobs << {:invoice_id => invoice.id, :message => e.message }
      end
    end
  end

  def create_invoices(treatments, value_date, tiers_name, provider, biller)
    treatments.each do |treatment_readonly|
      treatment = Treatment.find(treatment_readonly.id)

      invoice_params = {
        :value_date => value_date,
        :tiers_attributes => {
          :provider_id => provider.id,
          :biller_id => biller.id
        }
      }

      # Create invoice
      invoice = Invoice.create_from_treatment(invoice_params, treatment)

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
