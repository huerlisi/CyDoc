# -*- encoding : utf-8 -*-
class AddIndexToInvoiceServiceRecords < ActiveRecord::Migration
  def self.up
    add_index :invoices_service_records, :invoice_id
    add_index :invoices_service_records, :service_record_id
  end

  def self.down
    remove_index :invoices_service_records, :invoice_id
    remove_index :invoices_service_records, :service_record_id
  end
end
