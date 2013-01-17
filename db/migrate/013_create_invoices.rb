# -*- encoding : utf-8 -*-
class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.text :remark
      t.integer :tiers_id
      t.integer :law_id
      t.integer :treatment_id
      t.text :role_title
      t.text :role_type
      t.text :place_type

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
