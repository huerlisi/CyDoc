# -*- encoding : utf-8 -*-
class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table "bookings", :force => true do |t|
      t.column "title",             :string,  :limit => 100
      t.column "amount",            :float
      t.column "credit_account_id", :integer
      t.column "debit_account_id",  :integer
      t.column "value_date",        :date
      t.column "comments",          :string,  :limit => 1000, :default => ""
    end
    add_index :bookings, :credit_account_id
    add_index :bookings, :debit_account_id
  end

  def self.down
    drop_table "bookings"
  end
end
