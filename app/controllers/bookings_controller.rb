class BookingsController < ApplicationController
  in_place_edit_for :booking, :amount_as_string
  in_place_edit_for :booking, :value_date
  in_place_edit_for :booking, :title
  in_place_edit_for :booking, :comments

  # Scopes
  has_scope :by_value_period, :using => [:from, :to], :default => proc { |c| c.session[:has_scope] }
  
  # GET /bookings
  def index
    @bookings = apply_scopes(Booking).paginate(:page => params['page'], :per_page => 20, :order => 'value_date DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  # GET /bookings/1
  def show
    @booking = Booking.find(params[:id])
  end
  
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
          if @invoice
            page.insert_html :top, "invoice_booking_list", :partial => 'invoice_bookings/simple_form'
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
      @booking = Booking.new(params[:booking])
    end
    
    case @booking.title
      when "Barzahlung":
        @booking.credit_account = Account.find_by_code('1000')
        @booking.debit_account = Account.find_by_code('1100')
      when "Bankzahlung":
        @booking.credit_account = Account.find_by_code('1020')
        @booking.debit_account = Account.find_by_code('1100')
      when "Skonto/Rabatt":
        @booking.credit_account = Account.find_by_code('3200')
        @booking.debit_account = Account.find_by_code('1100')
      when "Zusatzleistung":
        @booking.credit_account = Account.find_by_code('1100')
        @booking.debit_account = Account.find_by_code('3200')
      when "Debitorenverlust":
        @booking.credit_account = Account.find_by_code('3900') # Debitorenverlust
        @booking.debit_account = Account.find_by_code('1100') # Debitor
      when "Rückerstattung":
        @booking.credit_account = Account.find_by_code('1100') # Debitor
        @booking.debit_account = Account.find_by_code('1020') # Bank
    end
    
    if @booking.save
      flash[:notice] = 'Buchung erfasst.'

      respond_to do |format|
        format.html {
          redirect_to bookings_path
        }
        format.js {
          render :update do |page|
            if @invoice
              @invoice.reload
              page.replace "invoice_bookings", :partial => 'invoice_bookings/list', :object => @invoice.bookings
              page.remove 'booking_form'
              # TODO: some kind of delegation would be nice
              page.replace_html "invoice_state", t(@invoice.state, :scope => 'invoice.state')
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
    @booking = Booking.find(params[:id])
    @account = Account.find(params[:account_id]) if params[:account_id]
    
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
    @booking = Booking.find(params[:id])
    @account = Account.find(params[:account_id])
    
    @booking.reference.touch if @booking.reference
    if @booking.update_attributes(params[:booking])
      @booking.reference.touch if @booking.reference
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
    @booking = Booking.find(params[:id])

    @booking.destroy
    
    if params[:account_id]
      @account = Account.find(params[:account_id])
      @bookings = @account.bookings.paginate(:page => params['page'], :per_page => 20, :order => 'value_date, id')
    else
      @bookings = apply_scopes(Booking).paginate(:page => params['page'], :per_page => 20, :order => 'value_date DESC')
    end
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          if params[:account_id]
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
