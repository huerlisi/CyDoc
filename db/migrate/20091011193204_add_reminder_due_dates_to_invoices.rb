class AddReminderDueDatesToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :reminder_due_date, :date
    add_column :invoices, :second_reminder_due_date, :date
    add_column :invoices, :third_reminder_due_date, :date
  end

  def self.down
    remove_column :invoices, :third_reminder_due_date
    remove_column :invoices, :second_reminder_due_date
    remove_column :invoices, :reminder_due_date
  end
end
