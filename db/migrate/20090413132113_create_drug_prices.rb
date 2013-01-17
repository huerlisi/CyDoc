# -*- encoding : utf-8 -*-
class CreateDrugPrices < ActiveRecord::Migration
  def self.up
    create_table :drug_prices do |t|
      t.date :valid_from
      t.float :price
      t.string :price_type
      t.integer :drug_article_id

      t.timestamps
    end
  end

  def self.down
    drop_table :drug_prices
  end
end
