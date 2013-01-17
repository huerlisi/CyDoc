# -*- encoding : utf-8 -*-
class CreatePolymorphicUserAssociation < ActiveRecord::Migration
  def self.up
    add_column :users, :object_id, :integer
    add_column :users, :object_type, :string

    remove_column :employees, :user_id
  end

  def self.down
    remove_column :users, :object_id
    remove_column :users, :object_type

    add_column :users, :user_id, :integer
  end
end
