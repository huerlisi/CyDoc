# -*- encoding : utf-8 -*-
class AddPrintersToOffice < ActiveRecord::Migration
  def self.up
    add_column :offices, :printers, :string
  end

  def self.down
    remove_column :offices, :printers
  end
end
