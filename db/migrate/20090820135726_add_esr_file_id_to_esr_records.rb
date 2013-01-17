# -*- encoding : utf-8 -*-
class AddEsrFileIdToEsrRecords < ActiveRecord::Migration
  def self.up
    add_column :esr_records, :esr_file_id, :integer
  end

  def self.down
    remove_column :esr_records, :esr_file_id
  end
end
