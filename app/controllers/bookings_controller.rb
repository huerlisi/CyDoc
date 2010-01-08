class BookingsController < ApplicationController
  in_place_edit_for :booking, :amount_as_string
  in_place_edit_for :booking, :value_date
  in_place_edit_for :booking, :title
  in_place_edit_for :booking, :comments

  # Filters
  before_filter Accounting::ValueDateFilter
  
  def for_value_date
    year = params[:year].to_i || Date.today.year
    Date.new(year, 1, 1)..Date.new(year, 12, 31)
  end

  # GET /bookings
  def index
    @bookings = Accounting::Booking.paginate(:page => params['page'], :per_page => 20, :order => 'value_date DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  # GET /bookings/new
  def new
    if params[:invoice_id]
      @invoice = Invoice.find(params[:invoice_id])
      @booking = @invoice.bookings.build
    else
      @booking = Accounting::Booking.new
    end
    
    @booking.value_date = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if @invoice
            page.insert_html :top, "invoice_#{@invoice.id}_booking_list", :partial => 'invoice_bookings/simple_form'
          end
        end
      }
    end
  end

  # PUT /booking
  def create
    if params[:invoice_id]
      @invoice = Invoice.find(params[:invoice_id])
      @booking = @invoice.bookings.build(params[:booking])
    else
      @booking = Accounting::Booking.new(params[:booking])
    end
    
    case @booking.title
      when "Barzahlung":
        @booking.credit_account = Accounting::Account.find_by_code('1000')
        @booking.debit_account = Accounting::Account.find_by_code('1100')
      when "Bankzahlung":
        @booking.credit_account = Accounting::Account.find_by_code('1020')
        @booking.debit_account = Accounting::Account.find_by_code('1100')
      when "Skonto/Rabatt":
        @booking.credit_account = Accounting::Account.find_by_code('3200')
        @booking.debit_account = Accounting::Account.find_by_code('1100')
      when "Zusatzleistung":
        @booking.credit_account = Accounting::Account.find_by_code('1100')
        @booking.debit_account = Accounting::Account.find_by_code('3200')
      when "Debitorenverlust":
        @booking.credit_account = Accounting::Account.find_by_code('3900') # Debitorenverlust
        @booking.debit_account = Accounting::Account.find_by_code('1100') # Debitor
      when "Rückerstattung":
        @booking.credit_account = Accounting::Account.find_by_code('1100') # Debitor
        @booking.debit_account = Accounting::Account.find_by_code('1020') # Bank
    end
    
    if @booking.save
      flash[:notice] = 'Buchung erfasst.'

      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            if @invoice
              @invoice.reload
              # TODO: Only works when @invoice is set
              page.replace "invoice_#{@invoice.id}_bookings", :partial => 'invoice_bookings/list', :object => @invoice.bookings
              page.remove 'booking_form'
              # TODO: some kind of delegation would be nice
              page.replace_html "invoice_#{@invoice.id}_state", @invoice.state
            end
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            if @invoice
              page.replace 'booking_form', :partial => 'invoice_bookings/simple_form', :object => @booking
            end
          end
        }
      end
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Accounting::Booking.find(params[:id])
    @account = Accounting::Account.find(params[:account_id])
    
    respond_to do |format|
      format.html {}
      format.js {
        render :update do |page|
          page.replace "booking_#{@booking.id}", :partial => 'edit'
        end
      }
    end
  end

  # PUSH /booking/1
  def update
    @booking = Accounting::Booking.find(params[:id])
    @account = Accounting::Account.find(params[:account_id])
    
    if @booking.update_attributes(params[:booking])
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            @bookings = @account.bookings.paginate(:page => params['page'], :per_page => 20, :order => 'value_date, id')
            page.replace 'booking_list', :partial => 'accounts/booking_list'
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace "booking_#{@booking.id}", :partial => 'edit'
          end
        }
      end
    end
  end
  
  # DELETE /booking/1
  def destroy
    @booking = Accounting::Booking.find(params[:id])
    @account = Accounting::Account.find(params[:account_id])

    @booking.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if @account
            @bookings = @account.bookings.paginate(:page => params['page'], :per_page => 20, :order => 'value_date, id')
            page.replace 'booking_list', :partial => 'accounts/booking_list'
          else
            page.remove "booking_#{@booking.id}"
            page.replace 'bookings_list_footer', :partial => 'bookings/list_footer'
          end
        end
      }
    end
  end
end
