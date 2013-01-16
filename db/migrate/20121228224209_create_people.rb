class CreatePeople < ActiveRecord::Migration
  def up
    create_table "people" do |t|
      t.timestamps

      t.datetime "updated_at"
      t.string   "type"
      t.date     "date_of_birth"
      t.date     "date_of_death"
      t.integer  "sex"
      t.string   "social_security_nr"
      t.string   "social_security_nr_12"
      t.integer  "civil_status_id"
      t.integer  "religion_id"
      t.boolean  "delta",                 :default => true, :null => false
      t.string   "nationality"
      t.string   "swift"
      t.string   "clearing"
    end

    add_index "people", ["civil_status_id"], :name => "index_people_on_civil_status_id"
    add_index "people", ["religion_id"], :name => "index_people_on_religion_id"
    add_index "people", ["type"], :name => "index_people_on_type"
  end

  def down
    drop_table "people"
  end
end
