class ServiceItemsController < ApplicationController
  # DELETE /service_item/id
  def destroy
    @service_item = ServiceItem.find(params[:id])
    @service_item.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "service_item_#{@service_item.id}"
        end
      }
    end
  end
end
