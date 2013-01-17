# -*- encoding : utf-8 -*-
class LinkDrugArticlesToTariffItems < ActiveRecord::Migration
  def self.up
    DrugTariffItem.all.map{|t| a = DrugArticle.find_by_code(t.code); t.imported = a; t.save; puts "#{t.to_s} => #{a.to_s}"}
  end

  def self.down
  end
end
