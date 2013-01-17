# -*- encoding : utf-8 -*-
class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes do |t|
      t.string :zip_type
      t.string :zip
      t.string :zip_extension
      t.string :locality, :length => 18
      t.string :locality_long, :length => 27
      t.string :canton, :length => 2
      t.integer :imported_id

      t.timestamps
    end
  end

  def self.down
    drop_table :postal_codes
  end
end
