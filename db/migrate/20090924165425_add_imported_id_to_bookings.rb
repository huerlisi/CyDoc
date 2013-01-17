# -*- encoding : utf-8 -*-
class AddImportedIdToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :imported_id, :integer
  end

  def self.down
    remove_column :bookings, :imported_id
  end
end
