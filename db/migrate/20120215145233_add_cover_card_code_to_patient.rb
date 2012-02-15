class AddCoverCardCodeToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :covercard_code, :string
  end

  def self.down
    remove_column :patients, :covercard_code
  end
end
