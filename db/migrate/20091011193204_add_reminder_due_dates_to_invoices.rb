# -*- encoding : utf-8 -*-
class AddReminderDueDatesToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :reminder_due_date, :date
    add_column :invoices, :second_reminder_due_date, :date
    add_column :invoices, :third_reminder_due_date, :date

    for i in Invoice.find_all_by_state('reminded')
      reminder_date = i.bookings.find(:first, :conditions => "title LIKE '1. Mahnung%'").value_date
      i.reminder_due_date = reminder_date + Invoice::REMINDER_PAYMENT_PERIOD[i.state]
      i.save
    end
  end

  def self.down
    remove_column :invoices, :third_reminder_due_date
    remove_column :invoices, :second_reminder_due_date
    remove_column :invoices, :reminder_due_date
  end
end
