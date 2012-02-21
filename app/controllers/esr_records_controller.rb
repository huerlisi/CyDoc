class EsrRecordsController < ApplicationController
  # Inherited Resources
  inherit_resources
  respond_to :html, :js

  before_filter :only => [:index] do
    EsrRecord.update_invalid_states
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
      format.html {redirect_to @esr_record.esr_file}
    end
  end

  def book_extra_earning
    @esr_record = EsrRecord.find(params[:id])
    @esr_record.invoice.book_extra_earning("Korrektur nach VESR Zahlung").save
    @esr_record.book_extra_earning!

    respond_to do |format|
      format.html {redirect_to @esr_record.esr_file}
    end
  end

  def resolve
    @esr_record = EsrRecord.find(params[:id])
    @esr_record.resolve!

    respond_to do |format|
      format.html {redirect_to @esr_record.esr_file}
    end
  end
end
