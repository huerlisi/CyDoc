class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses, :force => true do |t|
      t.string "post_office_box", "extended_address", "street_address", "locality", "region", "postal_code", "country_name", :limit => 50
      t.integer "vcard_id"
      t.string "address_type"
                                          
      t.timestamps
    end

    add_index "addresses", "vcard_id"
  end

  def self.down
    drop_table :addresses
  end
end
