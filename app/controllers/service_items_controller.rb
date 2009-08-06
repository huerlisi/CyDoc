class ServiceItemsController < ApplicationController
  # DELETE /service_item/1
  def destroy
    @tariff_item = TariffItem.find(params[:tariff_item_id])
    @service_item = ServiceItem.find(params[:id])

    @service_item.destroy
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.remove "service_item_#{@service_item.id}"
          page.replace 'service_items_list_footer', :partial => 'service_items/list_footer'
        end
      }
    end
  end
end
