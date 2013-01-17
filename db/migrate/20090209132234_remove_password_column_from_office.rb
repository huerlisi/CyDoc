# -*- encoding : utf-8 -*-
class RemovePasswordColumnFromOffice < ActiveRecord::Migration
  def self.up
    remove_column :offices, :password
  end

  def self.down
    add_column :offices, :password, :string
  end
end
