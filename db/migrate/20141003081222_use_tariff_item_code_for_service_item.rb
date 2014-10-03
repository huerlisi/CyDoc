class UseTariffItemCodeForServiceItem < ActiveRecord::Migration
  def up
    add_column :service_items, :code, :string
    add_index :service_items, :code

    ServiceItem.connection.execute('UPDATE service_items SET code = (SELECT code FROM tariff_items WHERE tariff_items.id = service_items.tariff_item_id LIMIT 1)')
    remove_column :service_items, :tariff_item_id
  end
end
