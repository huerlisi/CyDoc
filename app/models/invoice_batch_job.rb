# Information about invoice batch printing jobs.
class InvoiceBatchJob < ActiveRecord::Base
  # Columns
  serialize :failed_jobs

  # Associations
  has_and_belongs_to_many :invoices

  # Calculated columns
  def failed_job_count
    failed_jobs.size
  end
end
