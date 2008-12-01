class AddTypeToTariffItems < ActiveRecord::Migration
  def self.up
    add_column :tariff_items, :type, :string
  end

  def self.down
    remove_column :tariff_items, :type
  end
end
