# -*- encoding : utf-8 -*-
class CreateHabtmTableInvoicesTreatments < ActiveRecord::Migration
  def self.up
    create_table "invoices_treatments", :id => false do |t|
      t.integer "invoice_id"
      t.integer "treatment_id"
    end
  end

  def self.down
  end
end
