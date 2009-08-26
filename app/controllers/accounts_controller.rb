class AccountsController < ApplicationController
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

    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js { }
    end
  end
end
