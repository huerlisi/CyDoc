# -*- encoding : utf-8 -*-
class AddEanPartyToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :ean_party, :string, :limit => 13
  end

  def self.down
  end
end
