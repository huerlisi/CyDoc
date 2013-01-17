# -*- encoding : utf-8 -*-
class InvoiceReplacedByToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :invoice_replaced_by, :integer
  end

  def self.down
    remove_column :invoices, :invoice_replaced_by
  end
end
