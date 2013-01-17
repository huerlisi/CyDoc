# -*- encoding : utf-8 -*-
class AddIndexOnInvoicesSessions < ActiveRecord::Migration
  def self.up
    add_index :invoices_sessions, :invoice_id
    add_index :invoices_sessions, :session_id
  end

  def self.down
    remove_index :invoices_sessions, :invoice_id
    remove_index :invoices_sessions, :session_id
  end
end
