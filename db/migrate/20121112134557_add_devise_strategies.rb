# -*- encoding : utf-8 -*-
class AddDeviseStrategies < ActiveRecord::Migration
  def up
    # lockable
    add_column :users, :locked_at, :datetime
    add_column :users, :unlock_token, :string

    # trackable
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :sign_in_count, :integer, :default => 0
    add_column :users, :failed_attempts, :integer, :default => 0    
  end
end
