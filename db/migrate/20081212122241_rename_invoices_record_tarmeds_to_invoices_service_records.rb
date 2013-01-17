# -*- encoding : utf-8 -*-
class RenameInvoicesRecordTarmedsToInvoicesServiceRecords < ActiveRecord::Migration
  def self.up
    rename_table :invoices_record_tarmeds, :invoices_service_records
  end

  def self.down
    rename_table :invoices_service_records, :invoices_record_tarmeds
  end
end
