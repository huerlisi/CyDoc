class EsrRecordsController < ApplicationController
  # Inherited Resources
  inherit_resources
  respond_to :html, :js

  before_filter :only => [:index] do
    EsrRecord.update_unsolved_states
  end

  # Scopes
  def index
    @esr_records = EsrRecord.unsolved.paginate :page => params[:page], :order => 'state, value_date'
  end

  # State events
  def write_off
    @esr_record = EsrRecord.find(params[:id])
    @esr_record.invoice.write_off("Korrektur nach VESR Zahlung").save
    @esr_record.write_off!

    respond_to do |format|
      format.js {}
      format.html {redirect_to @esr_record.esr_file}
    end
  end

  def book_extra_earning
    @esr_record = EsrRecord.find(params[:id])
    if invoice = @esr_record.invoice
      @esr_record.invoice.book_extra_earning("Korrektur nach VESR Zahlung").save
    else
      @esr_record.create_extra_earning_booking
    end

    @esr_record.book_extra_earning!
    respond_to do |format|
      format.js {}
      format.html {redirect_to @esr_record.esr_file}
    end
  end

  def resolve
    @esr_record = EsrRecord.find(params[:id])
    @esr_record.resolve!

    respond_to do |format|
      format.js {}
      format.html {redirect_to @esr_record.esr_file}
    end
  end
end
