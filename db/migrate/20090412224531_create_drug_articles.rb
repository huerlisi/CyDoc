# -*- encoding : utf-8 -*-
class CreateDrugArticles < ActiveRecord::Migration
  def self.up
    create_table :drug_articles do |t|
      t.string :code
      t.string :group_code
      t.string :assort_key1
      t.string :assort_key2
      t.integer :drug_product_id
      t.string :swissmedic_cat
      t.string :swissmedic_no
      t.boolean :hospital_only
      t.boolean :clinical
      t.string :article_type
      t.integer :vat_class_id
      t.boolean :active
      t.boolean :insurance_limited
      t.float :insurance_limitation_points
      t.boolean :grand_frere
      t.boolean :stock_fridge
      t.string :stock_temperature
      t.boolean :narcotic
      t.boolean :under_bg
      t.integer :expires
      t.float :quantity
      t.text :description, :limit => 50
      t.text :name
      t.string :quantity_unit
      t.string :package_type
      t.string :multiply
      t.string :alias
      t.boolean :higher_co_payment
      t.integer :number_of_pieces

      t.timestamps
    end
  end

  def self.down
    drop_table :drug_articles
  end
end
