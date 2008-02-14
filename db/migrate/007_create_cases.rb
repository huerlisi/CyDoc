class CreateCases < ActiveRecord::Migration
  def self.up
    create_table :cases do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.integer :screener_id
      t.integer :insurance_id
      t.string :insurance_nr
      t.integer :classification_id
      t.boolean :needs_p16
      t.text :finding_text
      t.datetime :screened_at
      t.datetime :examined_at
      t.string :praxistar_eingangsnr

      t.timestamps
    end
  end

  def self.down
    drop_table :cases
  end
end
