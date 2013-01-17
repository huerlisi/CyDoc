# -*- encoding : utf-8 -*-
class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      # Generic
      t.string :number

      # For BankAccount
      t.integer :bank_id
      t.integer :holder_vcard_id

      # ESR
      t.string :esr_id
      t.string :pc_id
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
