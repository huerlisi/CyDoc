class AddVcardTypeToVcards < ActiveRecord::Migration
  def self.up
    add_column :vcards, :vcard_type, :string
  end

  def self.down
    remove_column :vcards, :vcard_type
  end
end
