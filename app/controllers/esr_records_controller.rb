class EsrRecordsController < ApplicationController
  # Inherited Resources
  inherit_resources
  respond_to :html, :js

  # Scopes
  has_scope :by_state

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
end
