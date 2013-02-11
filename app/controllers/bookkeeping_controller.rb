# -*- encoding : utf-8 -*-
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
    @total_invoiced    = Account.find_by_code(current_tenant.settings['invoices.profit_account_code']).saldo(@value_date_range)
    @total_paid        = Account.find_by_code('1000').saldo(@value_date_range) + Account.find_by_code('1020').saldo(@value_date_range)
    @open_items        = Account.find_by_code(current_tenant.settings['invoices.balance_account_code']).saldo(@value_date_end)
    @debtors_write_off = Account.find_by_code('3900').saldo(@value_date_range)
    @started_work      = Session.all(:include => :invoices, :conditions => ["duration_from <= ? AND (invoices.value_date > ? OR invoices.id IS NULL)", @value_date_end, @value_date_end]).to_a.sum(&:amount)
    @drugs_stock       = Account.find_by_code('1210').saldo(@value_date_end)
    @special_earnings  = -Account.find_by_code('8000').saldo(@value_date_end) if Account.find_by_code('8000')
  end

  def open_invoices
    debit_account_id = Account.find_by_code(current_tenant.settings['invoices.balance_account_code']).id
    @invoices = Invoice
      .joins(:bookings)
      .where("invoices.value_date <= ? AND bookings.value_date <= ?", @value_date_end, @value_date_end)
      .group("reference_id, reference_type")
      .having("sum(IF(bookings.debit_account_id = ?, bookings.amount, -bookings.amount)) != 0", debit_account_id)
      .page(params[:page] || 0)
  end

  def open_invoices_csv
    debit_account_id = Account.find_by_code(current_tenant.settings['invoices.balance_account_code']).id
    @invoices = Invoice.all(
      :select => "invoices.*, sum(IF(bookings.debit_account_id = #{debit_account_id}, -bookings.amount, bookings.amount)) AS current_due_amount",
      :joins => :bookings,
      :conditions => ["invoices.value_date <= ? AND bookings.value_date <= ?", @value_date_end, @value_date_end],
      :group => "reference_id, reference_type",
      :having => ["sum(IF(bookings.debit_account_id = ?, bookings.amount, -bookings.amount)) != 0", debit_account_id]
    )
    send_csv @invoices, :only => ["patient.to_s", :value_date, :due_date, :id, :amount, :current_due_amount], :filename => "Offene Posten per %s.csv" % [@value_end_date]
  end
end
