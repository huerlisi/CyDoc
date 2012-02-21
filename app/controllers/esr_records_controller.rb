class EsrRecordsController < ApplicationController
  # Inherited Resources
  inherit_resources

  # Scopes
  has_scope :by_state

  # State events
  def write_off
    @esr_record = EsrRecord.find(params[:id])
    @esr_record.invoice.write_off("Korrektur nach VESR Zahlung").save
    @esr_record.write_off!

    redirect_to @esr_record.esr_file
  end
end
