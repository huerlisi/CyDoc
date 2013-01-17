# -*- encoding : utf-8 -*-
class AddRemarksToDoctor < ActiveRecord::Migration
  def self.up
    add_column :doctors, :remarks, :text
  end

  def self.down
    remove_column :doctors, :remarks
  end
end
