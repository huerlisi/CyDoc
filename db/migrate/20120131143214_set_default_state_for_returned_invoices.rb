class SetDefaultStateForReturnedInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :returned_invoices, :state, 'new'
  end

  def self.down
  end
end
