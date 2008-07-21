class TariffItemsController < ApplicationController

  def new
  end

  def new_inline
    new
    render :action => 'new', :layout => false
  end

  def edit
  end

  def edit_inline
    edit
    render :action => 'edit', :layout => false
  end

  def destroy
  end

  def destroy_inline
    destroy
    render :action => 'destroy', :layout => false
  end
end
