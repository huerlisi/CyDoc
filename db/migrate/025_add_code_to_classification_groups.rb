# -*- encoding : utf-8 -*-
class AddCodeToClassificationGroups < ActiveRecord::Migration
  def self.up
    add_column :classification_groups, :code, :string
  end

  def self.down
    remove_column :classification_groups, :code
  end
end
