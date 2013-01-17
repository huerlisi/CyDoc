# -*- encoding : utf-8 -*-
class DropUnitXxColumnFromRecordTarmed < ActiveRecord::Migration
  def self.up
    remove_column :record_tarmeds, :unit_mt
    remove_column :record_tarmeds, :unit_tt
  end

  def self.down
  end
end
