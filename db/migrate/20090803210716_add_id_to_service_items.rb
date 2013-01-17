# -*- encoding : utf-8 -*-
class AddIdToServiceItems < ActiveRecord::Migration
  def self.up
    add_column :service_items, :id, :primary_key
  end

  def self.down
    remove_column :service_items, :id
  end
end
