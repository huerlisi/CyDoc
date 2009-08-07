class ServiceItemsController < ApplicationController
  # GET /service_records/select
  def select
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'])
    @tariff_item = TariffItem.find(params[:tariff_item_id])
    
    # Show selection list only if more than one hit
    if @tariff_items.size == 1
      params[:tariff_item_id] = @tariff_items.first.id
      create
      return
    end
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "tariff_item_search_results", :partial => 'select_list'
        end
      }
    end
  end

  # GET /service_records/new
  def new
    @tariff_item = TariffItem.find(params[:tariff_item_id])
    @service_item = @tariff_item.service_items.build

    # Defaults
    @service_item.quantity = 1

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html "new_service_item", :partial => 'form'
        end
      }
    end
  end

  # POST /service_items
  def create
    @tariff_item = TariffItem.find(params[:tariff_item_id])
    
    tariff_item = TariffItem.find(params[:select_item_id])
    
    # TODO: Handle TariffItemGroups
    @service_item = @tariff_item.service_items.build(params[:service_item])
    @service_item.tariff_item = tariff_item
    @service_item.quantity = 1

    @service_item.save!

    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.insert_html :after, "service_items_list_header", :partial => 'service_items/item', :object => @service_item
          page.replace "service_items_list_footer", :partial => 'service_items/list_footer'
          page.remove "service_item_form"
        end
      }
    end
  end

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
