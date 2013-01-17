# -*- encoding : utf-8 -*-
class GeneralizeTariffItems < ActiveRecord::Migration
  def self.up
    remove_column :tariff_items, :patient_id
    remove_column :tariff_items, :doctor_id
    remove_column :tariff_items, :amount

    rename_column :tariff_items, :tp_al, :amount_mt
    rename_column :tariff_items, :tp_tl, :amount_tt

    add_column :tariff_items, :code, :string, :limit => 10
    add_column :tariff_items, :remark, :text, :limit => 700
    add_column :tariff_items, :obligation, :boolean, :default => true

    add_column :tariff_items, :type, :string
  end

  def self.down
  end
end
