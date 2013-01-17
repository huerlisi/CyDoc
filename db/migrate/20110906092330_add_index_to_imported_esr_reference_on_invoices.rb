# -*- encoding : utf-8 -*-
class AddIndexToImportedEsrReferenceOnInvoices < ActiveRecord::Migration
  def self.up
    add_index :invoices, :imported_esr_reference
  end

  def self.down
  end
end
