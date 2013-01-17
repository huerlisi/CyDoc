# -*- encoding : utf-8 -*-
class AddObjectTypeToVcards < ActiveRecord::Migration
  def self.up
    add_column :vcards, :object_type, :string
  end

  def self.down
    add_column :vcards, :object_type
  end
end
