# encoding: UTF-8

class AddDeltaToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :delta, :boolean, :default => true, :null => false
  end
end
