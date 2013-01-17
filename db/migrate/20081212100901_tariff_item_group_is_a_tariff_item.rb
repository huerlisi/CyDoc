# -*- encoding : utf-8 -*-
class TariffItemGroupIsATariffItem < ActiveRecord::Migration
  def self.up
    rename_table :tariff_item_groups_tariff_items, :tariff_items_tariff_items

    drop_table :tariff_item_groups
  end

  def self.down
    rename_table :tariff_items_tariff_items, :tariff_item_groups_tariff_items
  end
end
