# -*- encoding : utf-8 -*-
class CreateDiagnoses < ActiveRecord::Migration
  def self.up
    create_table :diagnoses do |t|
      t.string :type
      t.string :code
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnoses
  end
end
