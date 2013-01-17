# -*- encoding : utf-8 -*-
class CreateLaws < ActiveRecord::Migration
  def self.up
    create_table :laws do |t|
      t.string :insured_id
      t.string :case_id
      t.datetime :case_date
      t.string :ssn
      t.string :nif
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :laws
  end
end
