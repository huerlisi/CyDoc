# -*- encoding : utf-8 -*-
class AddObjectIdToVcards < ActiveRecord::Migration
  def self.up
    add_column :vcards, :object_id, :integer
  end

  def self.down
    remove_column :vcards, :object_id
  end
end
