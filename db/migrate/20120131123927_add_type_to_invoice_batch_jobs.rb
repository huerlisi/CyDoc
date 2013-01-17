# -*- encoding : utf-8 -*-
class AddTypeToInvoiceBatchJobs < ActiveRecord::Migration
  def self.up
    add_column :invoice_batch_jobs, :type, :string
  end

  def self.down
    remove_column :invoice_batch_jobs, :type
  end
end
