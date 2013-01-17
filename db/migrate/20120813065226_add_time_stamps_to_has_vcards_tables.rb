# -*- encoding : utf-8 -*-
class AddTimeStampsToHasVcardsTables < ActiveRecord::Migration
  def self.up
    add_column :addresses, :created_at, :datetime
    add_column :addresses, :updated_at, :datetime

    add_column :phone_numbers, :created_at, :datetime
    add_column :phone_numbers, :updated_at, :datetime

    add_column :vcards, :created_at, :datetime
    add_column :vcards, :updated_at, :datetime
  end

  def self.down
    remove_column :addresses, :created_at
    remove_column :addresses, :updated_at

    remove_column :phone_numbers, :created_at
    remove_column :phone_numbers, :updated_at

    remove_column :vcards, :created_at
    remove_column :vcards, :updated_at
  end
end
