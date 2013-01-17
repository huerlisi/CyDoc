# -*- encoding : utf-8 -*-
class AddImportedIds < ActiveRecord::Migration
  def self.up
    add_column :patients, :imported_id, :integer
    add_column :treatments, :imported_id, :integer
    add_column :sessions, :imported_id, :integer
    add_column :service_records, :imported_id, :integer
    add_column :medical_cases, :imported_id, :integer
  end

  def self.down
    remove_column :patients, :imported_id
    remove_column :treatments, :imported_id
    remove_column :sessions, :imported_id
    remove_column :service_records, :imported_id
    remove_column :medical_cases, :imported_id
  end
end
