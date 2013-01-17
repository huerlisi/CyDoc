# -*- encoding : utf-8 -*-
class SetDefaultsForRecordTarmed < ActiveRecord::Migration
  def self.up
    change_column_default :record_tarmeds, :quantity, 1
  end

  def self.down
  end
end
