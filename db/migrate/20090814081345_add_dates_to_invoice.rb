class AddDatesToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :value_date, :date
    add_column :invoices, :due_date, :date
  end

  def self.down
    remove_column :invoices, :due_date
    remove_column :invoices, :value_date
  end
end
