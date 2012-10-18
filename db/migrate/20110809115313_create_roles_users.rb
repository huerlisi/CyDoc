class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    add_index "roles", ["name"]

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "user_id"
    end

    add_index "roles_users", ["role_id"]
    add_index "roles_users", ["user_id"]
  end

  def self.down
    remove_index "roles", "name"

    drop_table "roles_users"
  end
end
