# -*- encoding : utf-8 -*-
class AddEanPartyToInsurance < ActiveRecord::Migration
  def self.up
    add_column :insurances, :ean_party, :string, :limit => 13
  end

  def self.down
    remove_column :insurances, :ean_party
  end
end
