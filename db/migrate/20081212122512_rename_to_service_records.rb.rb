# -*- encoding : utf-8 -*-
class RenameToServiceRecords < ActiveRecord::Migration
  def self.up
    rename_column :invoices_service_records, :record_tarmed_id, :service_record_id
  end

  def self.down
    rename_column :record_tarmed_id, :service_record_id, :invoices_service_records
  end
end
