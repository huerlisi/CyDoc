# This migration comes from has_accounts (originally 20130707121400)
class CreateBookingTemplates < ActiveRecord::Migration
  def change
    create_table :booking_templates do |t|
      t.string   "title"
      t.string   "amount"
      t.integer  "credit_account_id"
      t.integer  "debit_account_id"
      t.text     "comments"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
      t.string   "code"
      t.string   "matcher"
      t.string   "amount_relates_to"
      t.string   "type"
      t.string   "charge_rate_code"
      t.string   "salary_declaration_code"
      t.integer  "position"

      t.timestamps
    end
  end
end
