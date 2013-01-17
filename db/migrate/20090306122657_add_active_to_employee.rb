# -*- encoding : utf-8 -*-
class AddActiveToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :active, :boolean, :default => true
  end

  def self.down
    remove_column :employees, :active
  end
end
