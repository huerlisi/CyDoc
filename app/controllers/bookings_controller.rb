include Accounting

class BookingsController < ApplicationController
  # GET /bookings/new
  def new
    if params[:invoice_id]
      @invoice = Invoice.find(params[:invoice_id])
      @booking = @invoice.bookings.build
    else
      @booking = Booking.new
    end
    
    @booking.value_date = Date.today
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :top, "booking_list", :partial => 'simple_form'
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
      @booking = Booking.new(params[:booking])
    end
    
    case @booking.title
      when "Barzahlung":
        @booking.debit_account = Account.find_by_code('1000')
        @booking.credit_account = Account.find_by_code('1100')
      when "Bankzahlung":
        @booking.debit_account = Account.find_by_code('1020')
        @booking.credit_account = Account.find_by_code('1100')
      when "Skonto/Rabatt":
        @booking.debit_account = Account.find_by_code('1100')
        @booking.credit_account = Account.find_by_code('3200')
        @booking.amount = 0.0 - @booking.amount
      when "Zusatzleistung":
        @booking.debit_account = Account.find_by_code('1100')
        @booking.credit_account = Account.find_by_code('3200')
    end
    
    if @booking.save
      flash[:notice] = 'Buchung erfasst.'

      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            @invoice.reload
            # TODO: Only works when @invoice is set
            page.replace 'bookings', :partial => 'bookings/list', :object => @invoice.bookings
            page.remove 'booking_form'
            # TODO: some kind of delegation would be nice
            page.replace_html "invoice_#{@invoice.id}_state", @invoice.state
          end
        }
      end
    else
      respond_to do |format|
        format.html { }
        format.js {
          render :update do |page|
            page.replace 'booking_form', :partial => 'bookings/simple_form', :object => @booking
          end
        }
      end
    end
  end


  # DELETE /booking/1
  def destroy
    @booking = Booking.find(params[:id])

    @booking.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "booking_#{@booking.id}"
#          page.replace 'bookings_list_footer', :partial => 'bookings/list_footer'
        end
      }
    end
  end
end
