class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table "patients", :force => true do |t|
      t.date "birth_date"
      t.integer "doctor_id"
      t.integer "vcard_id", "billing_vcard_id"
      t.integer "insurance_id"
      t.string "insurance_nr", "doctor_patient_nr"
      t.integer "sex", "only_year_of_birth"
      t.text "remarks"
      t.boolean "dunning_stop", "use_billing_address", "deceased", :default => false

      t.timestamps
    end

    add_index "patients", "updated_at"
    add_index "patients", "vcard_id"
    add_index "patients", "billing_vcard_id"
    add_index "patients", "doctor_id"
    add_index "patients", "insurance_id"
  end

  def self.down
    drop_table "patients"
  end
end
