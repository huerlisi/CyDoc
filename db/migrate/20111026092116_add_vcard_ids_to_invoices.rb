# -*- encoding : utf-8 -*-
class AddVcardIdsToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :patient_vcard_id, :integer
    add_column :invoices, :billing_vcard_id, :integer
  end

  def self.down
    remove_column :invoices, :billing_vcard_id
    remove_column :invoices, :patient_vcard_id
  end
end
