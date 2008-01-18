class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers, :force => true do |t|
      t.string "phone_number_type"
      t.string "number", :limit => 50
      t.integer "vcard_id"
                                          
      t.timestamps
    end

    add_index "phone_numbers", "vcard_id"
  end

  def self.down
    drop_table :phone_numbers
  end
end
