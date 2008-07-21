class TariffItemsController < ApplicationController

  def new
  end

  def new_inline
    new
    render :layout => false
  end

  def edit
  end

  def edit_inline
    edit
    render :layout => false
  end

  def destroy
  end

  def destroy_inline
    destroy
    render :layout => false
  end
end
