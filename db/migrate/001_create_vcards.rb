class CreateVcards < ActiveRecord::Migration
  def self.up
    create_table :vcards, :force => true do |t|
      t.string "full_name", "nickname","family_name", "given_name", "additional_name", "honorific_prefix", "honorific_suffix", :limit => 50
      t.integer "address_id"
                                          
      t.timestamps
    end
  end

  def self.down
    drop_table :vcards
  end
end
