# -*- encoding : utf-8 -*-
class AddOutOfSaleOnToDrugArticles < ActiveRecord::Migration
  def self.up
    add_column :drug_articles, :out_of_sale_on, :date
  end

  def self.down
    remove_column :drug_articles, :out_of_sale_on
  end
end
