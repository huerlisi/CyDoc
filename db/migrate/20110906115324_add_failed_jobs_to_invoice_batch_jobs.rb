# -*- encoding : utf-8 -*-
class AddFailedJobsToInvoiceBatchJobs < ActiveRecord::Migration
  def self.up
    add_column :invoice_batch_jobs, :failed_jobs, :text
  end

  def self.down
    remove_column :invoice_batch_jobs, :failed_jobs
  end
end
