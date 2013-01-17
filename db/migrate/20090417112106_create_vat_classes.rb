# -*- encoding : utf-8 -*-
class CreateVatClasses < ActiveRecord::Migration
  def self.up
    create_table :vat_classes do |t|
      t.date :valid_from
      t.float :rate
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :vat_classes
  end
end
