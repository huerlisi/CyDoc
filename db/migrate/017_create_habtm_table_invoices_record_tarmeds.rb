# -*- encoding : utf-8 -*-
class CreateHabtmTableInvoicesRecordTarmeds < ActiveRecord::Migration
  def self.up
    create_table "invoices_record_tarmeds", :id => false do |t|
      t.integer "invoice_id"
      t.integer "record_tarmed_id"
    end
  end

  def self.down
  end
end
