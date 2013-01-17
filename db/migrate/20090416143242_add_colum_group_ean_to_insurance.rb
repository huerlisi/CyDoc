# -*- encoding : utf-8 -*-
class AddColumGroupEanToInsurance < ActiveRecord::Migration
  def self.up
    add_column :insurances, :group_ean_party, :string, :limit => 13
    remove_column :insurances, :group_id
  end

  def self.down
    remove_column :insurances, :group_ean_party
  end
end
