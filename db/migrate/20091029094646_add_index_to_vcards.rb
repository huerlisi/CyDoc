# -*- encoding : utf-8 -*-
class AddIndexToVcards < ActiveRecord::Migration
  def self.up
    add_index :vcards, [:object_id, :object_type]
  end

  def self.down
    remove_index :vcards, :column => [:object_id, :object_type]
  end
end
