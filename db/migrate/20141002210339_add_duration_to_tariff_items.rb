class AddDurationToTariffItems < ActiveRecord::Migration
  def change
    add_column :tariff_items, :duration_from, :date
    add_column :tariff_items, :duration_to, :date
  end
end
