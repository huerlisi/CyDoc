# -*- encoding : utf-8 -*-
class AddVatClassIdToTariffItems < ActiveRecord::Migration
  def self.up
    add_column :tariff_items, :vat_class_id, :integer
  end

  def self.down
    remove_column :tariff_items, :vat_class_id
  end
end
