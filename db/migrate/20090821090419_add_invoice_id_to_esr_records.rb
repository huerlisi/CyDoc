# -*- encoding : utf-8 -*-
class AddInvoiceIdToEsrRecords < ActiveRecord::Migration
  def self.up
    add_column :esr_records, :invoice_id, :integer
  end

  def self.down
    remove_column :esr_records, :invoice_id
  end
end
