# -*- encoding : utf-8 -*-
class AddImportableColumnsToTariffItem < ActiveRecord::Migration
  def self.up
    add_column :tariff_items, :imported_id, :integer
    add_column :tariff_items, :imported_type, :string
  end

  def self.down
    remove_column :tariff_items, :imported_type
    remove_column :tariff_items, :imported_id
  end
end
