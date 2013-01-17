# -*- encoding : utf-8 -*-
class AddDatesToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :value_date, :date
    add_column :invoices, :due_date, :date

    Invoice.all.each {|i|
      i.value_date = i.created_at.to_date
      i.due_date = i.value_date + Invoice::PAYMENT_PERIOD
      i.save(false)
    }
  end

  def self.down
    remove_column :invoices, :due_date
    remove_column :invoices, :value_date
  end
end
