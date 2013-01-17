# -*- encoding : utf-8 -*-
class AddIndexOnValueDateToInvoices < ActiveRecord::Migration
  def self.up
    add_index :invoices, :value_date
  end

  def self.down
  end
end
