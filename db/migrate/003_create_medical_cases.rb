# -*- encoding : utf-8 -*-
class CreateMedicalCases < ActiveRecord::Migration
  def self.up
    create_table :medical_cases do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.datetime :duration_from
      t.datetime :duration_to
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :medical_cases
  end
end
