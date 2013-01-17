# -*- encoding : utf-8 -*-
class AddStateToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :state, :string, :default => 'new'
  end

  def self.down
    remove_column :invoices, :state
  end
end
