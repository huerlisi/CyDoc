# Information about invoice batch printing jobs.
class InvoiceBatchJob < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :invoices
end
