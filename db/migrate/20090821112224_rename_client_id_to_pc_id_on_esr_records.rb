# -*- encoding : utf-8 -*-
class RenameClientIdToPcIdOnEsrRecords < ActiveRecord::Migration
  def self.up
    rename_column :esr_records, :client_nr, :bank_pc_id
  end

  def self.down
    rename_column :esr_records, :bank_pc_id, :client_nr
  end
end
