# -*- encoding : utf-8 -*-
class CreateTariffItemGroupsTariffItems < ActiveRecord::Migration
  def self.up
    create_table :tariff_item_groups_tariff_items, :id => false do |t|
      t.integer :tariff_item_id
      t.integer :tariff_item_group_id
    end
  end

  def self.down
    drop_table :tariff_item_groups_tariff_items
  end
end
