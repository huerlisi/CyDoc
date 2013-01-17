# -*- encoding : utf-8 -*-
class CreateTiers < ActiveRecord::Migration
  def self.up
    create_table :tiers do |t|
      t.integer :biller_id
      t.integer :provider_id
      t.integer :insurance_id
      t.integer :patient_id
      t.integer :guarantor_id
      t.integer :referrer_id
      t.integer :employer_id
      t.string :type
      t.string :payment_periode
      t.boolean :invoice_modification

      t.timestamps
    end
  end

  def self.down
    drop_table :tiers
  end
end
