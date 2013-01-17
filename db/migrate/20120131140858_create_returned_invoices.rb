# -*- encoding : utf-8 -*-
class CreateReturnedInvoices < ActiveRecord::Migration
  def self.up
    create_table :returned_invoices do |t|
      t.string :state
      t.integer :invoice_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :returned_invoices
  end
end
