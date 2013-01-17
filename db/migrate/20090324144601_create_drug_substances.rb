# -*- encoding : utf-8 -*-
class CreateDrugSubstances < ActiveRecord::Migration
  def self.up
    create_table :drug_substances, :id => false do |t|
      t.string :id
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :drug_substances
  end
end
