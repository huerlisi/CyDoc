# -*- encoding : utf-8 -*-
class RenameRecordTarmedsToServiceRecords < ActiveRecord::Migration
  def self.up
    rename_table :record_tarmeds, :service_records
  end

  def self.down
    rename_table :service_records, :record_tarmeds
  end
end
