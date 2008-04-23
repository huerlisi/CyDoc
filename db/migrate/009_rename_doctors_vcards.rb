class RenameDoctorsVcards < ActiveRecord::Migration
  def self.up
    rename_column :doctors, :praxis_vcard, :praxis_vcard_id
    rename_column :doctors, :private_vcard, :private_vcard_id
  end

  def self.down
    rename_column :doctors, :praxis_vcards_id, :praxis_vcard
    rename_column :doctors, :private_vcards_id, :private_vcard
  end
end
