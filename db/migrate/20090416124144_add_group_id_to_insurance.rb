# -*- encoding : utf-8 -*-
class AddGroupIdToInsurance < ActiveRecord::Migration
  def self.up
    add_column :insurances, :group_id, :string, :limit => 13
  end

  def self.down
    remove_column :insurances, :group_id
  end
end
