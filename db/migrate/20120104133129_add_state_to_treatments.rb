# -*- encoding : utf-8 -*-
class AddStateToTreatments < ActiveRecord::Migration
  def self.up
    add_column :treatments, :state, :string, :default => 'open'
    add_index :treatments, :state
  end

  def self.down
    remove_column :treatments, :state
  end
end
