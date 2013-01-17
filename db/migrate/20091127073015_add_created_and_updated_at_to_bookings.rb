# -*- encoding : utf-8 -*-
class AddCreatedAndUpdatedAtToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :created_at, :datetime
    add_column :bookings, :updated_at, :datetime
  end

  def self.down
    remove_column :bookings, :updated_at
    remove_column :bookings, :created_at
  end
end
