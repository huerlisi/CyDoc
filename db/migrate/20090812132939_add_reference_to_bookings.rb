# -*- encoding : utf-8 -*-
class AddReferenceToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :reference_id, :integer
    add_column :bookings, :reference_type, :string
  end

  def self.down
    remove_column :bookings, :reference_type
    remove_column :bookings, :reference_id
  end
end
