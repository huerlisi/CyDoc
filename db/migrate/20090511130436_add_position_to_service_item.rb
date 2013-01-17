# -*- encoding : utf-8 -*-
class AddPositionToServiceItem < ActiveRecord::Migration
  def self.up
    add_column :service_items, :position, :integer
  end

  def self.down
    remove_column :service_items, :position
  end
end
