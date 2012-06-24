class DropInheritedLawClasses < ActiveRecord::Migration
  def self.up
    rename_column :laws, :type, :code
  end

  def self.down
    rename_column :laws, :code, :type
  end
end
