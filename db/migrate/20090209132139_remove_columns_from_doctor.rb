# -*- encoding : utf-8 -*-
class RemoveColumnsFromDoctor < ActiveRecord::Migration
  def self.up
    remove_column :doctors, :password
  end

  def self.down
    add_column :doctors, :password, :string
  end
end
