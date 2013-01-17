# -*- encoding : utf-8 -*-
class CreateRecordTarmeds < ActiveRecord::Migration
  def self.up
    create_table :record_tarmeds do |t|
      t.string :treatment
      t.string :tariff_type
      t.string :tariff_version
      t.string :contract_number
      t.string :code
      t.string :ref_code
      t.integer :session
      t.float :quantity
      t.datetime :date
      t.integer :provider_id
      t.integer :responsible_id
      t.integer :location_id
      t.string :billing_role
      t.string :medical_role
      t.string :body_location
      t.float :unit_tm
      t.float :unit_factor_mt
      t.float :scale_factor_mt
      t.float :external_factor_mt
      t.float :amount_mt
      t.float :unit_tt
      t.float :unit_factor_tt
      t.float :scale_factor_tt
      t.float :external_factor_tt
      t.float :amount_tt
      t.float :amount
      t.float :vat_rate
      t.float :splitting_factor
      t.boolean :validate
      t.boolean :obligation
      t.string :section_code
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :record_tarmeds
  end
end
