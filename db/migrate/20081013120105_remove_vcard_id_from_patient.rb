class RemoveVcardIdFromPatient < ActiveRecord::Migration
  def self.up
    remove_column :patients, :vcard_id
  end

  def self.down
  end
end
