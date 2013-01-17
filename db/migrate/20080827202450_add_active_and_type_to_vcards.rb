# -*- encoding : utf-8 -*-
class AddActiveAndTypeToVcards < ActiveRecord::Migration
  def self.up
    add_column :vcards, :active, :boolean, :default => true
    add_column :vcards, :type, :string
  end

  def self.down
    remove_column :vcards, :active
    remove_column :vcards, :type
  end
end
