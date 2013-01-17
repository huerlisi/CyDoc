# -*- encoding : utf-8 -*-
class NoLimitForCodeInTariffItems < ActiveRecord::Migration
  def self.up
    change_column :tariff_items, :code, :string, :limit => nil
  end

  def self.down
  end
end
