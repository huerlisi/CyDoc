class AddBsvCodeToInsurance < ActiveRecord::Migration
  def self.up
    add_column :insurances, :bsv_code, :integer
  end

  def self.down
    remove_column :insurances, :bsv_code
  end
end
