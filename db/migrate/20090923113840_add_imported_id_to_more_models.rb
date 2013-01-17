# -*- encoding : utf-8 -*-
class AddImportedIdToMoreModels < ActiveRecord::Migration
  def self.up
    add_column :doctors, :imported_id, :integer
    add_index :doctors, :imported_id

    add_column :insurances, :imported_id, :integer
    add_index :insurances, :imported_id
  end

  def self.down
    remove_column :doctors, :imported_id
    remove_column :insurances, :imported_id
  end
end
