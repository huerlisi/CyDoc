# -*- encoding : utf-8 -*-
class AddAccountIdToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :account_id, :integer
  end

  def self.down
    remove_column :doctors, :account_id
  end
end
