class BookkeepingController < ApplicationController
  def report
    @total_invoiced    = -Invoice::EARNINGS_ACCOUNT.saldo('2009-01-01'..'2009-12-31')
    @total_paid        = Accounting::Account.find_by_code('1000').saldo('2009-01-01'..'2009-12-31') + Accounting::Account.find_by_code('1020').saldo('2009-01-01'..'2009-12-31')
    @open_items        = Invoice::DEBIT_ACCOUNT.saldo('2009-12-31')
    @debtors_write_off = Accounting::Account.find_by_code('3900').saldo('2009-01-01'..'2009-12-31')
    @started_work      = Session.find(:all, :conditions => "duration_from < '2009-12-31'").select{|s| s.treatment.invoices.empty?}.to_a.sum(&:amount)
    @drugs_stock       = Accounting::Account.find_by_code('1210').saldo('2009-12-31')
  end
end
