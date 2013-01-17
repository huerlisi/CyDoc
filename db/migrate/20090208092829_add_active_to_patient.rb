# -*- encoding : utf-8 -*-
class AddActiveToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :patients, :active
  end
end
