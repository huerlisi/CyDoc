# -*- encoding : utf-8 -*-
class RemoveAccountIdFromDoctor < ActiveRecord::Migration
  def self.up
    remove_column :doctors, :account_id
  end

  def self.down
    add_column :doctors, :account_id, :integer
  end
end
