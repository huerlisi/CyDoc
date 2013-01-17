# -*- encoding : utf-8 -*-
class AddImportedEsrReferenceToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :imported_esr_reference, :string
  end

  def self.down
    remove_column :invoices, :imported_esr_reference
  end
end
