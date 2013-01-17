# -*- encoding : utf-8 -*-
class CreateDrugProducts < ActiveRecord::Migration
  def self.up
    create_table :drug_products do |t|
      t.text :description
      t.string :name
      t.string :second_name
      t.string :size
      t.string :info
      t.boolean :original
      t.string :generic_group
      t.integer :drug_code1_id
      t.integer :drug_code2_id
      t.integer :therap_code1_id
      t.integer :therap_code2_id
      t.integer :drug_compendium_id
      t.string :application_code
      t.float :dose_amount
      t.string :dose_units
      t.string :dose_application
      t.integer :interaction_relevance
      t.boolean :active
      t.integer :partner_id
      t.integer :drug_monograph_id
      t.boolean :galenic
      t.integer :galenic_code_id
      t.float :concentration
      t.string :concentration_unit
      t.string :special_drug_group_code
      t.string :drug_for
      t.boolean :probe_suited
      t.float :life_span
      t.float :application_time
      t.string :excip_text
      t.string :excip_quantity
      t.string :excip_comment

      t.timestamps
    end
  end

  def self.down
    drop_table :drug_products
  end
end
