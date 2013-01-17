# -*- encoding : utf-8 -*-
class SetInvoiceStateWrittenOff < ActiveRecord::Migration
  def self.up
    # Collect all invoices with write off bookings
    account = Account.find_by_code('3900')
    invoices = account.bookings.collect{|booking| booking.reference}

    # Only migrate invoices in known state
    clean_invoices = invoices.select{|invoice| invoice.state == 'paid' and invoice.due_amount == 0.0}

    # Mark as written off
    clean_invoices.map{|invoice| invoice.state = 'written_off'; invoice.save}
  end

  def self.down
  end
end
