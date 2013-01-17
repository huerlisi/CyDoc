# -*- encoding : utf-8 -*-
class CreateTariffCodes < ActiveRecord::Migration
  def self.up
    create_table :tariff_codes do |t|
      t.string :tariff_code
      t.string :record_type_v4
      t.string :record_type_v5
      t.string :description
      t.date :valid_from
      t.date :valid_to

      t.timestamps
    end
  end

  def self.down
    drop_table :tariff_codes
  end
end
