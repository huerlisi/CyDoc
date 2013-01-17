# -*- encoding : utf-8 -*-
class DropHabtmTableInvoicesTreatments < ActiveRecord::Migration
  def self.up
    drop_table :invoices_treatments
  end

  def self.down
  end
end
