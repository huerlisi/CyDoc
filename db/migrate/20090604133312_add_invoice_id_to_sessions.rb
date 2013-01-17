# -*- encoding : utf-8 -*-
class AddInvoiceIdToSessions < ActiveRecord::Migration
  def self.up
    add_column :sessions, :invoice_id, :integer
  end

  def self.down
    remove_column :sessions, :invoice_id
  end
end
