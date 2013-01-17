# -*- encoding : utf-8 -*-
# This migration comes from has_accounts (originally 20111230222702)
class AddTemplateToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :template_id, :integer
    add_column :bookings, :template_type, :string

    add_index :bookings, [:template_id, :template_type]
  end
end
