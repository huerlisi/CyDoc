# -*- encoding : utf-8 -*-
class PortToDevise < ActiveRecord::Migration
  def up
    #encrypting passwords and authentication related fields
    rename_column :users, "crypted_password", "encrypted_password"
    change_column :users, "encrypted_password", :string, :limit => 128, :default => "", :null => false
    rename_column :users, "salt", "password_salt"
    change_column :users, "password_salt", :string, :default => "", :null => false
    
    #confirmation related fields
    rename_column :users, "activation_code", "confirmation_token"
    rename_column :users, "activated_at", "confirmed_at"
    change_column :users, "confirmation_token", :string
    add_column    :users, "confirmation_sent_at", :datetime

    #reset password related fields
    add_column :users, "reset_password_token", :string
    
    #rememberme related fields
    add_column :users, "remember_created_at", :datetime #additional field required for devise.
  end
end
