# -*- encoding : utf-8 -*-
class AddImportedIdToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :imported_id, :integer
  end

  def self.down
    remove_column :invoices, :imported_id
  end
end
