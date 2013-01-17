# -*- encoding : utf-8 -*-
class ReworkTariffItemGroup < ActiveRecord::Migration
  def self.up
    rename_table 'tariff_items_tariff_items', 'tariff_item_groups_tariff_items'
    
    add_column :tariff_item_groups_tariff_items, :quantity, :float
    add_column :tariff_item_groups_tariff_items, :ref_code, :string, :limit => 10
  end

  def self.down
  end
end
