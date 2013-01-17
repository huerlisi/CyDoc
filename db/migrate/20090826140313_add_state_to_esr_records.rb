# -*- encoding : utf-8 -*-
class AddStateToEsrRecords < ActiveRecord::Migration
  def self.up
    add_column :esr_records, :state, :string, :null => false
  end

  def self.down
    remove_column :esr_records, :state
  end
end
