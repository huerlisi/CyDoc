# -*- encoding : utf-8 -*-
class CreateTreatments < ActiveRecord::Migration
  def self.up
    create_table :treatments do |t|
      t.datetime :date_begin
      t.datetime :date_end
      t.string :canton
      t.string :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :treatments
  end
end
