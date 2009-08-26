class AccountsController < ApplicationController
  def index
    @accounts = Accounting::Account.paginate(:page => params['page'], :per_page => 20, :order => 'updated_at DESC')
    
    respond_to do |format|
      format.html {
        render :action => 'list'
      }
    end
  end
end
