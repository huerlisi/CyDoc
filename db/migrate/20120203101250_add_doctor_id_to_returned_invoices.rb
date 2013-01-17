# -*- encoding : utf-8 -*-
class AddDoctorIdToReturnedInvoices < ActiveRecord::Migration
  def self.up
    add_column :returned_invoices, :doctor_id, :integer
    add_index :returned_invoices, :doctor_id
  end

  def self.down
    remove_column :returned_invoices, :doctor_id
  end
end
