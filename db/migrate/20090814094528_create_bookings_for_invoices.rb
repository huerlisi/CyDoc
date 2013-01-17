# -*- encoding : utf-8 -*-
class CreateBookingsForInvoices < ActiveRecord::Migration
  def self.up
    Accounting::Account.new(:number => Invoice::DEBIT_ACCOUNT, :title => 'Debitoren').save
    Accounting::Account.new(:number => Invoice::EARNINGS_ACCOUNT, :title => 'Dienstleistungsertrag').save
    
    Invoice.all.each {|i| i.build_booking.save}
  end

  def self.down
  end
end
