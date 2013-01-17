# -*- encoding : utf-8 -*-
class CreateConsultations < ActiveRecord::Migration
  def self.up
    create_table :consultations do |t|
      t.integer :patient_id
      t.datetime :duration_from
      t.datetime :duration_to
      t.integer :doctor_id
      t.text :remarks

      t.timestamps
    end
  end

  def self.down
    drop_table :consultations
  end
end
