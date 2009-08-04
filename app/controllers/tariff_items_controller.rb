class TariffItemsController < ApplicationController
  # GET /tariff_items
  def search
    query = params[:query]
    query ||= params[:search][:query] if params[:search]

    @tariff_items = TariffItem.clever_find(query).paginate(:page => params['page'], :per_page => 25)
    
    # Show selection list only if more than one hit
    if @tariff_items.size == 1
      params[:id] = @tariff_items.first.id
      show
      return
    end
      
    respond_to do |format|
      format.html {
        render :action => 'list'
        return
      }
      format.js {
        render :update do |page|
          page.replace_html 'search_results', :partial => 'list'
          page.replace_html 'tariff_item_view', ''
        end
      }
    end
  end

  # GET /tariff_item/id
  def show
    @tariff_item = TariffItem.find(params[:id])
    
    respond_to do |format|
      format.html { }
      format.js {
        render :update do |page|
          page.replace_html 'tariff_item_view', :partial => 'show'
          page.replace_html 'search_results', ''
        end
      }
    end
  end
end
