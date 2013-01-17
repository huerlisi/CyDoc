# -*- encoding : utf-8 -*-
class CreateTariffItems < ActiveRecord::Migration
  def self.up
    create_table :tariff_items do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.float :amount
      t.float :tp_al
      t.float :tp_tl

      t.timestamps
    end
  end

  def self.down
    drop_table :tariff_items
  end
end
