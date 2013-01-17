# -*- encoding : utf-8 -*-
class AddImportedInvoiceIdToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :imported_invoice_id, :integer
  end

  def self.down
    remove_column :invoices, :imported_invoice_id
  end
end
