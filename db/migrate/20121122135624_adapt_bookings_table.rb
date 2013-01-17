# -*- encoding : utf-8 -*-
class AdaptBookingsTable < ActiveRecord::Migration
  def up
    add_column :bookings, :code, :string
    change_column :bookings, :comments, :text
  end
end
