class AddIndexOnTariffItemDuration < ActiveRecord::Migration
  def change
    add_index :tariff_items, :duration_from
    add_index :tariff_items, :duration_to
  end
end
