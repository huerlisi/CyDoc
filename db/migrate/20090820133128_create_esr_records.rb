# -*- encoding : utf-8 -*-
class CreateEsrRecords < ActiveRecord::Migration
  def self.up
    create_table :esr_records do |t|
      t.string :client_nr
      t.string :reference
      t.float :amount
      t.string :payment_reference
      t.date :payment_date
      t.date :transaction_date
      t.date :value_date
      t.string :microfilm_nr
      t.string :reject_code
      t.string :reserved
      t.string :payment_tax

      t.timestamps
    end
  end

  def self.down
    drop_table :esr_records
  end
end
