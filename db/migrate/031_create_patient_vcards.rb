# -*- encoding : utf-8 -*-
class CreatePatientVcards < ActiveRecord::Migration
  def self.up
    create_table :patient_vcards do |t|
      t.integer :patient_id
      t.integer :vcard_id

      t.timestamps
    end
  end

  def self.down
    drop_table :patient_vcards
  end
end
