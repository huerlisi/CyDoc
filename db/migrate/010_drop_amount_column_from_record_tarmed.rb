# -*- encoding : utf-8 -*-
class DropAmountColumnFromRecordTarmed < ActiveRecord::Migration
  def self.up
    remove_column :record_tarmeds, :amount
  end

  def self.down
  end
end
