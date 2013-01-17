# -*- encoding : utf-8 -*-
class CreateBanks < ActiveRecord::Migration
  def self.up
    create_table :banks do |t|
      t.integer :vcard_id

      t.timestamps
    end
  end

  def self.down
    drop_table :banks
  end
end
