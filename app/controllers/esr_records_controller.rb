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
    if @esr_record.create_write_off_booking
      @esr_record.write_off!

      respond_to do |format|
        format.js {}
        format.html {redirect_to @esr_record.esr_file}
      end
    else
      flash[:error] = 'Konnte Korrekturbuchung nicht erstellen.'

      respond_to do |format|
        format.js {
          render 'show_flash_message'
        }
        format.html {redirect_to @esr_record.esr_file}
      end
    end
  end

  def book_extra_earning
    @esr_record = EsrRecord.find(params[:id])

    if @esr_record.create_extra_earning_booking
      @esr_record.book_extra_earning!

      respond_to do |format|
        format.js {}
        format.html {redirect_to @esr_record.esr_file}
      end
    else
      flash[:error] = 'Konnte Korrekturbuchung nicht erstellen.'

      respond_to do |format|
        format.js {
          render 'show_flash_message'
        }
        format.html {redirect_to @esr_record.esr_file}
      end
    end
  end

  def book_payback
    @esr_record = EsrRecord.find(params[:id])

    if @esr_record.create_payback_booking
      @esr_record.book_payback!

      respond_to do |format|
        format.js {}
        format.html {redirect_to @esr_record.esr_file}
      end
    else
      flash[:error] = 'Konnte Rückzahlungsbuchung nicht erstellen.'

      respond_to do |format|
        format.js {
          render 'show_flash_message'
        }
        format.html {redirect_to @esr_record.esr_file}
      end
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
