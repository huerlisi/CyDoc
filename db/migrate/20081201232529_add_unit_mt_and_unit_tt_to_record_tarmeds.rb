# -*- encoding : utf-8 -*-
class AddUnitMtAndUnitTtToRecordTarmeds < ActiveRecord::Migration
  def self.up
    add_column :record_tarmeds, :unit_mt, :float, :null => false
    add_column :record_tarmeds, :unit_tt, :float, :null => false
  end

  def self.down
    remove_column :record_tarmeds, :unit_mt
    remove_column :record_tarmeds, :unit_tt
  end
end
