# -*- encoding : utf-8 -*-
class AddTariffTypeToTariffItems < ActiveRecord::Migration
  def self.up
    add_column :tariff_items, :tariff_type, :string, :limit => 3
  end

  def self.down
    remove_column :tariff_items, :tariff_type
  end
end
