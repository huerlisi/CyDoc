class RenameNewStateToOpenInInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :invoices, :state, 'prepared'
  end

  def self.down
  end
end
