# -*- encoding : utf-8 -*-
class CreateInvoiceBatchJobs < ActiveRecord::Migration
  def self.up
    create_table :invoice_batch_jobs do |t|
      t.date :value_date
      t.integer :count
      t.string :tiers_name

      t.timestamps
    end
    
    create_table :invoice_batch_jobs_invoices, :id => false do |t|
      t.integer :invoice_batch_job_id
      t.integer :invoice_id
    end

    add_index :invoice_batch_jobs_invoices, [:invoice_batch_job_id, :invoice_id]
  end

  def self.down
    drop_table :invoice_batch_jobs_invoices
    drop_table :invoice_batch_jobs
  end
end
