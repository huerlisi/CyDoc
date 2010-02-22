class BookkeepingController < ApplicationController
  before_filter :set_value_date_range
  
  def set_value_date_range
    if params[:by_value_date]
      @value_date_begin, @value_date_end = params[:by_value_date].split('..')
    else
      @value_date_begin = Date.new(Date.today.year, 1, 1).strftime('%Y-%m-%d')
      @value_date_end   = Date.new(Date.today.year, 12, 31).strftime('%Y-%m-%d')
    end
    @value_date_range = @value_date_begin..@value_date_end
  end
  
  def report

    @total_invoiced    = -Invoice::EARNINGS_ACCOUNT.saldo(@value_date_range)
    @total_paid        = Accounting::Account.find_by_code('1000').saldo(@value_date_range) + Accounting::Account.find_by_code('1020').saldo(@value_date_range)
    @open_items        = Invoice::DEBIT_ACCOUNT.saldo(@value_date_end)
    @debtors_write_off = Accounting::Account.find_by_code('3900').saldo(@value_date_range)
    @started_work      = Session.find(:all, :conditions => ["duration_from < ?", @value_date_end]).select{|s| s.treatment.invoices.empty?}.to_a.sum(&:amount)
    @drugs_stock       = Accounting::Account.find_by_code('1210').saldo(@value_date_end)
  end

  def open_invoices
    @invoices = Invoice.find(:all, :conditions => ["value_date < ?", @value_date_end]).select{|i| i.due_amount(@value_date_end) != 0.0}
  end
end
