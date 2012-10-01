class AccountsController < ApplicationController
  in_place_edit_for :booking, :amount_as_string
  in_place_edit_for :booking, :value_date
  in_place_edit_for :booking, :title
  in_place_edit_for :booking, :comments

  # Scopes
  has_scope :by_value_period, :using => [:from, :to], :default => proc { |c| c.session[:has_scope] }

  # GET /accounts
  def index
    @accounts = Account.paginate(:page => params['page'], :per_page => 20, :order => 'code')

    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  # GET /accounts/1
  def show
    @account = Account.find(params[:id])

    @bookings = apply_scopes(Booking).by_account(@account).paginate(:page => params['page'], :per_page => 20, :order => 'value_date, id')
    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js { }
    end
  end

  # POST /account/print/1
  def print
    @account = Account.find(params[:id])
    @bookings = apply_scopes(Booking).by_account(@account).all(:order => 'value_date, id')

    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js {
        render :update do |page|
          page.replace 'booking_list', :partial => 'booking_list'
          page.call 'window.print'
        end
      }
    end
  end
end
