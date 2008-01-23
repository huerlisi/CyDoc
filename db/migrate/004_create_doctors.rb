class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table "doctors", :force => true do |t|
      t.string "code", "speciality"
      t.integer "praxis_vcard", "private_vcard", "billing_doctor_id"
      t.boolean "active", :default => true

      t.timestamps

    end

    add_index "doctors", "praxis_vcard"
    add_index "doctors", "private_vcard"
  end

  def self.down
    drop_table :doctors
  end
end
