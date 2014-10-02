class AddTariffItemIdToServiceRecords < ActiveRecord::Migration
  def change
    add_column :service_records, :tariff_item_id, :integer
    ServiceRecord.connection.execute('UPDATE service_records SET tariff_item_id = (SELECT id FROM tariff_items WHERE tariff_items.code = service_records.code LIMIT 1)')
  end
end
