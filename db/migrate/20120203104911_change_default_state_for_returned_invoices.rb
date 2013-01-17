# -*- encoding : utf-8 -*-
class ChangeDefaultStateForReturnedInvoices < ActiveRecord::Migration
  def self.up
    change_column_default :returned_invoices, :state, 'ready'
  end

  def self.down
  end
end
