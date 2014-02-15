class BookkeepingController < ApplicationController
  before_filter :set_value_period
  
  def set_value_period
    if by_value_period = params[:by_value_period]
      @value_date_begin = by_value_period[:from]
      @value_date_end   = by_value_period[:to]
    else
      @value_date_begin = Date.new(Date.today.year, 1, 1).strftime('%Y-%m-%d')
      @value_date_end   = Date.new(Date.today.year, 12, 31).strftime('%Y-%m-%d')
    end
    @value_date_range = @value_date_begin..@value_date_end
  end
  
  def report
    @total_invoiced    = -Invoice::EARNINGS_ACCOUNT.saldo(@value_date_range)
    @total_paid        = Account.find_by_code('1000').saldo(@value_date_range) + Account.find_by_code('1020').saldo(@value_date_range) + Account.find_by_code('1021').saldo(@value_date_range)

    @open_items        = Invoice::DEBIT_ACCOUNT.saldo(@value_date_end)
    @debtors_write_off = Account.find_by_code('3900').saldo(@value_date_range)
    @started_work      = Session.find(:all, :include => :invoices, :conditions => ["duration_from <= ? AND invoices.value_date <= ? AND invoices.id IS NULL", @value_date_end, @value_date_end]).to_a.sum(&:amount)
    @drugs_stock       = Account.find_by_code('1210').saldo(@value_date_end)
    @special_earnings  = -Account.find_by_code('8000').saldo(@value_date_range)
  end

  def open_invoices
    # TODO: hardcoded account id for debit account
    @invoices = Invoice.find(:all,
      :joins => :bookings,
      :conditions => ["invoices.value_date <= ? AND bookings.value_date <= ?", @value_date_end, @value_date_end],
      :group => "reference_id, reference_type",
      :having => "sum(IF(bookings.debit_account_id = 3, bookings.amount, -bookings.amount)) != 0"
    ).paginate(:page => params['page'], :per_page => params['per_page'] || 30)
  end

  def open_invoices_csv
    @invoices = Invoice.find(:all,
      :select => "invoices.*, sum(IF(bookings.debit_account_id = 3, -bookings.amount, bookings.amount)) AS current_due_amount",
      :joins => :bookings,
      :conditions => ["invoices.value_date <= ? AND bookings.value_date <= ?", @value_date_end, @value_date_end],
      :group => "reference_id, reference_type",
      :having => "sum(IF(bookings.debit_account_id = 3, bookings.amount, -bookings.amount)) != 0"
    )
    send_csv @invoices, :only => ["patient.to_s", :value_date, :due_date, :id, :amount, :current_due_amount], :filename => "Offene Posten per %s.csv" % [@value_end_date]
  end

  def write_all_off
    value_date = Date.parse(params[:value_date])
    up_to_value_date = params[:up_to_value_date]
    year = value_date.year

    invoices = Invoice.find(:all,
      :joins => :bookings,
      :conditions => ["invoices.value_date <= ? AND bookings.value_date <= ?", up_to_value_date, value_date],
      :group => "reference_id, reference_type",
      :having => "sum(IF(bookings.debit_account_id = 3, bookings.amount, -bookings.amount)) != 0"
    )

    for ro_invoice in invoices
      # We get readonly record, and therefore need to load them again
      invoice = Invoice.find ro_invoice.id

      if invoice.due_amount > 0
	invoice.write_off "Jahresabschluss #{year}", value_date
      else
	invoice.book_extra_earning "Jahresabschluss #{year}", value_date
      end

      invoice.save!
    end

    redirect_to :action => 'open_invoices'
  end
end
