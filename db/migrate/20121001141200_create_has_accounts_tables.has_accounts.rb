# -*- encoding : utf-8 -*-
# This migration comes from has_accounts (originally 20111108000000)
#
# Has been adapted to only migrate changes
class CreateHasAccountsTables < ActiveRecord::Migration
  def self.up
    create_table "account_types" do |t|
      t.string   "name",       :limit => 100
      t.string   "title",      :limit => 100
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "account_types", "name"

    add_column :accounts, :parent_id, :integer
    add_column :accounts, :account_type_id, :integer
    add_column :accounts, :iban, :string

    add_index "accounts", ["account_type_id"], :name => "index_accounts_on_account_type_id"
    add_index "accounts", ["bank_id"], :name => "index_accounts_on_bank_id"
    add_index "accounts", ["code"], :name => "index_accounts_on_code"
    add_index "accounts", ["holder_id", "holder_type"], :name => "index_accounts_on_holder_id_and_holder_type"
    add_index "accounts", ["type"], :name => "index_accounts_on_type"

    add_column :banks, :swift, :string
    add_column :banks, :clearing, :string

    add_index "banks", :vcard_id

    add_column :bookings, :scan, :string
    add_column :bookings, :debit_currency, :string, :default => "CHF"
    add_column :bookings, :credit_currency, :string, :default => "CHF"
    add_column :bookings, :exchange_rate, :float, :default => 1.0

    add_index "bookings", ["value_date"], :name => "index_bookings_on_value_date"
  end
end
