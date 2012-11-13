class RemoveNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string
  end
end
