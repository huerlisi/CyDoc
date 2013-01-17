# -*- encoding : utf-8 -*-
class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.string  :type

      t.integer :update_count
      t.integer :create_count
      t.integer :delete_count
      t.integer :error_count
      t.string  :error_ids
      t.string  :error_messages

      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
