# -*- encoding : utf-8 -*-
class CreateTariffItemGroups < ActiveRecord::Migration
  def self.up
    create_table :tariff_item_groups do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tariff_item_groups
  end
end
