# -*- encoding : utf-8 -*-
class CreateInsurancePolicies < ActiveRecord::Migration
  def self.up
    create_table :insurance_policies do |t|
      t.integer :insurance_id
      t.integer :patient_id
      t.date :valid_from
      t.date :valid_to
      t.string :number
      t.string :policy_type

      t.timestamps
    end
  end

  def self.down
    drop_table :insurance_policies
  end
end
