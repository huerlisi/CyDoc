# -*- encoding : utf-8 -*-
class AddRoleToInsurance < ActiveRecord::Migration
  def self.up
    add_column :insurances, :role, :string
  end

  def self.down
    remove_column :insurances, :role
  end
end
