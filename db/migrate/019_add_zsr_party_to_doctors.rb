# -*- encoding : utf-8 -*-
class AddZsrPartyToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :zsr, :string, :limit => 7
  end

  def self.down
  end
end
