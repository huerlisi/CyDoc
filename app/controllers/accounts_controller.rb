class AccountsController < ApplicationController
  in_place_edit_for :booking, :amount_as_string
  in_place_edit_for :booking, :value_date
  in_place_edit_for :booking, :title
  in_place_edit_for :booking, :comments

  # Scopes
  has_scope :by_value_date, :type => :range, :session => 'has_scope'
  
  def set_value_date_filter
    apply_scopes(Accounting::Booking)
    
    redirect_to params[:uri]
  end
  
  # GET /accounts
  def index
    @accounts = Accounting::Account.paginate(:page => params['page'], :per_page => 20, :order => 'code')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end

  # GET /accounts/1
  def show
    @account = Accounting::Account.find(params[:id])
    
    # We're getting hit by will_paginate bug #120 (http://sod.lighthouseapp.com/projects/17958/tickets/120-paginate-association-with-finder_sql-raises-typeerror)
    # This needs the will_paginate version from http://github.com/jwood/will_paginate/tree/master to work.
    @bookings = apply_scopes(Accounting::Booking).by_account(@account).paginate(:page => params['page'], :per_page => 20, :order => 'value_date, id')
    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js { }
    end
  end
end
