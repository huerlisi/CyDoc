# -*- encoding : utf-8 -*-
class AddNameToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :name, :string
  end

  def self.down
    remove_column :patients, :name
  end
end
