# -*- encoding : utf-8 -*-
class UseDecimalForCurrencyFields < ActiveRecord::Migration
  def self.up
    change_column :bookings, :amount, :decimal, :precision => 8, :scale => 2

    change_column :drug_prices, :price, :decimal, :precision => 8, :scale => 2

    change_column :esr_records, :amount, :decimal, :precision => 8, :scale => 2

    change_column :service_items, :quantity, :decimal, :precision => 8, :scale => 2

    change_column :service_records, :quantity, :decimal, :precision => 8, :scale => 2
    change_column :service_records, :unit_factor_mt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :scale_factor_mt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :external_factor_mt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :amount_mt, :decimal, :precision => 8, :scale => 2
    change_column :service_records, :unit_factor_tt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :scale_factor_tt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :external_factor_tt, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :amount_tt, :decimal, :precision => 8, :scale => 2
    change_column :service_records, :vat_rate, :decimal, :precision => 5, :scale => 2 # 0.00 - 100.00
    change_column :service_records, :splitting_factor, :decimal, :precision => 3, :scale => 2 # 0.00 - 1.00
    change_column :service_records, :unit_mt, :decimal, :precision => 8, :scale => 2
    change_column :service_records, :unit_tt, :decimal, :precision => 8, :scale => 2
    
    change_column :tariff_items, :amount_mt, :decimal, :precision => 8, :scale => 2
    change_column :tariff_items, :amount_tt, :decimal, :precision => 8, :scale => 2

    change_column :vat_classes, :rate, :decimal, :precision => 5, :scale => 2 # 0.00 - 100.00
  end

  def self.down
    change_column :bookings, :amount, :float

    change_column :drug_prices, :price, :float

    change_column :esr_records, :amount, :float

    change_column :service_items, :quantity, :float

    change_column :service_records, :quantity, :float
    change_column :service_records, :unit_factor_mt, :float
    change_column :service_records, :scale_factor_mt, :float
    change_column :service_records, :external_factor_mt, :float
    change_column :service_records, :amount_mt, :float
    change_column :service_records, :unit_factor_tt, :float
    change_column :service_records, :scale_factor_tt, :float
    change_column :service_records, :external_factor_tt, :float
    change_column :service_records, :amount_tt, :float
    change_column :service_records, :vat_rate, :float
    change_column :service_records, :splitting_factor, :float
    change_column :service_records, :unit_mt, :float
    change_column :service_records, :unit_tt, :float
    
    change_column :tariff_items, :amount_mt, :float
    change_column :tariff_items, :amount_tt, :float

    change_column :vat_classes, :rate, :float
  end
end
