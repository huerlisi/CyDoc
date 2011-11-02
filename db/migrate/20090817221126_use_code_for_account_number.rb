class UseCodeForAccountNumber < ActiveRecord::Migration
  def self.up
    add_column :accounts, :code, :string
  end

  def self.down
    remove_column :accounts, :code
  end
end
