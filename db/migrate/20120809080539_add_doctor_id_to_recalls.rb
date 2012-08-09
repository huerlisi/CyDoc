class AddDoctorIdToRecalls < ActiveRecord::Migration
  def self.up
    add_column :recalls, :doctor_id, :integer
    add_index :recalls, :doctor_id
  end

  def self.down
    remove_column :recalls, :doctor_id
  end
end
