# -*- encoding : utf-8 -*-
class AddStateToRecall < ActiveRecord::Migration
  def self.up
    add_column :recalls, :state, :string

    add_index :recalls, :state
  end

  def self.down
    remove_index :recalls, :state

    remove_column :recalls, :state
  end
end
