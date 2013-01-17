# -*- encoding : utf-8 -*-
class AddIndicesToDrugTables < ActiveRecord::Migration
  def self.up
    add_index :drug_articles, :code
    
    add_index :drug_prices, :valid_from
  end

  def self.down
    drop_index :drug_articles, :code
    drop_index :drug_prices, :valid_from
  end
end
