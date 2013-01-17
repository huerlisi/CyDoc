# -*- encoding : utf-8 -*-
class UseServiceItemAsTariffGroupAssociation < ActiveRecord::Migration
  def self.up
    rename_table :tariff_item_groups_tariff_items, :service_items
  end

  def self.down
  end
end
