# -*- encoding : utf-8 -*-
class RenameNewStateToOpenInInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :invoices, :state, 'prepared'
    Invoice.update_all "state = 'prepared'", "state = 'new'"
  end

  def self.down
  end
end
