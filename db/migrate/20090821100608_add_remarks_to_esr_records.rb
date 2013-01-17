# -*- encoding : utf-8 -*-
class AddRemarksToEsrRecords < ActiveRecord::Migration
  def self.up
    add_column :esr_records, :remarks, :string
  end

  def self.down
    remove_column :esr_records, :remarks
  end
end
